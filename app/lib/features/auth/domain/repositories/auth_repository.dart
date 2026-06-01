import '../entities/app_user.dart';

/// Repository interface — domain layer only.
/// Data layer implements this.
abstract class AuthRepository {
  /// Stream of auth state changes.
  /// Emits [AppUser] when signed in, null when signed out.
  Stream<AppUser?> get authStateChanges;

  /// Returns the currently signed-in user, or null.
  AppUser? get currentUser;

  /// Sign up with email and password.
  /// Returns the new [AppUser] on success.
  /// Throws [AppAuthException] on failure.
  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  });

  /// Sign in with email and password.
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  });

  /// Launch Google OAuth in external browser.
  /// The auth result arrives via [authStateChanges] when the user returns to the app.
  Future<void> launchGoogleSignIn();

  /// Sign out.
  Future<void> signOut();

  /// Send a password reset email.
  Future<void> resetPassword(String email);
}

/// Typed auth error for clean error handling in the UI.
class AppAuthException implements Exception {
  final String message;
  final String? code;

  const AppAuthException(this.message, {this.code});

  @override
  String toString() => message;
}
