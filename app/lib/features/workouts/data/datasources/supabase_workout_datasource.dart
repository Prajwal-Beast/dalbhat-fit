import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/workout_plan.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/workout_session.dart';

class SupabaseWorkoutDatasource {
  final SupabaseClient _client;
  SupabaseWorkoutDatasource(this._client);

  // ── Plans ──────────────────────────────────────────────────────────────────

  Future<List<WorkoutPlan>> getWorkoutPlans() async {
    final rows = await _client
        .from('workout_plans')
        .select()
        .eq('is_active', true)
        .order('name');
    return (rows as List)
        .map((r) => WorkoutPlan.fromMap(r as Map<String, dynamic>))
        .toList();
  }

  // ── Plan days (exercises for a plan, grouped by day_number) ───────────────

  /// Returns exercises for a specific day of a plan.
  /// If dayNumber is null, returns day 1 (the first workout day).
  Future<List<PlanExercise>> getPlanDayExercises(
    String planId, {
    int dayNumber = 1,
  }) async {
    final rows = await _client
        .from('workout_plan_days')
        .select('*, exercises(*)')
        .eq('plan_id', planId)
        .eq('day_number', dayNumber)
        .order('order_index');

    final result = <PlanExercise>[];
    for (final r in rows as List) {
      final m = r as Map<String, dynamic>;
      final exerciseData = m['exercises'] as Map<String, dynamic>?;
      if (exerciseData == null) continue;

      result.add(PlanExercise(
        id: m['id'] as String,
        exercise: Exercise.fromMap(exerciseData),
        sets: (m['sets'] as int?) ?? 3,
        reps: (m['reps'] as String?) ?? '12',
        restSeconds: (m['rest_seconds'] as int?) ?? 60,
        orderIndex: (m['order_index'] as int?) ?? 0,
      ));
    }
    return result;
  }

  /// How many distinct day_numbers does this plan have?
  Future<int> getPlanDayCount(String planId) async {
    final rows = await _client
        .from('workout_plan_days')
        .select('day_number')
        .eq('plan_id', planId);
    final days = (rows as List)
        .map((r) => (r as Map<String, dynamic>)['day_number'] as int)
        .toSet();
    return days.length;
  }

  // ── Recommended plan based on user profile ─────────────────────────────────

  /// Returns the best-matching plan for a user given their goal + workout pref.
  /// Prefers plans that have exercises seeded (checked via workout_plan_days).
  Future<WorkoutPlan?> getRecommendedPlan({
    required String goal,
    String workoutPref = 'home',
  }) async {
    final plans = await getWorkoutPlans();
    if (plans.isEmpty) return null;

    // Find plans that actually have exercises seeded
    final plansWithExercises = <WorkoutPlan>[];
    for (final plan in plans) {
      final ex = await getPlanDayExercises(plan.id, dayNumber: 1);
      if (ex.isNotEmpty) plansWithExercises.add(plan);
    }

    final pool = plansWithExercises.isNotEmpty ? plansWithExercises : plans;

    // Priority: match goal AND location → goal only → any
    final goalKey = (goal == 'lose_weight' || goal == 'lose') ? 'lose'
        : (goal == 'gain_muscle' || goal == 'gain') ? 'gain'
        : goal;

    final matchBoth = pool.where((p) =>
        (p.goal == goalKey || p.goal == null) &&
        (p.location == workoutPref || p.location == 'both')).toList();
    if (matchBoth.isNotEmpty) return matchBoth.first;

    final matchGoal = pool.where((p) => p.goal == goalKey).toList();
    if (matchGoal.isNotEmpty) return matchGoal.first;

    // Final fallback: prefer beginner home plan
    final homeBeginner = pool.where((p) =>
        p.location == 'home' && p.level == 'beginner').toList();
    if (homeBeginner.isNotEmpty) return homeBeginner.first;

    return pool.first;
  }

  // ── Sessions ───────────────────────────────────────────────────────────────

  Future<WorkoutSession> saveSession({
    required String userId,
    required String planId,
    required String planName,
    required DateTime startedAt,
    required int durationMinutes,
    required int exercisesCompleted,
    required int caloriesBurned,
  }) async {
    final row = await _client.from('workout_sessions').insert({
      'user_id': userId,
      'plan_id': planId,
      'session_date': DateTime.now().toIso8601String().substring(0, 10),
      // timestamptz columns: convert to UTC, else local wall-clock time is
      // stored as if it were UTC (created_at is already true UTC).
      'started_at': startedAt.toUtc().toIso8601String(),
      'completed_at': DateTime.now().toUtc().toIso8601String(),
      'duration_minutes': durationMinutes,
      'exercises_completed': exercisesCompleted,
      'calories_burned': caloriesBurned.toDouble(),
      'completion_pct': 100.0,
    }).select().single();

    return WorkoutSession.fromMap({
      ...Map<String, dynamic>.from(row),
      'plan_name': planName,
    });
  }

  /// Fetch last N sessions for user — for progress screen / streak tracking.
  Future<List<WorkoutSession>> getRecentSessions(String userId,
      {int limit = 30}) async {
    final rows = await _client
        .from('workout_sessions')
        .select()
        .eq('user_id', userId)
        .order('session_date', ascending: false)
        .limit(limit);

    return (rows as List)
        .map((r) => WorkoutSession.fromMap(r as Map<String, dynamic>))
        .toList();
  }
}
