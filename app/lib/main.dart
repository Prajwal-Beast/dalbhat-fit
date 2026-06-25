import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'core/env.dart';
import 'core/database/app_database.dart';
import 'core/providers/database_provider.dart';
import 'core/services/sync_service.dart';
import 'core/settings/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Supabase ──────────────────────────────────────────────────────────────
  // Credentials come from --dart-define-from-file=.env.local at build time.
  // Without credentials (plain `flutter run`), app routes to home for UI dev.
  if (Env.isConfigured) {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
      debug: false,
    );
  }

  // ── Drift local database ──────────────────────────────────────────────────
  // Open once at startup. The database instance is shared via Riverpod.
  final db = AppDatabase();

  // ── Shared preferences ────────────────────────────────────────────────────
  // Holds user settings (theme, units, reminders). Loaded once and shared.
  final prefs = await SharedPreferences.getInstance();

  // ── Background sync ───────────────────────────────────────────────────────
  // Start the connectivity-aware sync service. Runs in background.
  // Only active when Supabase is configured (real device / CI run).
  if (Env.isConfigured) {
    final client = Supabase.instance.client;
    final syncService = SyncService(db: db, client: client);
    syncService.start().listen((_) {}); // fire-and-forget
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  runApp(
    ProviderScope(
      overrides: [
        // Inject the pre-opened DB so Riverpod shares the same instance.
        appDatabaseProvider.overrideWithValue(db),
        // Inject the opened SharedPreferences for the settings store.
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const DhalBhatFitApp(),
    ),
  );
}
