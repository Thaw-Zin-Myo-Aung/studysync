import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/study_group_model.dart';

class GroupService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Helper ────────────────────────────────────────────────────────────────

  Future<StudyGroupModel> _fetchGroup(String groupId) async {
    final doc = await _db
        .collection('groups')
        .doc(groupId)
        .get()
        .timeout(const Duration(seconds: 10));
    return StudyGroupModel.fromJson(doc.data()!);
  }

  // ── Get User Groups ───────────────────────────────────────────────────────

  Future<List<StudyGroupModel>> getUserGroups(String userId) async {
    try {
      final snapshot = await _db
          .collection('groups')
          .where('memberIds', arrayContains: userId)
          .get()
          .timeout(const Duration(seconds: 10));
      return snapshot.docs
          .map((doc) => StudyGroupModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ── Create Group ──────────────────────────────────────────────────────────

  Future<StudyGroupModel> createGroup({
    required String name,
    required String course,
    required String location,
  }) async {
    try {
      final uid = _auth.currentUser!.uid;
      final ref = _db.collection('groups').doc();
      final data = {
        'groupId':         ref.id,
        'name':            name,
        'course':          course,
        'location':        location,
        'adminId':         uid,
        'memberIds':       [uid],
        'nextSessionDate': '',
        'isActive':        true,
        'createdAt':       FieldValue.serverTimestamp(),
      };
      await ref.set(data).timeout(const Duration(seconds: 10));
      return _fetchGroup(ref.id);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ── Join Group ────────────────────────────────────────────────────────────

  Future<StudyGroupModel> joinGroup(String groupId) async {
    try {
      final uid = _auth.currentUser!.uid;
      await _db
          .collection('groups')
          .doc(groupId)
          .update({'memberIds': FieldValue.arrayUnion([uid])})
          .timeout(const Duration(seconds: 10));
      return _fetchGroup(groupId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

