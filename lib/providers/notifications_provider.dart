import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_model.dart';
import '../services/firebase/notification_service.dart';
import 'auth_provider.dart';

final notificationServiceProvider =
    Provider<NotificationService>((_) => NotificationService());

class NotificationsNotifier
    extends StreamNotifier<List<NotificationModel>> {
  late NotificationService _service;

  @override
  Stream<List<NotificationModel>> build() {
    _service = ref.read(notificationServiceProvider);
    final user = ref.watch(authProvider);
    if (user == null) return const Stream.empty();
    return _service.watchNotifications(user.userId);
  }

  Future<void> markRead(String notifId) async {
    await _service.markAsRead(notifId);
    // Optimistically update local state while stream catches up
    final current = state.value;
    if (current != null) {
      state = AsyncData([
        for (final n in current)
          if (n.notifId == notifId) n.copyWith(isRead: true) else n,
      ]);
    }
  }

  Future<void> markAllRead() async {
    final user = ref.read(authProvider);
    if (user == null) return;
    await _service.markAllAsRead(user.userId);
    // Optimistically mark all read locally
    final current = state.value;
    if (current != null) {
      state = AsyncData([
        for (final n in current) n.copyWith(isRead: true),
      ]);
    }
  }

  /// No-op: the stream updates automatically.
  /// Kept so existing callers don't break.
  Future<void> refresh() async {}
}

final notificationsProvider =
    StreamNotifierProvider<NotificationsNotifier, List<NotificationModel>>(
  NotificationsNotifier.new,
);
