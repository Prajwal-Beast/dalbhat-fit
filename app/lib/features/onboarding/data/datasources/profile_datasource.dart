import 'package:supabase_flutter/supabase_flutter.dart';

/// Writes all user profile data to Supabase after onboarding completes.
/// Creates rows in: user_profiles, user_settings, user_workout_preferences, goals.
class ProfileDatasource {
  final SupabaseClient _client;

  ProfileDatasource(this._client);

  Future<void> saveOnboardingProfile({
    required String userId,
    required String name,
    required int age,
    required String gender,
    required double heightCm,
    required double weightKg,
    required String goal,
    required String activityLevel,
    required String workoutPref,
    required int dailyCalories,
    required Map<String, int> macros,
  }) async {
    // Run all inserts as a logical group — if any fails, we surface the error
    await Future.wait([
      _upsertProfile(
        userId: userId,
        name: name,
        age: age,
        gender: gender,
        heightCm: heightCm,
        weightKg: weightKg,
        goal: goal,
        activityLevel: activityLevel,
        workoutPref: workoutPref,
        dailyCalories: dailyCalories,
      ),
      _upsertSettings(userId: userId),
      _upsertWorkoutPrefs(userId: userId, workoutPref: workoutPref),
      _upsertInitialGoal(
        userId: userId,
        goal: goal,
        startWeightKg: weightKg,
        dailyCalories: dailyCalories,
      ),
    ]);

    // Mark onboarding complete in auth metadata
    await _client.auth.updateUser(
      UserAttributes(data: {'onboarding_done': true, 'name': name}),
    );
  }

  Future<void> _upsertProfile({
    required String userId,
    required String name,
    required int age,
    required String gender,
    required double heightCm,
    required double weightKg,
    required String goal,
    required String activityLevel,
    required String workoutPref,
    required int dailyCalories,
  }) async {
    await _client.from('user_profiles').upsert({
      'id': userId,
      'name': name,
      'age': age,
      'gender': gender,
      'height_cm': heightCm,
      'weight_kg': weightKg,
      'goal': goal,
      'activity_level': activityLevel,
      'workout_pref': workoutPref,
      'daily_calories': dailyCalories,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
  }

  Future<void> _upsertSettings({required String userId}) async {
    await _client.from('user_settings').upsert({
      'user_id': userId,
      'language': 'en',
      'units': 'metric',
      'dark_mode': false,
      'notif_enabled': true,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
  }

  Future<void> _upsertWorkoutPrefs({
    required String userId,
    required String workoutPref,
  }) async {
    await _client.from('user_workout_preferences').upsert({
      'user_id': userId,
      'session_duration_mins': 45,
      'training_days_per_week': 3,
      'equipment_available': workoutPref == 'gym'
          ? ['dumbbells', 'barbell', 'machines', 'pull_up_bar']
          : [],
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
  }

  Future<void> _upsertInitialGoal({
    required String userId,
    required String goal,
    required double startWeightKg,
    required int dailyCalories,
  }) async {
    // Deactivate any previous active goals first
    await _client
        .from('goals')
        .update({'is_active': false, 'ended_at': DateTime.now().toUtc().toIso8601String()})
        .eq('user_id', userId)
        .eq('is_active', true);

    await _client.from('goals').insert({
      'user_id': userId,
      'goal_type': goal,
      'start_weight_kg': startWeightKg,
      'daily_calorie_target': dailyCalories,
      'started_at': DateTime.now().toUtc().toIso8601String(),
      'is_active': true,
    });
  }

  /// Fetch saved profile. Returns null if not found (user hasn't completed onboarding).
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    final res = await _client
        .from('user_profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    return res;
  }

  /// The user's current active goal. Holds the immutable `start_weight_kg`
  /// captured at onboarding — used to measure real progress (unlike
  /// user_profiles.weight_kg, which is overwritten on every weigh-in).
  Future<Map<String, dynamic>?> getActiveGoal(String userId) async {
    final res = await _client
        .from('goals')
        .select()
        .eq('user_id', userId)
        .eq('is_active', true)
        .order('started_at', ascending: false)
        .limit(1)
        .maybeSingle();
    return res;
  }
}
