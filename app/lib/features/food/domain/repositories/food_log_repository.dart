import '../entities/food.dart';
import '../entities/food_log.dart';
import '../entities/meal_template.dart';

abstract class FoodLogRepository {
  /// Write a log entry. Returns the saved log.
  Future<FoodLog> logFood({
    required String userId,
    required Food food,
    required FoodPortion portion,
    required String mealType,
    double quantity = 1.0,
    String loggedVia = 'search',
  });

  /// Log a full meal template as a single entry.
  Future<FoodLog> logTemplate({
    required String userId,
    required MealTemplate template,
    required String mealType,
  });

  /// Today's logs for a user.
  Future<List<FoodLog>> getTodayLogs(String userId);

  /// Last [limit] distinct foods the user logged — for "recent" list.
  Future<List<Food>> getRecentFoods(String userId, {int limit = 7});

  /// Delete a log by ID.
  Future<void> deleteLog(String logId);
}
