import 'package:drift/drift.dart' hide Column;
import 'package:uuid/uuid.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/food.dart';
import '../../domain/entities/food_log.dart';
import '../../domain/entities/meal_template.dart';

const _uuid = Uuid();

/// Writes food logs to the local SQLite database (drift) first.
/// Used by [FoodLogNotifier] for offline-first logging.
class LocalFoodLogDatasource {
  final AppDatabase _db;
  LocalFoodLogDatasource(this._db);

  Future<FoodLog> logFood({
    required String userId,
    required Food food,
    required FoodPortion portion,
    required String mealType,
    double quantity = 1.0,
    String loggedVia = 'search',
  }) async {
    final id = _uuid.v4();
    final calories = portion.calories * quantity;
    final factor = (portion.weightG * quantity) / 100.0;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final now = DateTime.now();

    await _db.insertLocalFoodLog(LocalFoodLogsCompanion(
      id: Value(id),
      userId: Value(userId),
      foodId: Value(food.id),
      portionId: Value(portion.id),
      quantity: Value(quantity),
      caloriesConfirmed: Value(calories),
      proteinG: Value(food.proteinG * factor),
      carbsG: Value(food.carbsG * factor),
      fatG: Value(food.fatG * factor),
      mealType: Value(mealType),
      loggedAt: Value(today),
      loggedVia: Value(loggedVia),
      foodName: Value(food.nameEn),
      foodNameNe: Value(food.nameNe),
      portionLabel: Value(portion.label),
      synced: const Value(false),
      createdAt: Value(now),
    ));

    return FoodLog(
      id: id,
      userId: userId,
      foodId: food.id,
      foodName: food.nameEn,
      foodNameNe: food.nameNe,
      portionId: portion.id,
      portionLabel: portion.label,
      quantity: quantity,
      caloriesConfirmed: calories,
      proteinG: food.proteinG * factor,
      carbsG: food.carbsG * factor,
      fatG: food.fatG * factor,
      mealType: mealType,
      loggedAt: now,
      loggedVia: loggedVia,
    );
  }

  Future<FoodLog> logTemplate({
    required String userId,
    required MealTemplate template,
    required String mealType,
  }) async {
    final id = _uuid.v4();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final now = DateTime.now();

    await _db.insertLocalFoodLog(LocalFoodLogsCompanion(
      id: Value(id),
      userId: Value(userId),
      caloriesConfirmed: Value(template.totalCalories.toDouble()),
      proteinG: Value(template.totalProteinG),
      carbsG: Value(template.totalCarbsG),
      fatG: Value(template.totalFatG),
      mealType: Value(mealType),
      loggedAt: Value(today),
      loggedVia: const Value('template'),
      foodName: Value(template.nameEn),
      foodNameNe: Value(template.nameNe),
      portionLabel: const Value('1 serving'),
      quantity: const Value(1.0),
      synced: const Value(false),
      createdAt: Value(now),
    ));

    return FoodLog(
      id: id,
      userId: userId,
      foodName: template.nameEn,
      foodNameNe: template.nameNe,
      portionLabel: '1 serving',
      quantity: 1.0,
      caloriesConfirmed: template.totalCalories.toDouble(),
      proteinG: template.totalProteinG,
      carbsG: template.totalCarbsG,
      fatG: template.totalFatG,
      mealType: mealType,
      loggedAt: now,
      loggedVia: 'template',
    );
  }

  Future<List<FoodLog>> getTodayLogs(String userId) async {
    final rows = await _db.getTodayFoodLogs(userId);
    return rows.map(_toFoodLog).toList();
  }

  Future<void> deleteLog(String id) => _db.deleteFoodLog(id);

  FoodLog _toFoodLog(LocalFoodLog r) => FoodLog(
        id: r.id,
        userId: r.userId,
        foodId: r.foodId,
        foodName: r.foodName,
        foodNameNe: r.foodNameNe,
        portionId: r.portionId,
        portionLabel: r.portionLabel ?? 'serving',
        quantity: r.quantity,
        caloriesConfirmed: r.caloriesConfirmed,
        proteinG: r.proteinG,
        carbsG: r.carbsG,
        fatG: r.fatG,
        mealType: r.mealType,
        loggedAt: r.createdAt,
        loggedVia: r.loggedVia,
      );
}
