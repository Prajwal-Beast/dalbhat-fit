class WorkoutPlan {
  final String id;
  final String name;
  final String? description;
  final String? goal;     // lose | maintain | gain
  final String? location; // gym | home | both
  final String? level;    // beginner | intermediate | advanced
  final int? durationWeeks;
  final int? daysPerWeek;

  const WorkoutPlan({
    required this.id,
    required this.name,
    this.description,
    this.goal,
    this.location,
    this.level,
    this.durationWeeks,
    this.daysPerWeek,
  });

  static WorkoutPlan fromMap(Map<String, dynamic> m) => WorkoutPlan(
        id: m['id'] as String,
        name: m['name'] as String,
        description: m['description'] as String?,
        goal: m['goal'] as String?,
        location: m['location'] as String?,
        level: m['level'] as String?,
        durationWeeks: m['duration_weeks'] as int?,
        daysPerWeek: m['days_per_week'] as int?,
      );

  String get emoji {
    if (location == 'home') return '🏠';
    if (location == 'gym') return '🏋️';
    return '💪';
  }
}
