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
        'nameLower':       name.toLowerCase(),
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
  /// [name] contains any of the query words (case-insensitive).
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

      // 2 — fetch all groups and filter client-side for case-insensitive
      //     partial word matching (e.g. "calculus" matches "Calculus Review")
      final allGroups = await _db
          .collection('groups')
          .limit(200)
          .get()
          .timeout(const Duration(seconds: 10));

      final qLower = q.toLowerCase();
      final queryWords = qLower.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();

      // Merge, deduplicate by groupId
      final seen = <String>{};
      final results = <StudyGroupModel>[];

      // Add exact ID matches first
      for (final doc in byId.docs) {
        final g = StudyGroupModel.fromJson(doc.data());
        if (seen.add(g.groupId)) results.add(g);
      }

      // Add name matches — any query word matching any word in the group name
      for (final doc in allGroups.docs) {
        final g = StudyGroupModel.fromJson(doc.data());
        if (seen.contains(g.groupId)) continue;
        final nameLower = g.name.toLowerCase();
        final matches = queryWords.any((word) => nameLower.contains(word));
        if (matches) {
          seen.add(g.groupId);
          results.add(g);
        }
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
      // Only update the group's memberIds — the admin cannot write to another
      // user's document (Firestore rules: only owner can write their own doc).
      // The new member's groupIds list will sync automatically the next time
      // they load their groups (getUserGroups queries by memberIds arrayContains).
      await _db
          .collection('groups')
          .doc(groupId)
          .update({'memberIds': FieldValue.arrayUnion([userId])})
          .timeout(const Duration(seconds: 10));
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
    String? iconName,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (name != null) {
        updates['name'] = name;
        updates['nameLower'] = name.toLowerCase();
      }
      if (course != null) updates['course'] = course;
      if (description != null) updates['description'] = description;
      if (location != null) updates['location'] = location;
      if (maxMembers != null) updates['maxMembers'] = maxMembers;
      if (iconName != null) updates['iconName'] = iconName;
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
