/// A single meal log entry — what a user ate, when, and how many calories.
class FoodLog {
  final String id;
  final String userId;
  final String? foodId;
  final String? foodName; // denormalised for display without extra join
  final String? foodNameNe;
  final String? portionId;
  final String portionLabel;
  final double quantity;
  final double caloriesConfirmed;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final String mealType; // breakfast | lunch | dinner | snack
  final DateTime loggedAt;
  final String loggedVia; // photo | search | manual | template

  const FoodLog({
    required this.id,
    required this.userId,
    this.foodId,
    this.foodName,
    this.foodNameNe,
    this.portionId,
    required this.portionLabel,
    required this.quantity,
    required this.caloriesConfirmed,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.mealType,
    required this.loggedAt,
    required this.loggedVia,
  });

  static FoodLog fromMap(Map<String, dynamic> m) {
    return FoodLog(
      id: m['id'] as String,
      userId: m['user_id'] as String,
      foodId: m['food_id'] as String?,
      foodName: m['food_name'] as String?,
      foodNameNe: m['food_name_ne'] as String?,
      portionId: m['portion_id'] as String?,
      portionLabel: m['portion_label'] as String? ?? 'serving',
      quantity: (m['quantity'] as num?)?.toDouble() ?? 1.0,
      caloriesConfirmed: (m['calories_confirmed'] as num?)?.toDouble() ?? 0,
      proteinG: (m['protein_g'] as num?)?.toDouble() ?? 0,
      carbsG: (m['carbs_g'] as num?)?.toDouble() ?? 0,
      fatG: (m['fat_g'] as num?)?.toDouble() ?? 0,
      mealType: m['meal_type'] as String? ?? 'lunch',
      loggedAt: DateTime.parse(m['logged_at'] as String),
      loggedVia: m['logged_via'] as String? ?? 'search',
    );
  }
}

/// Aggregated totals for a day — computed from FoodLogs.
class DailySummary {
  final DateTime date;
  final int caloriesConsumed;
  final int caloriesTarget;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final List<FoodLog> logs;

  const DailySummary({
    required this.date,
    required this.caloriesConsumed,
    required this.caloriesTarget,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.logs,
  });

  int get caloriesRemaining => caloriesTarget - caloriesConsumed;
  bool get isOver => caloriesConsumed > caloriesTarget;

  List<FoodLog> logsForMeal(String mealType) =>
      logs.where((l) => l.mealType == mealType).toList();

  static DailySummary empty(int target) => DailySummary(
        date: DateTime.now(),
        caloriesConsumed: 0,
        caloriesTarget: target,
        proteinG: 0,
        carbsG: 0,
        fatG: 0,
        logs: [],
      );
}
