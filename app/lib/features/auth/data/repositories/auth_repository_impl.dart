import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/supabase_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseAuthDatasource _datasource;

  AuthRepositoryImpl(this._datasource);

  @override
  Stream<AppUser?> get authStateChanges => _datasource.authStateChanges;

  @override
  AppUser? get currentUser => _datasource.currentUser;

  @override
  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) =>
      _datasource.signUpWithEmail(
          email: email, password: password, name: name);

  @override
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) =>
      _datasource.signInWithEmail(email: email, password: password);

  @override
  Future<void> launchGoogleSignIn() => _datasource.launchGoogleSignIn();

  @override
  Future<void> signOut() => _datasource.signOut();

  @override
  Future<void> resetPassword(String email) => _datasource.resetPassword(email);
}
