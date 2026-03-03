import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/discussion_model.dart';
import '../models/reply_model.dart';

class DiscussionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _discussions(String groupId) =>
      _db.collection('groups').doc(groupId).collection('discussions');

  CollectionReference<Map<String, dynamic>> _replies(
          String groupId, String discussionId) =>
      _discussions(groupId).doc(discussionId).collection('replies');

  // ── Get Discussions ───────────────────────────────────────────────────────

  Future<List<DiscussionModel>> getDiscussions(String groupId) async {
    try {
      final snapshot = await _discussions(groupId)
          .orderBy('timestamp', descending: true)
          .get()
          .timeout(const Duration(seconds: 10));
      return snapshot.docs
          .map((doc) => DiscussionModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ── Create Discussion ─────────────────────────────────────────────────────

  Future<DiscussionModel> createDiscussion({
    required String groupId,
    required String topic,
    required String message,
    required String authorName,
  }) async {
    try {
      final uid = _auth.currentUser!.uid;
      final ref = _discussions(groupId).doc();
      final data = {
        'discussionId': ref.id,
        'groupId':      groupId,
        'authorId':     uid,
        'authorName':   authorName,
        'topic':        topic,
        'message':      message,
        'timestamp':    FieldValue.serverTimestamp(),
        'replyCount':   0,
      };
      await ref.set(data).timeout(const Duration(seconds: 10));
      final doc = await ref.get().timeout(const Duration(seconds: 10));
      return DiscussionModel.fromJson(doc.data()!);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ── Get Replies ───────────────────────────────────────────────────────────

  Future<List<ReplyModel>> getReplies(
      String groupId, String discussionId) async {
    try {
      final snapshot = await _replies(groupId, discussionId)
          .orderBy('timestamp', descending: false)
          .get()
          .timeout(const Duration(seconds: 10));
      return snapshot.docs
          .map((doc) => ReplyModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ── Add Reply ─────────────────────────────────────────────────────────────

  Future<ReplyModel> addReply({
    required String groupId,
    required String discussionId,
    required String message,
    required String authorName,
  }) async {
    try {
      final uid = _auth.currentUser!.uid;
      final ref = _replies(groupId, discussionId).doc();
      final data = {
        'replyId':    ref.id,
        'authorId':   uid,
        'authorName': authorName,
        'message':    message,
        'timestamp':  FieldValue.serverTimestamp(),
      };
      await ref.set(data).timeout(const Duration(seconds: 10));

      // Increment reply count on the discussion document
      await _discussions(groupId).doc(discussionId).update({
        'replyCount': FieldValue.increment(1),
      }).timeout(const Duration(seconds: 10));

      final doc = await ref.get().timeout(const Duration(seconds: 10));
      return ReplyModel.fromJson(doc.data()!);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ── Delete Discussion ─────────────────────────────────────────────────────

  Future<void> deleteDiscussion(String groupId, String discussionId) async {
    try {
      await _discussions(groupId)
          .doc(discussionId)
          .delete()
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

