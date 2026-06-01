import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// ── Tables ────────────────────────────────────────────────────────────────────

/// Mirrors the Supabase food_logs table for offline write-first.
class LocalFoodLogs extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get foodId => text().nullable()();
  TextColumn get portionId => text().nullable()();
  RealColumn get quantity => real().withDefault(const Constant(1.0))();
  RealColumn get caloriesConfirmed => real()();
  RealColumn get proteinG => real()();
  RealColumn get carbsG => real()();
  RealColumn get fatG => real()();
  TextColumn get mealType => text()();
  TextColumn get loggedAt => text()(); // yyyy-MM-dd
  TextColumn get loggedVia => text()();
  TextColumn get foodName => text().nullable()();
  TextColumn get foodNameNe => text().nullable()();
  TextColumn get portionLabel => text().nullable()();

  /// false = not yet pushed to Supabase; true = synced.
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Mirrors the Supabase weight_logs table for offline write-first.
class LocalWeightLogs extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  RealColumn get weightKg => real()();
  TextColumn get loggedAt => text()(); // yyyy-MM-dd
  TextColumn get notes => text().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Pending operations to replay when connectivity is restored.
class SyncQueueEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  /// 'food_logs' | 'weight_logs'
  TextColumn get targetTable => text()();
  /// 'insert' | 'delete'
  TextColumn get operation => text()();
  /// Matches the local UUID in LocalFoodLogs or LocalWeightLogs.
  TextColumn get localId => text()();
  IntColumn get retries => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

// ── Database ──────────────────────────────────────────────────────────────────

@DriftDatabase(tables: [LocalFoodLogs, LocalWeightLogs, SyncQueueEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, 'dalbhat_fit.db'));
      return NativeDatabase.createInBackground(file);
    });
  }

  // ── Food log helpers ────────────────────────────────────────────────────────

  Future<void> insertLocalFoodLog(LocalFoodLogsCompanion entry) =>
      into(localFoodLogs).insertOnConflictUpdate(entry);

  Future<List<LocalFoodLog>> getUnsyncedFoodLogs() =>
      (select(localFoodLogs)..where((t) => t.synced.equals(false))).get();

  Future<List<LocalFoodLog>> getTodayFoodLogs(String userId) {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    return (select(localFoodLogs)
          ..where((t) => t.userId.equals(userId) & t.loggedAt.equals(today))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
        .get();
  }

  Future<void> markFoodLogSynced(String id) => (update(localFoodLogs)
        ..where((t) => t.id.equals(id)))
      .write(const LocalFoodLogsCompanion(synced: Value(true)));

  Future<void> deleteFoodLog(String id) =>
      (delete(localFoodLogs)..where((t) => t.id.equals(id))).go();

  // ── Weight log helpers ──────────────────────────────────────────────────────

  Future<void> insertLocalWeightLog(LocalWeightLogsCompanion entry) =>
      into(localWeightLogs).insertOnConflictUpdate(entry);

  Future<List<LocalWeightLog>> getUnsyncedWeightLogs() =>
      (select(localWeightLogs)..where((t) => t.synced.equals(false))).get();

  Future<LocalWeightLog?> getLatestLocalWeight(String userId) async {
    final rows = await (select(localWeightLogs)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm(
                expression: t.loggedAt,
                mode: OrderingMode.desc,
              )])
          ..limit(1))
        .get();
    return rows.isEmpty ? null : rows.first;
  }

  Future<void> markWeightLogSynced(String id) => (update(localWeightLogs)
        ..where((t) => t.id.equals(id)))
      .write(const LocalWeightLogsCompanion(synced: Value(true)));

  // ── Sync queue helpers ──────────────────────────────────────────────────────

  Future<void> enqueue(SyncQueueEntriesCompanion entry) =>
      into(syncQueueEntries).insertOnConflictUpdate(entry);

  Future<List<SyncQueueEntry>> getPendingQueue() =>
      select(syncQueueEntries).get();

  Future<void> deleteQueueEntry(int id) =>
      (delete(syncQueueEntries)..where((t) => t.id.equals(id))).go();

  Future<void> incrementRetry(int id) =>
      customUpdate(
        'UPDATE sync_queue_entries SET retries = retries + 1 WHERE id = ?',
        variables: [Variable.withInt(id)],
      );
}
