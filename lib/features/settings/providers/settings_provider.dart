import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/auth_provider.dart';

// ── Push Notifications toggle ────────────────────────────────────────────────

class PushNotificationsNotifier extends Notifier<bool> {
  @override
  bool build() {
    final user = ref.watch(authProvider);
    return user?.settings['pushNotifications'] as bool? ?? true;
  }

  Future<void> toggle(bool value) async {
    state = value;
    final user = ref.read(authProvider);
    if (user == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.userId)
        .update({'settings.pushNotifications': value});
  }
}

final pushNotificationsProvider =
    NotifierProvider<PushNotificationsNotifier, bool>(
  PushNotificationsNotifier.new,
);

// ── Group Messages toggle ────────────────────────────────────────────────────

class GroupMessagesNotifier extends Notifier<bool> {
  @override
  bool build() {
    final user = ref.watch(authProvider);
    return user?.settings['groupMessages'] as bool? ?? true;
  }

  Future<void> toggle(bool value) async {
    state = value;
    final user = ref.read(authProvider);
    if (user == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.userId)
        .update({'settings.groupMessages': value});
  }
}

final groupMessagesProvider =
    NotifierProvider<GroupMessagesNotifier, bool>(
  GroupMessagesNotifier.new,
);
