import '../entities/food.dart';
import '../entities/meal_template.dart';

abstract class FoodRepository {
  /// Full-text search across name_en and name_ne.
  Future<List<Food>> search(String query, {int limit = 30});

  /// Fetch a single food with its portions.
  Future<Food?> getById(String id);

  /// All meal templates (public, cached locally after first fetch).
  Future<List<MealTemplate>> getMealTemplates();
}
