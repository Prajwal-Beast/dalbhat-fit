import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../onboarding/data/datasources/profile_datasource.dart';

// ── Datasource ────────────────────────────────────────────────────────────────

final profileDatasourceProvider = Provider<ProfileDatasource>((ref) {
  return ProfileDatasource(ref.watch(supabaseClientProvider));
});

// ── User profile ──────────────────────────────────────────────────────────────

/// Raw profile row from user_profiles. Null if user hasn't onboarded yet.
final userProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  return ref.watch(profileDatasourceProvider).getProfile(user.id);
});

/// Daily calorie target from profile — falls back to 1800 while loading.
final profileCalorieTargetProvider = Provider<int>((ref) {
  final profileAsync = ref.watch(userProfileProvider);
  return profileAsync.whenOrNull(
        data: (p) => (p?['daily_calories'] as int?) ?? 1800,
      ) ??
      1800;
});

/// User's display name from profile (more up-to-date than auth metadata).
final profileNameProvider = Provider<String>((ref) {
  final profileAsync = ref.watch(userProfileProvider);
  final authName = ref.watch(currentUserProvider)?.name;
  return profileAsync.whenOrNull(
        data: (p) => (p?['name'] as String?) ?? authName ?? 'there',
      ) ??
      authName ??
      'there';
});

/// Latest body weight from profile (set during onboarding).
final profileWeightProvider = Provider<double?>((ref) {
  final profileAsync = ref.watch(userProfileProvider);
  return profileAsync.whenOrNull(
    data: (p) => (p?['weight_kg'] as num?)?.toDouble(),
  );
});
