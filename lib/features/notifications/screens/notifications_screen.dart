import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/route_constants.dart';
import '../../../models/notification_model.dart';
import '../../../providers/notifications_provider.dart';
import '../../../providers/groups_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/firebase/group_service.dart';
import '../../../services/firebase/notification_service.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundBlue,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 20, color: Colors.black87),
          onPressed: () => context.go(RouteConstants.home),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(notificationsProvider.notifier).markAllRead();
            },
            child: const Text(
              'Mark all read',
              style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: notifAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Something went wrong', style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.read(notificationsProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (notifications) {
          final newNotifications =
              notifications.where((n) => !n.isRead).toList();
          final earlierNotifications =
              notifications.where((n) => n.isRead).toList();

          if (newNotifications.isEmpty && earlierNotifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.bellOff, size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text(
                    'No notifications yet',
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: [
              if (newNotifications.isNotEmpty) ...[
                const _SectionLabel(label: 'NEW'),
                const SizedBox(height: 10),
                ...newNotifications.map((n) => _NotifCard(
                  item: _mapNotifToItem(n),
                  onTap: () => ref.read(notificationsProvider.notifier).markRead(n.notifId),
                  onAccept: n.type == 'group_invite'
                      ? () async {
                          final groupId = n.data['groupId'] as String?;
                          if (groupId != null) {
                            await ref.read(groupsProvider.notifier).joinGroup(groupId);
                          }
                          ref.read(notificationsProvider.notifier).markRead(n.notifId);
                        }
                      : n.type == 'group_create_invite'
                          ? () async {
                              final senderId = n.data['senderId'] as String? ?? '';
                              final senderName = n.data['senderName'] as String? ?? 'Partner';
                              final currentUser = ref.read(authProvider);
                              if (currentUser == null) return;
                              // Create a new group with both users
                              await ref.read(groupsProvider.notifier).createGroup(
                                name: '${currentUser.name} & $senderName',
                                course: 'General Study',
                                location: 'TBD',
                                description: 'Study group created from Discover',
                              );
                              // Add the sender to the newly created group
                              final groups = ref.read(groupsProvider);
                              if (groups.isNotEmpty) {
                                final newGroup = groups.last;
                                await GroupService().joinGroupForUser(newGroup.groupId, senderId);
                                // Reload groups
                                final user = ref.read(authProvider);
                                if (user != null) {
                                  await ref.read(groupsProvider.notifier).loadGroups(user.userId);
                                }
                              }
                              ref.read(notificationsProvider.notifier).markRead(n.notifId);
                              // Notify the original sender that the group was created
                              if (senderId.isNotEmpty) {
                                final confirmRef = FirebaseFirestore.instance.collection('notifications').doc();
                                await NotificationService().createNotification(NotificationModel(
                                  notifId: confirmRef.id,
                                  userId: senderId,
                                  type: 'group_invite',
                                  title: 'Group Created!',
                                  body: '${currentUser.name} accepted your invite. A new study group has been created!',
                                  isRead: false,
                                  createdAt: DateTime.now(),
                                  data: {
                                    'groupId': groups.isNotEmpty ? groups.last.groupId : '',
                                    'groupName': '${currentUser.name} & $senderName',
                                  },
                                ));
                              }
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Study group created!')),
                                );
                              }
                            }
                          : n.type == 'join_request'
                              ? () async {
                                  final groupId = n.data['groupId'] as String?;
                                  final requesterId = n.data['requesterId'] as String?;
                                  if (groupId != null && requesterId != null) {
                                    await GroupService().joinGroupForUser(groupId, requesterId);
                                    final user = ref.read(authProvider);
                                    if (user != null) {
                                      await ref.read(groupsProvider.notifier).loadGroups(user.userId);
                                    }
                                  }
                                  ref.read(notificationsProvider.notifier).markRead(n.notifId);
                                }
                              : null,
                  onDecline: (n.type == 'group_invite' || n.type == 'group_create_invite' || n.type == 'join_request')
                      ? () => ref.read(notificationsProvider.notifier).markRead(n.notifId)
                      : null,
                  onOutlinedAction: n.type == 'attendance_reminder'
                      ? () {
                          final groupId = n.data['groupId'] as String?;
                          if (groupId != null) {
                            context.go(RouteConstants.groupDetailPath(groupId));
                          }
                        }
                      : null,
                )),
              ],
              if (newNotifications.isNotEmpty && earlierNotifications.isNotEmpty)
                const SizedBox(height: 20),
              if (earlierNotifications.isNotEmpty) ...[
                const _SectionLabel(label: 'EARLIER'),
                const SizedBox(height: 10),
                ...earlierNotifications.map((n) => _NotifCard(
                  item: _mapNotifToItem(n),
                  onTap: () {},
                  onAccept: null,
                  onDecline: null,
                  onOutlinedAction: n.type == 'attendance_reminder'
                      ? () {
                          final groupId = n.data['groupId'] as String?;
                          if (groupId != null) {
                            context.go(RouteConstants.groupDetailPath(groupId));
                          }
                        }
                      : null,
                )),
              ],
            ],
          );
        },
      ),
    );
  }

  static _NotificationItem _mapNotifToItem(NotificationModel n) {
    final IconData icon;
    final Color iconBgColor;
    final Color iconColor;
    final _NotifType type;
    String? acceptLabel;
    String? declineLabel;

    switch (n.type) {
      case 'session_reminder':
        icon = LucideIcons.clock;
        iconBgColor = const Color(0xFFFFF3E0);
        iconColor = AppColors.warning;
        type = _NotifType.plain;
        break;
      case 'group_invite':
        icon = LucideIcons.userPlus;
        iconBgColor = AppColors.backgroundBlue;
        iconColor = AppColors.primary;
        type = _NotifType.actionable;
        acceptLabel = 'Accept';
        declineLabel = 'Decline';
        break;
      case 'discussion_post':
        icon = LucideIcons.messageSquare;
        iconBgColor = AppColors.backgroundBlue;
        iconColor = Colors.blueGrey;
        type = _NotifType.plain;
        break;
      case 'attendance_reminder':
        icon = LucideIcons.circleCheck;
        iconBgColor = const Color(0xFFE8F5E9);
        iconColor = AppColors.success;
        type = _NotifType.outlined;
        acceptLabel = 'Mark Attendance';
        break;
      case 'match_request':
        icon = LucideIcons.userSearch;
        iconBgColor = const Color(0xFFF3E8FF);
        iconColor = AppColors.purple;
        type = _NotifType.plain;
        break;
      case 'group_create_invite':
        icon = LucideIcons.usersRound;
        iconBgColor = const Color(0xFFE8F5E9);
        iconColor = AppColors.success;
        type = _NotifType.actionable;
        acceptLabel = 'Accept';
        declineLabel = 'Decline';
        break;
      case 'join_request':
        icon = LucideIcons.userCheck;
        iconBgColor = const Color(0xFFFFF3E0);
        iconColor = AppColors.warning;
        type = _NotifType.actionable;
        acceptLabel = 'Accept';
        declineLabel = 'Decline';
        break;
      default:
        icon = LucideIcons.bell;
        iconBgColor = AppColors.backgroundBlue;
        iconColor = Colors.blueGrey;
        type = _NotifType.plain;
    }

    // Format time ago
    final diff = DateTime.now().difference(n.createdAt);
    String time;
    if (diff.inMinutes < 60) {
      time = '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      time = '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      time = diff.inDays == 1 ? 'Yesterday' : '${diff.inDays}d ago';
    } else {
      time = '${diff.inDays ~/ 7}w ago';
    }

    return _NotificationItem(
      icon: icon,
      iconBgColor: iconBgColor,
      iconColor: iconColor,
      title: n.title,
      body: n.body,
      time: time,
      type: type,
      acceptLabel: acceptLabel,
      declineLabel: declineLabel,
    );
  }
}

// ─── Enums & Models ───────────────────────────────
enum _NotifType { plain, actionable, outlined }

class _NotificationItem {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String body;
  final String time;
  final _NotifType type;
  final String? acceptLabel;
  final String? declineLabel;

  const _NotificationItem({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.body,
    required this.time,
    required this.type,
    this.acceptLabel,
    this.declineLabel,
  });
}

// ─── Section Label ────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: AppColors.textSecondary,
      ),
    );
  }
}

// ─── Notification Card ────────────────────────────
class _NotifCard extends StatelessWidget {
  final _NotificationItem item;
  final VoidCallback onTap;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final VoidCallback? onOutlinedAction;

  const _NotifCard({
    required this.item,
    required this.onTap,
    this.onAccept,
    this.onDecline,
    this.onOutlinedAction,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: item.iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, color: item.iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.body,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Actionable buttons
            if (item.type == _NotifType.actionable && item.acceptLabel != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    ),
                    child: Text(item.acceptLabel!, style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: onDecline,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    ),
                    child: Text(item.declineLabel ?? 'Decline', style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                  ),
                ],
              ),
            ],

            // Outlined single button
            if (item.type == _NotifType.outlined && item.acceptLabel != null) ...[
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: onOutlinedAction,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.success),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                ),
                child: Text(item.acceptLabel!, style: const TextStyle(fontSize: 13, color: AppColors.success, fontWeight: FontWeight.w600)),
              ),
            ],

            // Timestamp
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                item.time,
                style: const TextStyle(fontSize: 12, color: AppColors.textHint),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
