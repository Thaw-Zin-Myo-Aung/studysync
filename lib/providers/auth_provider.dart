import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/firebase/auth_service.dart';

final authServiceProvider = Provider<AuthService>((_) => AuthService());

class AuthNotifier extends Notifier<UserModel?> {
  AuthService get _authService => ref.read(authServiceProvider);

  @override
  UserModel? build() {
    // Kick off async init without blocking build
    Future(_init);
    return null;
  }

  Future<void> _init() async {
    state = await _authService.getCurrentUser();
  }

  Future<void> signUp(String email, String password,
      String name, String major, int year) async {
    final user = await _authService.signUp(email, password, name, major, year);
    state = user;
  }

  Future<void> signIn(String email, String password) async {
    final user = await _authService.signIn(email, password);
    state = user;
  }

  Future<void> signOut() async {
    await _authService.signOut();
    state = null;
  }

  void updateUser(UserModel user) => state = user;

  /// Re-fetches the current user's full document from Firestore
  /// and updates local state. Call this whenever a screen needs
  /// guaranteed-fresh data (e.g. ProfileScreen on mount).
  Future<void> refreshUser() async {
    final uid = state?.userId ?? _authService.currentUid;
    if (uid == null) return;
    try {
      final fresh = await _authService.fetchUserById(uid);
      if (fresh != null) state = fresh;
    } catch (_) {
      // keep existing state on network error
    }
  }
}
final authProvider = NotifierProvider<AuthNotifier, UserModel?>(
  AuthNotifier.new,
);
