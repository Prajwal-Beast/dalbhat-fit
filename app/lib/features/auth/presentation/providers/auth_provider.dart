import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/supabase_auth_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

// ── Datasource + repository providers ────────────────────────────────────────

final supabaseClientProvider = Provider<SupabaseClient>((_) {
  return Supabase.instance.client;
});

final authDatasourceProvider = Provider<SupabaseAuthDatasource>((ref) {
  return SupabaseAuthDatasource(ref.watch(supabaseClientProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authDatasourceProvider));
});

// ── Auth state stream ─────────────────────────────────────────────────────────

/// Emits the signed-in user on changes, or null when signed out.
final authStateProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

/// Current user — reactive to the auth stream so it updates immediately on
/// sign-in / sign-out / OAuth callback. Falls back to the synchronous value
/// while the stream is still loading (e.g. session restore on cold start).
final currentUserProvider = Provider<AppUser?>((ref) {
  final streamUser = ref.watch(authStateProvider).valueOrNull;
  if (streamUser != null) return streamUser;
  return ref.watch(authRepositoryProvider).currentUser;
});

// ── Auth actions notifier ─────────────────────────────────────────────────────

enum AuthStatus { idle, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;
  final AppUser? user;

  const AuthState({
    this.status = AuthStatus.idle,
    this.errorMessage,
    this.user,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    AppUser? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      user: user ?? this.user,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repo;

  AuthNotifier(this._repo) : super(const AuthState());

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final user = await _repo.signUpWithEmail(
          email: email, password: password, name: name);
      state = state.copyWith(status: AuthStatus.success, user: user);
      return true;
    } on AppAuthException catch (e) {
      state = state.copyWith(
          status: AuthStatus.error, errorMessage: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Something went wrong. Check your connection.');
      return false;
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final user =
          await _repo.signInWithEmail(email: email, password: password);
      state = state.copyWith(status: AuthStatus.success, user: user);
      return true;
    } on AppAuthException catch (e) {
      state = state.copyWith(
          status: AuthStatus.error, errorMessage: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Something went wrong. Check your connection.');
      return false;
    }
  }

  /// Opens the Google OAuth browser flow.
  /// Auth result arrives via [authStateChanges] — listen there for routing.
  Future<bool> launchGoogleSignIn() async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      await _repo.launchGoogleSignIn();
      // Browser launched — set idle so the button isn't stuck loading
      state = state.copyWith(status: AuthStatus.idle);
      return true;
    } on AppAuthException catch (e) {
      state = state.copyWith(
          status: AuthStatus.error, errorMessage: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Google sign-in failed. Try again.');
      return false;
    }
  }

  Future<void> signOut() async {
    await _repo.signOut();
    state = const AuthState();
  }

  Future<void> resetPassword(String email) async {
    await _repo.resetPassword(email);
  }

  void clearError() {
    state = state.copyWith(status: AuthStatus.idle, errorMessage: null);
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});
