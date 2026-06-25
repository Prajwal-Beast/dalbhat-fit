// ignore_for_file: prefer_initializing_formals
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../database/app_database.dart';
import '../utils/uuid_util.dart';

/// Watches connectivity and flushes unsynced local rows to Supabase
/// whenever the device goes back online.
class SyncService {
  final AppDatabase _db;
  final SupabaseClient _client;

  SyncService({required AppDatabase db, required SupabaseClient client})
      : _db = db,
        _client = client;

  /// Call once during app startup. Yields a value each time a sync runs.
  Stream<void> start() async* {
    await _flush();

    await for (final results in Connectivity().onConnectivityChanged) {
      final isConnected = results.any((r) =>
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.ethernet);
      if (isConnected) {
        await _flush();
        yield null;
      }
    }
  }

  Future<void> _flush() async {
    await Future.wait([
      _syncFoodLogs(),
      _syncWeightLogs(),
    ]);
  }

  Future<void> _syncFoodLogs() async {
    final unsynced = await _db.getUnsyncedFoodLogs();
    for (final log in unsynced) {
      try {
        await _client.from('food_logs').upsert({
          'id': log.id,
          'user_id': log.userId,
          if (log.foodId != null) 'food_id': log.foodId,
          if (isUuid(log.portionId)) 'portion_id': log.portionId,
          'quantity': log.quantity,
          'calories_estimated': log.caloriesConfirmed,
          'calories_confirmed': log.caloriesConfirmed,
          'protein_g': log.proteinG,
          'carbs_g': log.carbsG,
          'fat_g': log.fatG,
          'meal_type': log.mealType,
          'logged_at': log.loggedAt,
          'logged_via': log.loggedVia,
        });
        await _db.markFoodLogSynced(log.id);
      } catch (_) {
        // Will retry next connection
      }
    }
  }

  Future<void> _syncWeightLogs() async {
    final unsynced = await _db.getUnsyncedWeightLogs();
    for (final log in unsynced) {
      try {
        await _client.from('weight_logs').upsert({
          'id': log.id,
          'user_id': log.userId,
          'weight_kg': log.weightKg,
          'logged_at': log.loggedAt,
          if (log.notes != null) 'notes': log.notes,
        });
        await _client
            .from('user_profiles')
            .update({
              'weight_kg': log.weightKg,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', log.userId);
        await _db.markWeightLogSynced(log.id);
      } catch (_) {
        // Will retry next connection
      }
    }
  }
}
