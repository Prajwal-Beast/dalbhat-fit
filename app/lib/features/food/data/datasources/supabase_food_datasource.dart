import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/food.dart';
import '../../domain/entities/meal_template.dart';

class SupabaseFoodDatasource {
  final SupabaseClient _client;
  SupabaseFoodDatasource(this._client);

  /// Full-text + ilike search — works for both English and Nepali names.
  Future<List<Food>> search(String query, {int limit = 30}) async {
    if (query.trim().isEmpty) {
      // Return popular foods when no query
      final rows = await _client
          .from('foods')
          .select('*')
          .eq('is_verified', true)
          .order('name_en')
          .limit(limit);
      return (rows as List).map((r) => Food.fromMap(r as Map<String, dynamic>)).toList();
    }

    final q = query.trim().toLowerCase();
    final rows = await _client
        .from('foods')
        .select('*')
        .or('name_en.ilike.%$q%,name_ne.ilike.%$q%')
        .order('is_verified', ascending: false)
        .limit(limit);

    return (rows as List).map((r) => Food.fromMap(r as Map<String, dynamic>)).toList();
  }

  /// Fetch a food with all its portions.
  /// If no portions are seeded in the DB, synthesises a default 100g portion
  /// so the "Add to meal" button always works.
  Future<Food?> getById(String id) async {
    final row = await _client
        .from('foods')
        .select('*')
        .eq('id', id)
        .maybeSingle();

    if (row == null) return null;

    final portionRows = await _client
        .from('food_portions')
        .select('*')
        .eq('food_id', id)
        .order('is_default', ascending: false);

    var portions = (portionRows as List)
        .map((p) => FoodPortion.fromMap(p as Map<String, dynamic>))
        .toList();

    // Synthesise a default 100g portion when none are in the DB
    // This ensures the "Add to meal" button always works
    if (portions.isEmpty) {
      final cal = (row['calories_per_100g'] as num?)?.toDouble() ?? 0;
      portions = [
        FoodPortion(
          id: '${id}_default',
          foodId: id,
          label: '100g serving',
          weightG: 100,
          calories: cal,
          isDefault: true,
        ),
      ];
    }

    return Food.fromMap(row, portions: portions);
  }

  /// All public meal templates.
  Future<List<MealTemplate>> getMealTemplates() async {
    final rows = await _client
        .from('meal_templates')
        .select('*')
        .eq('is_public', true)
        .order('name_en');

    return (rows as List)
        .map((r) => MealTemplate.fromMap(r as Map<String, dynamic>))
        .toList();
  }
}
