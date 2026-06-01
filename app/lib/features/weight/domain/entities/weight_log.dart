class WeightLog {
  final String id;
  final String userId;
  final double weightKg;
  final DateTime loggedAt;
  final String? notes;

  const WeightLog({
    required this.id,
    required this.userId,
    required this.weightKg,
    required this.loggedAt,
    this.notes,
  });

  static WeightLog fromMap(Map<String, dynamic> m) {
    return WeightLog(
      id: m['id'] as String,
      userId: m['user_id'] as String,
      weightKg: (m['weight_kg'] as num).toDouble(),
      loggedAt: DateTime.parse(m['logged_at'] as String),
      notes: m['notes'] as String?,
    );
  }
}
