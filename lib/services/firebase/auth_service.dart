import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Helper ────────────────────────────────────────────────────────────────

  Future<UserModel> _fetchUser(String uid) async {
    final doc = await _db
        .collection('users')
        .doc(uid)
        .get()
        .timeout(const Duration(seconds: 10));
    return UserModel.fromJson(doc.data()!);
  }

  // ── Sign Up ───────────────────────────────────────────────────────────────

  Future<UserModel> signUp(
    String email,
    String password,
    String name,
    String major,
    int year,
  ) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = cred.user!.uid;
      final studentId = email.split('@')[0];
      final data = {
        'userId':            uid,
        'studentId':         studentId,
        'name':              name,
        'email':             email,
        'major':             major,
        'year':              year,
        'reliabilityScore':  0,
        'sessionsAttended':  0,
        'sessionsScheduled': 0,
        'groupIds':          <String>[],
        'createdAt':         FieldValue.serverTimestamp(),
      };
      await _db
          .collection('users')
          .doc(uid)
          .set(data)
          .timeout(const Duration(seconds: 10));
      return _fetchUser(uid);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ── Sign In ───────────────────────────────────────────────────────────────

  Future<UserModel> signIn(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _fetchUser(cred.user!.uid);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ── Sign Out ──────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ── Get Current User ──────────────────────────────────────────────────────

  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;
      return _fetchUser(user.uid);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ── Auth State Stream ─────────────────────────────────────────────────────

  Stream<UserModel?> get authStateStream {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      try {
        return await _fetchUser(user.uid);
      } catch (_) {
        return null;
      }
    });
  }

  // ── Update Profile ────────────────────────────────────────────────────────

  Future<void> updateProfile({
    required String uid,
    required String major,
    required int year,
  }) async {
    try {
      await _db.collection('users').doc(uid).update({
        'major': major,
        'year':  year,
      }).timeout(const Duration(seconds: 10));
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

