/// Domain entity — pure Dart, no Supabase imports.
class AppUser {
  final String id;
  final String email;
  final String? name;
  final bool hasCompletedOnboarding;

  const AppUser({
    required this.id,
    required this.email,
    this.name,
    this.hasCompletedOnboarding = false,
  });

  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    bool? hasCompletedOnboarding,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }
}
