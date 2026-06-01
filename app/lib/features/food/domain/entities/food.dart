/// Pure Dart — no Supabase imports.
class Food {
  final String id;
  final String nameEn;
  final String? nameNe;
  final String category;
  final double caloriesPer100g;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final double fiberG;
  final bool isVerified;
  final List<FoodPortion> portions;

  const Food({
    required this.id,
    required this.nameEn,
    this.nameNe,
    required this.category,
    required this.caloriesPer100g,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.fiberG,
    this.isVerified = false,
    this.portions = const [],
  });

  /// Calories for a given weight in grams.
  double caloriesFor(double grams) => (caloriesPer100g / 100) * grams;
  double proteinFor(double grams) => (proteinG / 100) * grams;
  double carbsFor(double grams) => (carbsG / 100) * grams;
  double fatFor(double grams) => (fatG / 100) * grams;

  FoodPortion get defaultPortion =>
      portions.firstWhere((p) => p.isDefault, orElse: () => portions.first);

  static Food fromMap(Map<String, dynamic> m, {List<FoodPortion> portions = const []}) {
    return Food(
      id: m['id'] as String,
      nameEn: m['name_en'] as String,
      nameNe: m['name_ne'] as String?,
      category: m['category'] as String,
      caloriesPer100g: (m['calories_per_100g'] as num?)?.toDouble() ?? 0,
      proteinG: (m['protein_g'] as num?)?.toDouble() ?? 0,
      carbsG: (m['carbs_g'] as num?)?.toDouble() ?? 0,
      fatG: (m['fat_g'] as num?)?.toDouble() ?? 0,
      fiberG: (m['fiber_g'] as num?)?.toDouble() ?? 0,
      isVerified: m['is_verified'] as bool? ?? false,
      portions: portions,
    );
  }
}

class FoodPortion {
  final String id;
  final String foodId;
  final String label;
  final String? labelNe;
  final double weightG;
  final double calories;
  final bool isDefault;

  const FoodPortion({
    required this.id,
    required this.foodId,
    required this.label,
    this.labelNe,
    required this.weightG,
    required this.calories,
    this.isDefault = false,
  });

  static FoodPortion fromMap(Map<String, dynamic> m) {
    return FoodPortion(
      id: m['id'] as String,
      foodId: m['food_id'] as String,
      label: m['label'] as String,
      labelNe: m['label_ne'] as String?,
      weightG: (m['weight_g'] as num).toDouble(),
      calories: (m['calories'] as num).toDouble(),
      isDefault: m['is_default'] as bool? ?? false,
    );
  }
}
