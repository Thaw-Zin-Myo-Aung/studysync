import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/attendance_model.dart';
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
    required String title,
    required String date,
    required String time,
    required String location,
  }) async {
    try {
      final ref = _sessions(groupId).doc();
      final data = {
        'sessionId': ref.id,
        'groupId':   groupId,
        'title':     title,
        'date':      date,
        'time':      time,
        'location':  location,
        'status':    'scheduled',
        'createdAt': FieldValue.serverTimestamp(),
      };
      await ref.set(data).timeout(const Duration(seconds: 10));

      // Increment sessionsScheduled for every member of this group
      final groupDoc = await _db.collection('groups').doc(groupId).get();
      final memberIds = List<String>.from(
          groupDoc.data()?['memberIds'] as List? ?? []);
      if (memberIds.isNotEmpty) {
        final batch = _db.batch();
        for (final uid in memberIds) {
          batch.update(_db.collection('users').doc(uid),
              {'sessionsScheduled': FieldValue.increment(1)});
        }
        await batch.commit().timeout(const Duration(seconds: 10));
      }

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

      // 1. Write the attendance record
      await _sessions(groupId)
          .doc(sessionId)
          .collection('attendance')
          .doc(uid)
          .set({
            'attended': attended,
            'markedAt': FieldValue.serverTimestamp(),
          })
          .timeout(const Duration(seconds: 10));

      // 2. Update the user's sessionsAttended count and recalculate
      //    reliabilityScore = (sessionsAttended / sessionsScheduled) * 100
      //    clamped to 0–100. Only increment when marking as attended (not un-attended).
      if (attended) {
        final userRef = _db.collection('users').doc(uid);
        await _db.runTransaction((txn) async {
          final snap = await txn.get(userRef);
          if (!snap.exists) return;
          final data = snap.data()!;
          final attended  = (data['sessionsAttended']  as int? ?? 0) + 1;
          final scheduled = (data['sessionsScheduled'] as int? ?? 0);
          // sessionsScheduled should always be >= attended; guard against 0
          final reliability = scheduled > 0
              ? ((attended / scheduled) * 100).round().clamp(0, 100)
              : 100; // if no sessions scheduled yet, treat as perfect
          txn.update(userRef, {
            'sessionsAttended': attended,
            'reliabilityScore': reliability,
          });
        }).timeout(const Duration(seconds: 10));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ── Update Session Status ─────────────────────────────────────────────────

  Future<void> updateSessionStatus(
    String groupId,
    String sessionId,
    String status,
  ) async {
    try {
      await _sessions(groupId)
          .doc(sessionId)
          .update({'status': status})
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ── Get Attendance ────────────────────────────────────────────────────────

  Future<List<AttendanceModel>> getAttendance(
    String groupId,
    String sessionId,
  ) async {
    try {
      final snapshot = await _sessions(groupId)
          .doc(sessionId)
          .collection('attendance')
          .get()
          .timeout(const Duration(seconds: 10));
      return snapshot.docs
          .map((doc) => AttendanceModel.fromJson(doc.data(), docId: doc.id))
          .toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ── Check If Current User Attended ────────────────────────────────────────

  Future<bool> hasUserAttended(String groupId, String sessionId) async {
    try {
      final uid = _auth.currentUser!.uid;
      final doc = await _sessions(groupId)
          .doc(sessionId)
          .collection('attendance')
          .doc(uid)
          .get()
          .timeout(const Duration(seconds: 10));
      if (!doc.exists) return false;
      return doc.data()?['attended'] as bool? ?? false;
    } catch (e) {
      return false;
    }
  }
}

