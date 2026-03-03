import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/notification_model.dart';

class NotificationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _notifications =>
      _db.collection('notifications');

  // ── Get Notifications ────────────────────────────────────────────────────

  Future<List<NotificationModel>> getNotifications(String userId) async {
    try {
      final snapshot = await _notifications
          .where('userId', isEqualTo: userId)
          .limit(50)
          .get()
          .timeout(const Duration(seconds: 10));
      final results = snapshot.docs
          .map((doc) => NotificationModel.fromJson(doc.data()))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // newest first
      return results;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ── Mark As Read ─────────────────────────────────────────────────────────

  Future<void> markAsRead(String notifId) async {
    try {
      await _notifications
          .doc(notifId)
          .update({'isRead': true})
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ── Mark All As Read ─────────────────────────────────────────────────────

  Future<void> markAllAsRead(String userId) async {
    try {
      final snapshot = await _notifications
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get()
          .timeout(const Duration(seconds: 10));

      final batch = _db.batch();
      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit().timeout(const Duration(seconds: 10));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ── Create Notification ──────────────────────────────────────────────────

  Future<void> createNotification(NotificationModel notif) async {
    try {
      await _notifications
          .doc(notif.notifId)
          .set(notif.toJson())
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ── Fan-out notification to all group members ────────────────────────────
  /// Sends a notification to every member of [groupId] **except** [senderId].
  /// Only sends to members who have `settings.groupMessages == true`
  /// (defaults to true if the field is absent).
  Future<void> notifyGroupMembers({
    required String groupId,
    required String senderId,
    required String type,      // e.g. 'discussion_post' | 'session_created'
    required String title,
    required String body,
    Map<String, dynamic> extraData = const {},
  }) async {
    try {
      // 1. Fetch the group document to get member list
      final groupDoc =
          await _db.collection('groups').doc(groupId).get();
      if (!groupDoc.exists) return;
      final memberIds =
          List<String>.from(groupDoc.data()?['memberIds'] as List? ?? []);

      // 2. For each member (except sender) check their notification setting
      final batch = _db.batch();
      for (final uid in memberIds) {
        if (uid == senderId) continue;

        final userDoc = await _db.collection('users').doc(uid).get();
        if (!userDoc.exists) continue;

        final settings = Map<String, dynamic>.from(
            userDoc.data()?['settings'] as Map? ?? {});
        final wantsGroupNotifs =
            settings['groupMessages'] as bool? ?? true;
        if (!wantsGroupNotifs) continue;

        final ref = _notifications.doc();
        batch.set(ref, NotificationModel(
          notifId:   ref.id,
          userId:    uid,
          type:      type,
          title:     title,
          body:      body,
          isRead:    false,
          createdAt: DateTime.now(),
          data: {
            'groupId':  groupId,
            'senderId': senderId,
            ...extraData,
          },
        ).toJson());
      }
      await batch.commit();
    } catch (_) {
      // Notification failure should never crash the main action
    }
  }
}

