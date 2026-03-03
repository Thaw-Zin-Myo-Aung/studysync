import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/notification_model.dart';
import '../../../models/study_group_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/groups_provider.dart';
import '../../../services/firebase/notification_service.dart';

void showInviteMemberSheet(
    BuildContext context, WidgetRef ref, StudyGroupModel group) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _InviteMemberSheet(group: group),
  );
}

class _InviteMemberSheet extends ConsumerStatefulWidget {
  final StudyGroupModel group;
  const _InviteMemberSheet({required this.group});

  @override
  ConsumerState<_InviteMemberSheet> createState() =>
      _InviteMemberSheetState();
}

class _InviteMemberSheetState extends ConsumerState<_InviteMemberSheet> {
  final _ctrl = TextEditingController();
  bool _isLoading = false;
  String? _error;
  bool _success = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _handleInvite() async {
    final studentId = _ctrl.text.trim();
    if (studentId.isEmpty) {
      setState(() => _error = 'Please enter a student ID.');
      return;
    }
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final service = ref.read(groupServiceProvider);
      final user = await service.lookupUserByStudentId(studentId);

      if (user == null) {
        setState(() {
          _isLoading = false;
          _error = 'No user found with ID "$studentId".';
        });
        return;
      }

      if (widget.group.memberIds.contains(user.userId)) {
        setState(() {
          _isLoading = false;
          _error = '${user.name} is already a member.';
        });
        return;
      }

      final currentUser = ref.read(authProvider);
      final notifService = NotificationService();
      final notifRef =
          FirebaseFirestore.instance.collection('notifications').doc();

      await notifService.createNotification(NotificationModel(
        notifId: notifRef.id,
        userId: user.userId,
        type: 'group_invite',
        title: 'Group Invitation',
        body:
            '${currentUser?.name ?? 'Someone'} invited you to join ${widget.group.name}',
        isRead: false,
        createdAt: DateTime.now(),
        data: {
          'groupId': widget.group.groupId,
          'groupName': widget.group.name,
          'senderId': currentUser?.userId ?? '',
          'senderName': currentUser?.name ?? '',
        },
      ));

      setState(() {
        _isLoading = false;
        _success = true;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Something went wrong. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: const BoxDecoration(
                      color: AppColors.primarySurface, shape: BoxShape.circle),
                  child: const Icon(LucideIcons.userPlus,
                      color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Invite Member',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    Text('to ${widget.group.name}',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_success) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(LucideIcons.circleCheck,
                        color: AppColors.success, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Invitation sent successfully!',
                        style: TextStyle(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Done',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ),
            ] else ...[
              TextField(
                controller: _ctrl,
                textCapitalization: TextCapitalization.none,
                decoration: InputDecoration(
                  hintText: 'Enter student ID (e.g. 6531503060)',
                  prefixIcon: const Icon(LucideIcons.search, size: 18),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 14),
                  errorText: _error,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleInvite,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Text('Send Invitation',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


