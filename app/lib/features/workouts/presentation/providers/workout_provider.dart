import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../data/datasources/supabase_workout_datasource.dart';
import '../../domain/entities/workout_plan.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/workout_session.dart';

// ── Infrastructure ────────────────────────────────────────────────────────────

final workoutDatasourceProvider = Provider<SupabaseWorkoutDatasource>((ref) {
  return SupabaseWorkoutDatasource(ref.watch(supabaseClientProvider));
});

// ── Plans ─────────────────────────────────────────────────────────────────────

final workoutPlansProvider = FutureProvider<List<WorkoutPlan>>((ref) async {
  return ref.watch(workoutDatasourceProvider).getWorkoutPlans();
});

/// Recommended plan based on user's goal and workout preference from profile.
final recommendedPlanProvider = FutureProvider<WorkoutPlan?>((ref) async {
  final profileAsync = ref.watch(userProfileProvider);
  final ds = ref.watch(workoutDatasourceProvider);

  final profile = profileAsync.valueOrNull;
  final goal = profile?['goal'] as String? ?? 'maintain';
  final pref = profile?['workout_pref'] as String? ?? 'home';

  return ds.getRecommendedPlan(goal: goal, workoutPref: pref);
});

// ── Plan day exercises ────────────────────────────────────────────────────────

final planDayExercisesProvider = FutureProvider.family<List<PlanExercise>,
    ({String planId, int dayNumber})>((ref, args) async {
  return ref.watch(workoutDatasourceProvider).getPlanDayExercises(
        args.planId,
        dayNumber: args.dayNumber,
      );
});

// ── Recent sessions ───────────────────────────────────────────────────────────

final recentSessionsProvider =
    FutureProvider<List<WorkoutSession>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  return ref.watch(workoutDatasourceProvider).getRecentSessions(user.id);
});

// ── Active workout session state ──────────────────────────────────────────────

enum SessionStatus { idle, active, resting, completed, saving, saved, error }

class ActiveSessionState {
  final SessionStatus status;
  final WorkoutPlan? plan;
  final List<PlanExercise> exercises;
  final int currentExerciseIndex;
  final int currentSet;
  final bool resting;
  final int restSecondsLeft;
  final DateTime? startedAt;
  final WorkoutSession? savedSession;
  final String? errorMessage;

  const ActiveSessionState({
    this.status = SessionStatus.idle,
    this.plan,
    this.exercises = const [],
    this.currentExerciseIndex = 0,
    this.currentSet = 1,
    this.resting = false,
    this.restSecondsLeft = 0,
    this.startedAt,
    this.savedSession,
    this.errorMessage,
  });

  PlanExercise? get currentExercise =>
      (exercises.isEmpty || currentExerciseIndex >= exercises.length)
          ? null
          : exercises[currentExerciseIndex];

  bool get isLastExercise => currentExerciseIndex == exercises.length - 1;
  bool get isLastSet => currentSet == (currentExercise?.sets ?? 1);

  int get elapsedMinutes => startedAt == null
      ? 0
      : DateTime.now().difference(startedAt!).inMinutes;

  int get estimatedCalories {
    // ~5 kcal/min for moderate workout
    return (elapsedMinutes * 5).clamp(0, 9999);
  }

  ActiveSessionState copyWith({
    SessionStatus? status,
    WorkoutPlan? plan,
    List<PlanExercise>? exercises,
    int? currentExerciseIndex,
    int? currentSet,
    bool? resting,
    int? restSecondsLeft,
    DateTime? startedAt,
    WorkoutSession? savedSession,
    String? errorMessage,
  }) {
    return ActiveSessionState(
      status: status ?? this.status,
      plan: plan ?? this.plan,
      exercises: exercises ?? this.exercises,
      currentExerciseIndex:
          currentExerciseIndex ?? this.currentExerciseIndex,
      currentSet: currentSet ?? this.currentSet,
      resting: resting ?? this.resting,
      restSecondsLeft: restSecondsLeft ?? this.restSecondsLeft,
      startedAt: startedAt ?? this.startedAt,
      savedSession: savedSession ?? this.savedSession,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class WorkoutSessionNotifier extends StateNotifier<ActiveSessionState> {
  final SupabaseWorkoutDatasource _ds;
  final Ref _ref;
  Timer? _restTimer;

  WorkoutSessionNotifier(this._ds, this._ref)
      : super(const ActiveSessionState());

  /// Load exercises for a plan and start the session.
  Future<void> startSession(WorkoutPlan plan, {int dayNumber = 1}) async {
    state = const ActiveSessionState(status: SessionStatus.active);
    try {
      var exercises = await _ds.getPlanDayExercises(plan.id,
          dayNumber: dayNumber);

      // If this day has no exercises, try day 1 as fallback
      if (exercises.isEmpty && dayNumber != 1) {
        exercises = await _ds.getPlanDayExercises(plan.id, dayNumber: 1);
      }

      if (exercises.isEmpty) {
        // No exercises for this plan at all — show error
        state = const ActiveSessionState(
          status: SessionStatus.error,
          errorMessage:
              'No exercises found for this plan. Please try another.',
        );
        return;
      }

      state = ActiveSessionState(
        status: SessionStatus.active,
        plan: plan,
        exercises: exercises,
        startedAt: DateTime.now(),
      );
    } catch (e) {
      state = const ActiveSessionState(
        status: SessionStatus.error,
        errorMessage: 'Could not load exercises. Check your connection.',
      );
    }
  }

  /// Mark current set as done — starts rest timer or advances exercise.
  void completeSet() {
    if (state.resting) return;
    // Guard against double-taps while finishing/saving (prevents duplicate
    // session saves).
    if (state.status == SessionStatus.saving ||
        state.status == SessionStatus.saved ||
        state.status == SessionStatus.completed) {
      return;
    }
    final ex = state.currentExercise;
    if (ex == null) return;

    if (state.currentSet < ex.sets) {
      // More sets — start rest
      _startRest(ex.restSeconds);
      state = state.copyWith(
        currentSet: state.currentSet + 1,
        resting: true,
        restSecondsLeft: ex.restSeconds,
      );
    } else if (!state.isLastExercise) {
      // Last set of this exercise — move to next, rest between exercises
      _startRest(60);
      state = state.copyWith(
        currentExerciseIndex: state.currentExerciseIndex + 1,
        currentSet: 1,
        resting: true,
        restSecondsLeft: 60,
      );
    } else {
      // All done — save session
      _finishSession();
    }
  }

  void skipRest() {
    _restTimer?.cancel();
    state = state.copyWith(resting: false, restSecondsLeft: 0);
  }

  void nextExercise() {
    if (state.isLastExercise) return;
    _restTimer?.cancel();
    state = state.copyWith(
      currentExerciseIndex: state.currentExerciseIndex + 1,
      currentSet: 1,
      resting: false,
    );
  }

  void prevExercise() {
    if (state.currentExerciseIndex == 0) return;
    _restTimer?.cancel();
    state = state.copyWith(
      currentExerciseIndex: state.currentExerciseIndex - 1,
      currentSet: 1,
      resting: false,
    );
  }

  void _startRest(int seconds) {
    _restTimer?.cancel();
    _restTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        _restTimer?.cancel();
        return;
      }
      final left = state.restSecondsLeft;
      if (left > 0) {
        state = state.copyWith(restSecondsLeft: left - 1);
      } else {
        _restTimer?.cancel();
        state = state.copyWith(resting: false, restSecondsLeft: 0);
      }
    });
  }

  Future<void> _finishSession() async {
    _restTimer?.cancel();
    final userId = _ref.read(currentUserProvider)?.id;
    final plan = state.plan;
    if (userId == null || plan == null) {
      state = state.copyWith(status: SessionStatus.completed);
      return;
    }

    state = state.copyWith(status: SessionStatus.saving);
    try {
      final session = await _ds.saveSession(
        userId: userId,
        planId: plan.id,
        planName: plan.name,
        startedAt: state.startedAt ?? DateTime.now(),
        durationMinutes: state.elapsedMinutes,
        exercisesCompleted: state.exercises.length,
        caloriesBurned: state.estimatedCalories,
      );
      state = state.copyWith(
          status: SessionStatus.saved, savedSession: session);
      // Refresh recent sessions
      _ref.invalidate(recentSessionsProvider);
    } catch (e) {
      // Still show complete even if save fails
      state = state.copyWith(
          status: SessionStatus.completed,
          errorMessage: 'Session not saved. Check connection.');
    }
  }

  void reset() {
    _restTimer?.cancel();
    state = const ActiveSessionState();
  }

  @override
  void dispose() {
    _restTimer?.cancel();
    super.dispose();
  }
}

final workoutSessionNotifierProvider =
    StateNotifierProvider<WorkoutSessionNotifier, ActiveSessionState>((ref) {
  return WorkoutSessionNotifier(ref.watch(workoutDatasourceProvider), ref);
});
