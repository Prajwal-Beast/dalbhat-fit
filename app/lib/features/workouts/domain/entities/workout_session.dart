/// A saved record of a completed (or partial) workout session.
class WorkoutSession {
  final String id;
  final String userId;
  final String? planId;
  final String? planName;
  final DateTime sessionDate;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final int? durationMinutes;
  final int? caloriesBurned;
  final int exercisesCompleted;

  const WorkoutSession({
    required this.id,
    required this.userId,
    this.planId,
    this.planName,
    required this.sessionDate,
    this.startedAt,
    this.completedAt,
    this.durationMinutes,
    this.caloriesBurned,
    this.exercisesCompleted = 0,
  });

  static WorkoutSession fromMap(Map<String, dynamic> m) => WorkoutSession(
        id: m['id'] as String,
        userId: m['user_id'] as String,
        planId: m['plan_id'] as String?,
        planName: m['plan_name'] as String?,
        sessionDate: DateTime.parse(m['session_date'] as String),
        startedAt: m['started_at'] != null
            ? DateTime.parse(m['started_at'] as String)
            : null,
        completedAt: m['completed_at'] != null
            ? DateTime.parse(m['completed_at'] as String)
            : null,
        durationMinutes: m['duration_minutes'] as int?,
        caloriesBurned: (m['calories_burned'] as num?)?.toInt(),
        exercisesCompleted: (m['exercises_completed'] as int?) ?? 0,
      );
}
