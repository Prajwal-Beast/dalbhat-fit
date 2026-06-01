import '../../domain/entities/food.dart';
import '../../domain/entities/meal_template.dart';
import '../../domain/repositories/food_repository.dart';
import '../datasources/supabase_food_datasource.dart';

class FoodRepositoryImpl implements FoodRepository {
  final SupabaseFoodDatasource _ds;
  FoodRepositoryImpl(this._ds);

  @override
  Future<List<Food>> search(String query, {int limit = 30}) =>
      _ds.search(query, limit: limit);

  @override
  Future<Food?> getById(String id) => _ds.getById(id);

  @override
  Future<List<MealTemplate>> getMealTemplates() => _ds.getMealTemplates();
}
