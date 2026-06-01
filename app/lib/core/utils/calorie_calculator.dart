class CalorieCalculator {
  CalorieCalculator._();

  static double bmr(double weightKg, double heightCm, int age, String gender) {
    final base = (10 * weightKg) + (6.25 * heightCm) - (5 * age);
    return gender == 'male' ? base + 5 : base - 161;
  }

  static double tdee(double bmr, String activityLevel) {
    const m = {
      'sedentary': 1.2,
      'light': 1.375,
      'moderate': 1.55,
      'active': 1.725,
      'very_active': 1.9,
    };
    return bmr * (m[activityLevel] ?? 1.2);
  }

  static int dailyTarget(double tdee, String goal) {
    switch (goal) {
      case 'lose':
        return (tdee - 500).round().clamp(800, 9999);
      case 'gain':
        return (tdee + 300).round();
      default:
        return tdee.round();
    }
  }

  static Map<String, int> macros(int dailyCal, String goal) {
    final splits = {
      'lose': (carbs: 0.40, protein: 0.35, fat: 0.25),
      'gain': (carbs: 0.45, protein: 0.35, fat: 0.20),
      'maintain': (carbs: 0.50, protein: 0.25, fat: 0.25),
    }[goal]!;
    return {
      'carbs_g': ((dailyCal * splits.carbs) / 4).round(),
      'protein_g': ((dailyCal * splits.protein) / 4).round(),
      'fat_g': ((dailyCal * splits.fat) / 9).round(),
    };
  }

  static String bmiCategory(double weightKg, double heightM) {
    final bmi = weightKg / (heightM * heightM);
    if (bmi < 18.5) return 'underweight';
    if (bmi < 23.0) return 'normal';
    if (bmi < 27.5) return 'overweight';
    return 'obese';
  }

  static double bmi(double weightKg, double heightM) =>
      weightKg / (heightM * heightM);

  static int weeksToGoal(double currentKg, double targetKg, String goal) {
    final diff = (currentKg - targetKg).abs();
    if (diff < 0.5) return 0;
    // 0.5 kg/week pace
    return (diff / 0.5).ceil();
  }
}
