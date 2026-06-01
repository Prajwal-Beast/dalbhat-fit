import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';

/// Single shared drift database instance for the app lifetime.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
