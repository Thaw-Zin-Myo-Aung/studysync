import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/session_model.dart';

class SessionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _sessions(String groupId) =>
      _db.collection('groups').doc(groupId).collection('sessions');

  // ── Get Sessions ──────────────────────────────────────────────────────────

  Future<List<SessionModel>> getSessions(String groupId) async {
    try {
      final snapshot = await _sessions(groupId)
          .orderBy('date', descending: true)
          .get()
          .timeout(const Duration(seconds: 10));
      return snapshot.docs
          .map((doc) => SessionModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ── Create Session ────────────────────────────────────────────────────────

  Future<SessionModel> createSession({
    required String groupId,
    required String date,
    required String time,
    required String location,
  }) async {
    try {
      final ref = _sessions(groupId).doc();
      final data = {
        'sessionId': ref.id,
        'groupId':   groupId,
        'date':      date,
        'time':      time,
        'location':  location,
        'status':    'scheduled',
        'createdAt': FieldValue.serverTimestamp(),
      };
      await ref.set(data).timeout(const Duration(seconds: 10));
      final doc = await ref.get().timeout(const Duration(seconds: 10));
      return SessionModel.fromJson(doc.data()!);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ── Mark Attendance ───────────────────────────────────────────────────────

  Future<void> markAttendance(
    String groupId,
    String sessionId,
    bool attended,
  ) async {
    try {
      final uid = _auth.currentUser!.uid;
      await _sessions(groupId)
          .doc(sessionId)
          .collection('attendance')
          .doc(uid)
          .set({
            'attended': attended,
            'markedAt': FieldValue.serverTimestamp(),
          })
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

