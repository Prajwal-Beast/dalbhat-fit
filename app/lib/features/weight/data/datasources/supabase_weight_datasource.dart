import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/weight_log.dart';

class SupabaseWeightDatasource {
  final SupabaseClient _client;
  SupabaseWeightDatasource(this._client);

  /// Write today's weight. Upserts by (user_id, logged_at date) so only
  /// one entry per day — re-logging the same day updates it.
  Future<WeightLog> logWeight({
    required String userId,
    required double weightKg,
    String? notes,
  }) async {
    final today = DateTime.now().toIso8601String().substring(0, 10);

    // Check if an entry already exists for today
    final existing = await _client
        .from('weight_logs')
        .select()
        .eq('user_id', userId)
        .eq('logged_at', today)
        .maybeSingle();

    Map<String, dynamic> row;
    if (existing != null) {
      // Update today's entry
      final updated = await _client
          .from('weight_logs')
          .update({
            'weight_kg': weightKg,
            'notes': notes,
          })
          .eq('id', existing['id'] as String)
          .select()
          .single();
      row = Map<String, dynamic>.from(updated);
    } else {
      // Insert new entry
      final inserted = await _client.from('weight_logs').insert({
        'user_id': userId,
        'weight_kg': weightKg,
        'logged_at': today,
        'notes': notes,
      }).select().single();
      row = Map<String, dynamic>.from(inserted);
    }

    // Also update current weight on user_profiles
    await _client
        .from('user_profiles')
        .update({'weight_kg': weightKg, 'updated_at': DateTime.now().toIso8601String()})
        .eq('id', userId);

    return WeightLog.fromMap(row);
  }

  /// Fetch last [limit] weight entries, newest first.
  Future<List<WeightLog>> getWeightLogs(String userId, {int limit = 90}) async {
    final rows = await _client
        .from('weight_logs')
        .select()
        .eq('user_id', userId)
        .order('logged_at', ascending: false)
        .limit(limit);

    return (rows as List)
        .map((r) => WeightLog.fromMap(r as Map<String, dynamic>))
        .toList();
  }

  /// Single latest weight entry, or null if none logged.
  Future<WeightLog?> getLatestWeight(String userId) async {
    final row = await _client
        .from('weight_logs')
        .select()
        .eq('user_id', userId)
        .order('logged_at', ascending: false)
        .limit(1)
        .maybeSingle();
    if (row == null) return null;
    return WeightLog.fromMap(Map<String, dynamic>.from(row));
  }
}
