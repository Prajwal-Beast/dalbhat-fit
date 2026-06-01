import '../../domain/entities/food.dart';
import '../../domain/entities/food_log.dart';
import '../../domain/entities/meal_template.dart';
import '../../domain/repositories/food_log_repository.dart';
import '../datasources/supabase_food_log_datasource.dart';

class FoodLogRepositoryImpl implements FoodLogRepository {
  final SupabaseFoodLogDatasource _ds;
  FoodLogRepositoryImpl(this._ds);

  @override
  Future<FoodLog> logFood({
    required String userId,
    required Food food,
    required FoodPortion portion,
    required String mealType,
    double quantity = 1.0,
    String loggedVia = 'search',
  }) =>
      _ds.logFood(
        userId: userId,
        food: food,
        portion: portion,
        mealType: mealType,
        quantity: quantity,
        loggedVia: loggedVia,
      );

  @override
  Future<FoodLog> logTemplate({
    required String userId,
    required MealTemplate template,
    required String mealType,
  }) =>
      _ds.logTemplate(userId: userId, template: template, mealType: mealType);

  @override
  Future<List<FoodLog>> getTodayLogs(String userId) => _ds.getTodayLogs(userId);

  @override
  Future<List<Food>> getRecentFoods(String userId, {int limit = 7}) =>
      _ds.getRecentFoods(userId, limit: limit);

  @override
  Future<void> deleteLog(String logId) => _ds.deleteLog(logId);
}
