import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/notification_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/groups_provider.dart';
import '../../../services/firebase/notification_service.dart';

void showSelectGroupSheet(
  BuildContext context, WidgetRef ref,
  {required String targetUserId, required String targetUserName}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => _Sheet(targetUserId: targetUserId, targetUserName: targetUserName),
  );
}

class _Sheet extends ConsumerWidget {
  final String targetUserId;
  final String targetUserName;
  const _Sheet({required this.targetUserId, required this.targetUserName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authProvider);
    final groups = ref.watch(groupsProvider);
    final adminGroups = groups.where((g) => g.adminId == currentUser?.userId).toList();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(
            width: 40, height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
          )),
          Text('Invite $targetUserName to…',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Select a group you manage',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          if (adminGroups.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(child: Text('You are not the admin of any group.',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500))),
            )
          else
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.35),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: adminGroups.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final g = adminGroups[i];
                  final isMember = g.memberIds.contains(targetUserId);
                  return ListTile(
                    leading: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(LucideIcons.users, size: 18, color: AppColors.primary),
                    ),
                    title: Text(g.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text(g.course, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    trailing: isMember
                        ? const Text('Already member', style: TextStyle(fontSize: 11, color: AppColors.textHint))
                        : const Icon(LucideIcons.chevronRight, size: 16, color: AppColors.textHint),
                    enabled: !isMember,
                    onTap: isMember ? null : () async {
                      Navigator.pop(context);
                      final notifRef = FirebaseFirestore.instance.collection('notifications').doc();
                      await NotificationService().createNotification(NotificationModel(
                        notifId: notifRef.id,
                        userId: targetUserId,
                        type: 'group_invite',
                        title: 'Group Invitation',
                        body: '${currentUser?.name ?? 'Someone'} invited you to join ${g.name}',
                        isRead: false,
                        createdAt: DateTime.now(),
                        data: {
                          'groupId': g.groupId,
                          'groupName': g.name,
                          'senderId': currentUser?.userId ?? '',
                          'senderName': currentUser?.name ?? '',
                        },
                      ));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Invitation sent to $targetUserName for ${g.name}')),
                        );
                      }
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

