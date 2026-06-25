class Exercise {
  final String id;
  final String name;
  final String? nameNe;
  final String category;
  final List<String> primaryMuscles;
  final List<String> equipment;
  final String? location;
  final String? difficulty;
  final int defaultSets;
  final String defaultReps; // e.g. "12" or "30s"
  final int defaultRestSeconds;
  final double? caloriesPerMinute;
  final List<String> instructions;
  final List<String> formNotes;

  const Exercise({
    required this.id,
    required this.name,
    this.nameNe,
    required this.category,
    this.primaryMuscles = const [],
    this.equipment = const [],
    this.location,
    this.difficulty,
    this.defaultSets = 3,
    this.defaultReps = '12',
    this.defaultRestSeconds = 60,
    this.caloriesPerMinute,
    this.instructions = const [],
    this.formNotes = const [],
  });

  static Exercise fromMap(Map<String, dynamic> m) {
    List<String> toList(dynamic v) {
      if (v == null) return [];
      if (v is List) return v.map((e) => e.toString()).toList();
      return [];
    }

    return Exercise(
      id: m['id'] as String,
      name: m['name'] as String,
      nameNe: m['name_ne'] as String?,
      category: m['category'] as String,
      primaryMuscles: toList(m['primary_muscles']),
      equipment: toList(m['equipment']),
      location: m['location'] as String?,
      difficulty: m['difficulty'] as String?,
      defaultSets: (m['default_sets'] as int?) ?? 3,
      defaultReps: (m['default_reps'] as String?) ?? '12',
      defaultRestSeconds: (m['default_rest_seconds'] as int?) ?? 60,
      caloriesPerMinute: (m['calories_per_minute'] as num?)?.toDouble(),
      instructions: toList(m['instructions']),
      formNotes: toList(m['form_notes']),
    );
  }

  String get muscleLabel =>
      primaryMuscles.isEmpty ? category : primaryMuscles.take(2).join(' · ');

  String get emoji {
    // Name-specific overrides first (most accurate)
    const nameMap = {
      'push-up': '🤸', 'push up': '🤸', 'pushup': '🤸',
      'squat': '🦵', 'lunge': '🦵', 'jump squat': '🦵',
      'plank': '⬛', 'mountain climber': '🏔️',
      'burpee': '⚡', 'glute bridge': '🍑',
      'tricep dip': '💪', 'superman': '🦸',
      'deadlift': '🏋️', 'bench press': '🏋️',
      'barbell': '🏋️', 'lat pulldown': '🔽',
      'shoulder press': '💪', 'pull-up': '🔝',
      'run': '🏃', 'cardio': '🏃',
    };
    final nameLower = name.toLowerCase();
    for (final k in nameMap.keys) {
      if (nameLower.contains(k)) return nameMap[k]!;
    }
    // Category fallback
    const catMap = {
      'chest': '💪', 'back': '🦾', 'legs': '🦵', 'core': '⬛',
      'shoulders': '💪', 'arms': '💪', 'triceps': '💪',
      'full_body': '⚡', 'glutes': '🍑', 'cardio': '🏃',
    };
    return catMap[category.toLowerCase()] ?? '🔥';
  }
}

/// One exercise slot in a workout plan day.
class PlanExercise {
  final String id; // workout_plan_days.id
  final Exercise exercise;
  final int sets;
  final String reps;
  final int restSeconds;
  final int orderIndex;

  const PlanExercise({
    required this.id,
    required this.exercise,
    required this.sets,
    required this.reps,
    required this.restSeconds,
    required this.orderIndex,
  });
}
