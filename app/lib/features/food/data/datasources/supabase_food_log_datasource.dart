import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/food.dart';
import '../../domain/entities/food_log.dart';
import '../../domain/entities/meal_template.dart';

class SupabaseFoodLogDatasource {
  final SupabaseClient _client;
  SupabaseFoodLogDatasource(this._client);

  Future<FoodLog> logFood({
    required String userId,
    required Food food,
    required FoodPortion portion,
    required String mealType,
    double quantity = 1.0,
    String loggedVia = 'search',
  }) async {
    final calories = portion.calories * quantity;
    final factor = (portion.weightG * quantity) / 100.0;

    final row = await _client.from('food_logs').insert({
      'user_id': userId,
      'food_id': food.id,
      'portion_id': portion.id,
      'quantity': quantity,
      'calories_estimated': calories,
      'calories_confirmed': calories,
      'protein_g': food.proteinG * factor,
      'carbs_g': food.carbsG * factor,
      'fat_g': food.fatG * factor,
      'meal_type': mealType,
      'logged_at': DateTime.now().toIso8601String().substring(0, 10),
      'logged_via': loggedVia,
    }).select().single();

    // Attach denormalised name for display
    final enriched = Map<String, dynamic>.from(row)
      ..['food_name'] = food.nameEn
      ..['food_name_ne'] = food.nameNe
      ..['portion_label'] = portion.label;

    return FoodLog.fromMap(enriched);
  }

  Future<FoodLog> logTemplate({
    required String userId,
    required MealTemplate template,
    required String mealType,
  }) async {
    final row = await _client.from('food_logs').insert({
      'user_id': userId,
      'food_id': null, // template, not a single food
      'quantity': 1.0,
      'calories_estimated': template.totalCalories,
      'calories_confirmed': template.totalCalories,
      'protein_g': template.totalProteinG,
      'carbs_g': template.totalCarbsG,
      'fat_g': template.totalFatG,
      'meal_type': mealType,
      'logged_at': DateTime.now().toIso8601String().substring(0, 10),
      'logged_via': 'template',
    }).select().single();

    final enriched = Map<String, dynamic>.from(row)
      ..['food_name'] = template.nameEn
      ..['food_name_ne'] = template.nameNe
      ..['portion_label'] = '1 serving';

    return FoodLog.fromMap(enriched);
  }

  Future<List<FoodLog>> getTodayLogs(String userId) async {
    final today = DateTime.now().toIso8601String().substring(0, 10);

    final rows = await _client
        .from('food_logs')
        .select('*, foods(name_en, name_ne), food_portions(label)')
        .eq('user_id', userId)
        .eq('logged_at', today)
        .order('created_at');

    return (rows as List).map((r) {
      final m = Map<String, dynamic>.from(r as Map<String, dynamic>);
      // Flatten joined columns
      final food = m['foods'] as Map<String, dynamic>?;
      final portion = m['food_portions'] as Map<String, dynamic>?;
      m['food_name'] = food?['name_en'];
      m['food_name_ne'] = food?['name_ne'];
      m['portion_label'] = portion?['label'] ?? 'serving';
      return FoodLog.fromMap(m);
    }).toList();
  }

  Future<List<Food>> getRecentFoods(String userId, {int limit = 7}) async {
    // Distinct food_ids logged recently, excluding template logs
    final rows = await _client
        .from('food_logs')
        .select('food_id, foods(id, name_en, name_ne, category, calories_per_100g, protein_g, carbs_g, fat_g, fiber_g, is_verified)')
        .eq('user_id', userId)
        .not('food_id', 'is', null)
        .order('created_at', ascending: false)
        .limit(limit * 3); // over-fetch to deduplicate

    final seen = <String>{};
    final foods = <Food>[];
    for (final r in rows as List) {
      final m = r as Map<String, dynamic>;
      final foodData = m['foods'] as Map<String, dynamic>?;
      if (foodData == null) continue;
      final id = foodData['id'] as String;
      if (seen.contains(id)) continue;
      seen.add(id);
      foods.add(Food.fromMap(foodData));
      if (foods.length >= limit) break;
    }
    return foods;
  }

  Future<void> deleteLog(String logId) async {
    await _client.from('food_logs').delete().eq('id', logId);
  }

  /// Daily calorie totals for the last [days] days, for the calorie history chart.
  /// Returns list of maps: { date: 'yyyy-MM-dd', calories: int }
  Future<List<Map<String, dynamic>>> getCalorieHistory(
      String userId, {int days = 7}) async {
    final from = DateTime.now().subtract(Duration(days: days - 1));
    final fromStr = from.toIso8601String().substring(0, 10);

    final rows = await _client
        .from('food_logs')
        .select('logged_at, calories_confirmed')
        .eq('user_id', userId)
        .gte('logged_at', fromStr)
        .order('logged_at');

    // Aggregate by date
    final map = <String, double>{};
    for (final r in rows as List) {
      final m = r as Map<String, dynamic>;
      final date = m['logged_at'] as String;
      final cal = (m['calories_confirmed'] as num).toDouble();
      map[date] = (map[date] ?? 0) + cal;
    }

    return map.entries
        .map((e) => {'date': e.key, 'calories': e.value.round()})
        .toList()
      ..sort((a, b) => (a['date'] as String).compareTo(b['date'] as String));
  }
}
