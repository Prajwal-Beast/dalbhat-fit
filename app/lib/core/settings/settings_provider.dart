import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds the single [SharedPreferences] instance. Overridden in `main()` after
/// it has been opened, mirroring how the Drift database is injected.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
      'sharedPreferencesProvider must be overridden in main()');
});

/// User-controlled app preferences. Persisted to disk so they survive restarts.
class AppSettings {
  final bool darkMode;
  final bool useLbs;
  final bool nepaliLanguage;
  final bool mealReminders;
  final bool workoutReminder;

  const AppSettings({
    this.darkMode = false,
    this.useLbs = false,
    this.nepaliLanguage = false,
    this.mealReminders = true,
    this.workoutReminder = true,
  });

  AppSettings copyWith({
    bool? darkMode,
    bool? useLbs,
    bool? nepaliLanguage,
    bool? mealReminders,
    bool? workoutReminder,
  }) {
    return AppSettings(
      darkMode: darkMode ?? this.darkMode,
      useLbs: useLbs ?? this.useLbs,
      nepaliLanguage: nepaliLanguage ?? this.nepaliLanguage,
      mealReminders: mealReminders ?? this.mealReminders,
      workoutReminder: workoutReminder ?? this.workoutReminder,
    );
  }
}

/// Reads settings from [SharedPreferences] on startup and writes every change
/// back immediately, so toggles stick across app launches.
class AppSettingsNotifier extends StateNotifier<AppSettings> {
  final SharedPreferences _prefs;

  AppSettingsNotifier(this._prefs) : super(_load(_prefs));

  static const _kDarkMode = 'pref_dark_mode';
  static const _kUseLbs = 'pref_use_lbs';
  static const _kNepali = 'pref_nepali_language';
  static const _kMealReminders = 'pref_meal_reminders';
  static const _kWorkoutReminder = 'pref_workout_reminder';

  static AppSettings _load(SharedPreferences p) => AppSettings(
        darkMode: p.getBool(_kDarkMode) ?? false,
        useLbs: p.getBool(_kUseLbs) ?? false,
        nepaliLanguage: p.getBool(_kNepali) ?? false,
        mealReminders: p.getBool(_kMealReminders) ?? true,
        workoutReminder: p.getBool(_kWorkoutReminder) ?? true,
      );

  Future<void> setDarkMode(bool v) async {
    state = state.copyWith(darkMode: v);
    await _prefs.setBool(_kDarkMode, v);
  }

  Future<void> setUseLbs(bool v) async {
    state = state.copyWith(useLbs: v);
    await _prefs.setBool(_kUseLbs, v);
  }

  Future<void> setNepaliLanguage(bool v) async {
    state = state.copyWith(nepaliLanguage: v);
    await _prefs.setBool(_kNepali, v);
  }

  Future<void> setMealReminders(bool v) async {
    state = state.copyWith(mealReminders: v);
    await _prefs.setBool(_kMealReminders, v);
  }

  Future<void> setWorkoutReminder(bool v) async {
    state = state.copyWith(workoutReminder: v);
    await _prefs.setBool(_kWorkoutReminder, v);
  }
}

final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  return AppSettingsNotifier(ref.watch(sharedPreferencesProvider));
});
