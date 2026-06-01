import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Wraps Supabase Auth. All Supabase-specific types stay inside this file.
/// The rest of the app only sees [AppUser] and [AppAuthException].
class SupabaseAuthDatasource {
  final SupabaseClient _client;
  SupabaseAuthDatasource(this._client);

  Stream<AppUser?> get authStateChanges {
    return _client.auth.onAuthStateChange.map((event) {
      final user = event.session?.user;
      return user != null ? _toAppUser(user) : null;
    });
  }

  AppUser? get currentUser {
    final user = _client.auth.currentUser;
    return user != null ? _toAppUser(user) : null;
  }

  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final res = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      final user = res.user;
      if (user == null) {
        throw const AppAuthException('Sign-up failed — please try again.');
      }
      return _toAppUser(user, name: name);
    } on AuthApiException catch (e) {
      throw AppAuthException(_friendlyMessage(e.message), code: e.statusCode.toString());
    } on AppAuthException {
      rethrow;
    } catch (_) {
      throw const AppAuthException('Something went wrong. Check your connection.');
    }
  }

  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = res.user;
      if (user == null) throw const AppAuthException('Sign-in failed.');
      return _toAppUser(user);
    } on AuthApiException catch (e) {
      throw AppAuthException(_friendlyMessage(e.message), code: e.statusCode.toString());
    } on AppAuthException {
      rethrow;
    } catch (_) {
      throw const AppAuthException('Something went wrong. Check your connection.');
    }
  }

  /// Opens Google OAuth in an external browser.
  /// Returns null immediately — the actual sign-in completes via deep link,
  /// which triggers [authStateChanges]. Callers should listen to that stream.
  Future<void> launchGoogleSignIn() async {
    try {
      await _client.auth.signInWithOAuth(
        OAuthProvider.google,
        // Must match the redirect URL in Supabase Dashboard → Auth → URL Configuration
        redirectTo: 'com.dhalbhatfit.dalbhat_fit://login-callback/',
      );
    } on AppAuthException {
      rethrow;
    } catch (_) {
      throw const AppAuthException('Could not open Google sign-in. Try again.');
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (_) {
      throw const AppAuthException(
          'Could not send reset email. Check your connection.');
    }
  }

  // ── helpers ──────────────────────────────────────────────────────────────

  AppUser _toAppUser(User user, {String? name}) {
    final meta = user.userMetadata;
    return AppUser(
      id: user.id,
      email: user.email ?? '',
      name: name ?? meta?['name'] as String?,
      hasCompletedOnboarding: meta?['onboarding_done'] == true,
    );
  }

  String _friendlyMessage(String raw) {
    final lower = raw.toLowerCase();
    if (lower.contains('invalid login') || lower.contains('invalid credentials')) {
      return 'Incorrect email or password.';
    }
    if (lower.contains('user already registered') || lower.contains('already exists')) {
      return 'An account with this email already exists. Sign in instead.';
    }
    if (lower.contains('email not confirmed')) {
      return 'Please confirm your email address before signing in.';
    }
    if (lower.contains('rate limit')) {
      return 'Too many attempts. Wait a moment and try again.';
    }
    if (lower.contains('password')) {
      return 'Password must be at least 8 characters.';
    }
    return 'Something went wrong. Please try again.';
  }
}
