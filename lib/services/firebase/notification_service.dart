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
}

