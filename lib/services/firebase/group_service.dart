import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/study_group_model.dart';
import '../../models/user_model.dart';

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
    String description = '',
    int maxMembers = 6,
  }) async {
    try {
      final uid = _auth.currentUser!.uid;
      final ref = _db.collection('groups').doc();
      final data = {
        'groupId':         ref.id,
        'name':            name,
        'course':          course,
        'location':        location,
        'description':     description,
        'maxMembers':      maxMembers,
        'adminId':         uid,
        'memberIds':       [uid],
        'nextSessionDate': '',
        'isActive':        true,
        'createdAt':       FieldValue.serverTimestamp(),
      };
      await ref.set(data).timeout(const Duration(seconds: 10));
      // Add this group to the creator's groupIds list
      await _db.collection('users').doc(uid).update({
        'groupIds': FieldValue.arrayUnion([ref.id]),
      }).timeout(const Duration(seconds: 10));
      return _fetchGroup(ref.id);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ── Search Groups ─────────────────────────────────────────────────────────

  /// Returns groups whose [groupId] exactly matches [query] OR whose
  /// [name] starts with [query] (case-insensitive via range query).
  Future<List<StudyGroupModel>> searchGroups(String query) async {
    try {
      final q = query.trim();
      if (q.isEmpty) return [];

      // 1 — exact groupId lookup
      final byId = await _db
          .collection('groups')
          .where('groupId', isEqualTo: q)
          .get()
          .timeout(const Duration(seconds: 10));

      // 2 — name prefix search (Firestore range trick)
      final end = q.substring(0, q.length - 1) +
          String.fromCharCode(q.codeUnitAt(q.length - 1) + 1);
      final byName = await _db
          .collection('groups')
          .where('name', isGreaterThanOrEqualTo: q)
          .where('name', isLessThan: end)
          .limit(10)
          .get()
          .timeout(const Duration(seconds: 10));

      // Merge, deduplicate by groupId
      final seen = <String>{};
      final results = <StudyGroupModel>[];
      for (final doc in [...byId.docs, ...byName.docs]) {
        final g = StudyGroupModel.fromJson(doc.data());
        if (seen.add(g.groupId)) results.add(g);
      }
      return results;
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
      // Add this group to the joining user's groupIds list
      await _db.collection('users').doc(uid).update({
        'groupIds': FieldValue.arrayUnion([groupId]),
      }).timeout(const Duration(seconds: 10));
      return _fetchGroup(groupId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ── Join Group For User (admin adding another user) ───────────────────────

  Future<StudyGroupModel> joinGroupForUser(String groupId, String userId) async {
    try {
      await _db
          .collection('groups')
          .doc(groupId)
          .update({'memberIds': FieldValue.arrayUnion([userId])})
          .timeout(const Duration(seconds: 10));
      await _db.collection('users').doc(userId).update({
        'groupIds': FieldValue.arrayUnion([groupId]),
      }).timeout(const Duration(seconds: 10));
      return _fetchGroup(groupId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ── Leave Group ───────────────────────────────────────────────────────────

  Future<void> leaveGroup(String groupId) async {
    try {
      final uid = _auth.currentUser!.uid;
      await _db.collection('groups').doc(groupId).update({
        'memberIds': FieldValue.arrayRemove([uid]),
      }).timeout(const Duration(seconds: 10));
      await _db.collection('users').doc(uid).update({
        'groupIds': FieldValue.arrayRemove([groupId]),
      }).timeout(const Duration(seconds: 10));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ── Remove Member ─────────────────────────────────────────────────────────

  Future<void> removeMember(String groupId, String memberId) async {
    try {
      await _db.collection('groups').doc(groupId).update({
        'memberIds': FieldValue.arrayRemove([memberId]),
      }).timeout(const Duration(seconds: 10));
      await _db.collection('users').doc(memberId).update({
        'groupIds': FieldValue.arrayRemove([groupId]),
      }).timeout(const Duration(seconds: 10));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ── Make Admin ────────────────────────────────────────────────────────────

  Future<StudyGroupModel> makeAdmin(String groupId, String memberId) async {
    try {
      await _db.collection('groups').doc(groupId).update({
        'adminId': memberId,
      }).timeout(const Duration(seconds: 10));
      return _fetchGroup(groupId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ── Lookup User by Student ID ─────────────────────────────────────────────

  Future<UserModel?> lookupUserByStudentId(String studentId) async {
    try {
      final snapshot = await _db
          .collection('users')
          .where('studentId', isEqualTo: studentId)
          .limit(1)
          .get()
          .timeout(const Duration(seconds: 10));
      if (snapshot.docs.isEmpty) return null;
      return UserModel.fromJson(snapshot.docs.first.data());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ── Update Group ──────────────────────────────────────────────────────────

  Future<StudyGroupModel> updateGroup({
    required String groupId,
    String? name,
    String? course,
    String? description,
    String? location,
    int? maxMembers,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (course != null) updates['course'] = course;
      if (description != null) updates['description'] = description;
      if (location != null) updates['location'] = location;
      if (maxMembers != null) updates['maxMembers'] = maxMembers;
      if (updates.isNotEmpty) {
        await _db
            .collection('groups')
            .doc(groupId)
            .update(updates)
            .timeout(const Duration(seconds: 10));
      }
      return _fetchGroup(groupId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ── Delete Group ──────────────────────────────────────────────────────────

  Future<void> deleteGroup(String groupId) async {
    try {
      final group = await _fetchGroup(groupId);
      final batch = _db.batch();
      // Remove groupId from every member's groupIds
      for (final uid in group.memberIds) {
        batch.update(_db.collection('users').doc(uid), {
          'groupIds': FieldValue.arrayRemove([groupId]),
        });
      }
      batch.delete(_db.collection('groups').doc(groupId));
      await batch.commit().timeout(const Duration(seconds: 15));
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
