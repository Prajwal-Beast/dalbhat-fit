import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/profile_datasource.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// ── Profile datasource ────────────────────────────────────────────────────────

final profileDatasourceProvider = Provider<ProfileDatasource>((ref) {
  return ProfileDatasource(ref.watch(supabaseClientProvider));
});

// ── Save onboarding state ─────────────────────────────────────────────────────

enum SaveProfileStatus { idle, saving, done, error }

class SaveProfileState {
  final SaveProfileStatus status;
  final String? errorMessage;

  const SaveProfileState({
    this.status = SaveProfileStatus.idle,
    this.errorMessage,
  });
}

class OnboardingNotifier extends StateNotifier<SaveProfileState> {
  final ProfileDatasource _datasource;
  final String? _userId;

  OnboardingNotifier(this._datasource, this._userId)
      : super(const SaveProfileState());

  Future<bool> saveProfile({
    required String name,
    required int age,
    required String gender,
    required double heightCm,
    required double weightKg,
    required String goal,
    required String activityLevel,
    required String workoutPref,
    required int dailyCalories,
    required Map<String, int> macros,
  }) async {
    final userId = _userId;
    if (userId == null) {
      state = const SaveProfileState(
        status: SaveProfileStatus.error,
        errorMessage: 'Not signed in. Please sign in and try again.',
      );
      return false;
    }

    state = const SaveProfileState(status: SaveProfileStatus.saving);

    try {
      await _datasource.saveOnboardingProfile(
        userId: userId,
        name: name,
        age: age,
        gender: gender,
        heightCm: heightCm,
        weightKg: weightKg,
        goal: goal,
        activityLevel: activityLevel,
        workoutPref: workoutPref,
        dailyCalories: dailyCalories,
        macros: macros,
      );
      state = const SaveProfileState(status: SaveProfileStatus.done);
      return true;
    } catch (e) {
      state = SaveProfileState(
        status: SaveProfileStatus.error,
        errorMessage: 'Could not save profile. Check your connection.',
      );
      return false;
    }
  }
}

final onboardingNotifierProvider =
    StateNotifierProvider<OnboardingNotifier, SaveProfileState>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  final datasource = ref.watch(profileDatasourceProvider);
  return OnboardingNotifier(datasource, currentUser?.id);
});
