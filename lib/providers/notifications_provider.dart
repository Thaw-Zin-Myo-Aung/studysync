import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_model.dart';
import '../services/firebase/notification_service.dart';
import 'auth_provider.dart';

final notificationServiceProvider =
    Provider<NotificationService>((_) => NotificationService());

class NotificationsNotifier
    extends AsyncNotifier<List<NotificationModel>> {
  late NotificationService _service;

  @override
  Future<List<NotificationModel>> build() async {
    _service = ref.read(notificationServiceProvider);
    final user = ref.watch(authProvider);
    if (user == null) return [];
    return _service.getNotifications(user.userId);
  }

  Future<void> markRead(String notifId) async {
    await _service.markAsRead(notifId);
    state = AsyncData([
      for (final n in state.value ?? [])
        if (n.notifId == notifId) n.copyWith(isRead: true) else n,
    ]);
  }

  Future<void> markAllRead() async {
    final user = ref.read(authProvider);
    if (user == null) return;
    await _service.markAllAsRead(user.userId);
    state = AsyncData([
      for (final n in state.value ?? []) n.copyWith(isRead: true),
    ]);
  }

  Future<void> refresh() async {
    final user = ref.read(authProvider);
    if (user == null) {
      state = const AsyncData([]);
      return;
    }
    state = const AsyncLoading();
    state = AsyncData(await _service.getNotifications(user.userId));
  }
}

final notificationsProvider =
    AsyncNotifierProvider<NotificationsNotifier, List<NotificationModel>>(
  NotificationsNotifier.new,
);

