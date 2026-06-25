import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/supabase_food_datasource.dart';
import '../../data/datasources/supabase_food_log_datasource.dart';
import '../../data/datasources/local_food_log_datasource.dart';
import '../../data/repositories/food_repository_impl.dart';
import '../../data/repositories/food_log_repository_impl.dart';
import '../../domain/entities/food.dart';
import '../../domain/entities/food_log.dart';
import '../../domain/entities/meal_template.dart';
import '../../domain/repositories/food_repository.dart';
import '../../domain/repositories/food_log_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../../../core/providers/database_provider.dart';

// ── Infrastructure providers ──────────────────────────────────────────────────

final foodDatasourceProvider = Provider<SupabaseFoodDatasource>((ref) {
  return SupabaseFoodDatasource(ref.watch(supabaseClientProvider));
});

final foodLogDatasourceProvider = Provider<SupabaseFoodLogDatasource>((ref) {
  return SupabaseFoodLogDatasource(ref.watch(supabaseClientProvider));
});

final localFoodLogDatasourceProvider = Provider<LocalFoodLogDatasource>((ref) {
  return LocalFoodLogDatasource(ref.watch(appDatabaseProvider));
});

final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  return FoodRepositoryImpl(ref.watch(foodDatasourceProvider));
});

final foodLogRepositoryProvider = Provider<FoodLogRepository>((ref) {
  return FoodLogRepositoryImpl(ref.watch(foodLogDatasourceProvider));
});

// ── Search ────────────────────────────────────────────────────────────────────

/// Debounced food search — keyed on query string.
final foodSearchProvider =
    FutureProvider.family<List<Food>, String>((ref, query) async {
  return ref.watch(foodRepositoryProvider).search(query);
});

// ── Food detail ───────────────────────────────────────────────────────────────

final foodByIdProvider =
    FutureProvider.family<Food?, String>((ref, id) async {
  return ref.watch(foodRepositoryProvider).getById(id);
});

// ── Meal templates ────────────────────────────────────────────────────────────

final mealTemplatesProvider = FutureProvider<List<MealTemplate>>((ref) async {
  return ref.watch(foodRepositoryProvider).getMealTemplates();
});

// ── Today's food logs ─────────────────────────────────────────────────────────

/// Today's logs — merges local SQLite + Supabase for offline-first display.
/// Local rows (unsynced) appear immediately; Supabase rows fill in any gaps.
final todayLogsProvider = FutureProvider<List<FoodLog>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  // Always read local rows first (instant, offline-safe)
  final local = await ref
      .watch(localFoodLogDatasourceProvider)
      .getTodayLogs(user.id);

  // Try remote — silently fall back to local-only when offline
  try {
    final remote =
        await ref.watch(foodLogRepositoryProvider).getTodayLogs(user.id);
    // Merge: prefer remote rows (they have DB-generated fields),
    // but keep local-only rows that haven't synced yet
    final remoteIds = remote.map((l) => l.id).toSet();
    final localOnly = local.where((l) => !remoteIds.contains(l.id)).toList();
    final merged = [...remote, ...localOnly];
    merged.sort((a, b) => a.loggedAt.compareTo(b.loggedAt));
    return merged;
  } catch (_) {
    return local;
  }
});

/// Recent foods (last 7 distinct foods logged).
final recentFoodsProvider = FutureProvider<List<Food>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  return ref.watch(foodLogRepositoryProvider).getRecentFoods(user.id);
});

// ── Daily summary (calorie ring data) ────────────────────────────────────────

/// Real calorie target from Supabase user_profiles — defaults to 1800 while loading.
final dailyCalorieTargetProvider = Provider<int>((ref) {
  return ref.watch(profileCalorieTargetProvider);
});

/// Daily calorie totals for the past 7 days — for calorie history chart.
final calorieHistoryProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  return ref
      .watch(foodLogDatasourceProvider)
      .getCalorieHistory(user.id, days: 7);
});

class DailySummaryData {
  final int consumed;
  final int target;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final List<FoodLog> logs;

  const DailySummaryData({
    required this.consumed,
    required this.target,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.logs,
  });

  int get remaining => target - consumed;
  bool get isOver => consumed > target;

  List<FoodLog> forMeal(String type) =>
      logs.where((l) => l.mealType == type).toList();
}

final dailySummaryProvider = Provider<AsyncValue<DailySummaryData>>((ref) {
  final logsAsync = ref.watch(todayLogsProvider);
  final target = ref.watch(dailyCalorieTargetProvider);

  return logsAsync.whenData((logs) {
    return DailySummaryData(
      consumed: logs.fold(0, (s, l) => s + l.caloriesConfirmed.round()),
      target: target,
      proteinG: logs.fold(0.0, (s, l) => s + l.proteinG),
      carbsG: logs.fold(0.0, (s, l) => s + l.carbsG),
      fatG: logs.fold(0.0, (s, l) => s + l.fatG),
      logs: logs,
    );
  });
});

// ── Log action notifier ───────────────────────────────────────────────────────

enum LogStatus { idle, saving, saved, error }

class LogState {
  final LogStatus status;
  final String? errorMessage;
  final FoodLog? savedLog;

  const LogState({
    this.status = LogStatus.idle,
    this.errorMessage,
    this.savedLog,
  });
}

class FoodLogNotifier extends StateNotifier<LogState> {
  final FoodLogRepository _remoteRepo;
  final LocalFoodLogDatasource _local;
  final Ref _ref;

  FoodLogNotifier(this._remoteRepo, this._local, this._ref)
      : super(const LogState());

  Future<bool> logFood({
    required Food food,
    required FoodPortion portion,
    required String mealType,
    double quantity = 1.0,
  }) async {
    final userId = _ref.read(currentUserProvider)?.id;
    if (userId == null) {
      state = const LogState(
          status: LogStatus.error, errorMessage: 'Not signed in.');
      return false;
    }

    state = const LogState(status: LogStatus.saving);

    // ── 1. Write locally first — always succeeds offline ──────────────────
    late FoodLog log;
    try {
      log = await _local.logFood(
        userId: userId,
        food: food,
        portion: portion,
        mealType: mealType,
        quantity: quantity,
      );
    } catch (e) {
      state = LogState(
          status: LogStatus.error, errorMessage: 'Could not save locally.');
      return false;
    }

    state = LogState(status: LogStatus.saved, savedLog: log);
    _ref.invalidate(todayLogsProvider);
    _ref.invalidate(recentFoodsProvider);

    // ── 2. Push to Supabase in background — silent fail is OK ─────────────
    _syncToSupabase(userId, food, portion, mealType, quantity, log.id);
    return true;
  }

  Future<bool> logTemplate({
    required MealTemplate template,
    required String mealType,
  }) async {
    final userId = _ref.read(currentUserProvider)?.id;
    if (userId == null) return false;

    state = const LogState(status: LogStatus.saving);

    late FoodLog log;
    try {
      log = await _local.logTemplate(
          userId: userId, template: template, mealType: mealType);
    } catch (_) {
      state = const LogState(
          status: LogStatus.error, errorMessage: 'Could not save locally.');
      return false;
    }

    state = LogState(status: LogStatus.saved, savedLog: log);
    _ref.invalidate(todayLogsProvider);
    _ref.invalidate(recentFoodsProvider);

    // Push to Supabase in background
    _syncTemplateToSupabase(userId, template, mealType, log.id);
    return true;
  }

  Future<void> deleteLog(String logId) async {
    // Remove locally first (always works), then best-effort remote delete,
    // then refresh once so the row can't briefly reappear from the merge.
    await _local.deleteLog(logId);
    try {
      await _remoteRepo.deleteLog(logId);
    } catch (_) {
      // Offline — the row is gone locally; it may resurface from the server
      // until the next successful delete. Acceptable for an MVP.
    }
    _ref.invalidate(todayLogsProvider);
    _ref.invalidate(recentFoodsProvider);
  }

  void reset() => state = const LogState();

  // ── Background Supabase sync ────────────────────────────────────────────────

  Future<void> _syncToSupabase(
    String userId,
    Food food,
    FoodPortion portion,
    String mealType,
    double quantity,
    String localId,
  ) async {
    try {
      await _remoteRepo.logFood(
        userId: userId,
        food: food,
        portion: portion,
        mealType: mealType,
        quantity: quantity,
        id: localId, // share the client UUID so remote+local dedupe by id
      );
      // Mark local row as synced
      await _ref.read(appDatabaseProvider).markFoodLogSynced(localId);
      _ref.invalidate(todayLogsProvider);
    } catch (_) {
      // Row stays unsynced — SyncService will retry on next connection
    }
  }

  Future<void> _syncTemplateToSupabase(
    String userId,
    MealTemplate template,
    String mealType,
    String localId,
  ) async {
    try {
      await _remoteRepo.logTemplate(
          userId: userId, template: template, mealType: mealType, id: localId);
      await _ref.read(appDatabaseProvider).markFoodLogSynced(localId);
      _ref.invalidate(todayLogsProvider);
    } catch (_) {}
  }
}

final foodLogNotifierProvider =
    StateNotifierProvider<FoodLogNotifier, LogState>((ref) {
  return FoodLogNotifier(
    ref.watch(foodLogRepositoryProvider),
    ref.watch(localFoodLogDatasourceProvider),
    ref,
  );
});
