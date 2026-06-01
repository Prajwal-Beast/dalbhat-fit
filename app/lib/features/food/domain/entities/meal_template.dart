class MealTemplate {
  final String id;
  final String nameEn;
  final String? nameNe;
  final String? description;
  final double totalCalories;
  final double totalProteinG;
  final double totalCarbsG;
  final double totalFatG;
  final String mealType;

  const MealTemplate({
    required this.id,
    required this.nameEn,
    this.nameNe,
    this.description,
    required this.totalCalories,
    required this.totalProteinG,
    required this.totalCarbsG,
    required this.totalFatG,
    required this.mealType,
  });

  static MealTemplate fromMap(Map<String, dynamic> m) {
    return MealTemplate(
      id: m['id'] as String,
      nameEn: m['name_en'] as String,
      nameNe: m['name_ne'] as String?,
      description: m['description'] as String?,
      totalCalories: (m['total_calories'] as num?)?.toDouble() ?? 0,
      totalProteinG: (m['total_protein_g'] as num?)?.toDouble() ?? 0,
      totalCarbsG: (m['total_carbs_g'] as num?)?.toDouble() ?? 0,
      totalFatG: (m['total_fat_g'] as num?)?.toDouble() ?? 0,
      mealType: m['meal_type'] as String? ?? 'lunch',
    );
  }
}
