import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/group_icons.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../models/study_group_model.dart';
import '../../../providers/groups_provider.dart';

class GroupSettingsScreen extends ConsumerStatefulWidget {
  final String groupId;
  const GroupSettingsScreen({super.key, required this.groupId});

  @override
  ConsumerState<GroupSettingsScreen> createState() =>
      _GroupSettingsScreenState();
}

class _GroupSettingsScreenState extends ConsumerState<GroupSettingsScreen> {
  final _nameCtrl = TextEditingController();
  final _courseCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _courseCtrl.dispose();
    _locationCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _populateFields(StudyGroupModel group) {
    _nameCtrl.text = group.name;
    _courseCtrl.text = group.course;
    _locationCtrl.text = group.location;
    _descCtrl.text = group.description;
  }

  Future<void> _saveChanges(StudyGroupModel group) async {
    setState(() => _isSaving = true);
    try {
      await ref.read(groupsProvider.notifier).updateGroup(
            groupId: group.groupId,
            name: _nameCtrl.text.trim(),
            course: _courseCtrl.text.trim(),
            location: _locationCtrl.text.trim(),
            description: _descCtrl.text.trim(),
          );
      if (mounted) {
        setState(() {
          _isEditing = false;
          _isSaving = false;
        });
        AppSnackBar.success(context, 'Group updated successfully');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        AppSnackBar.error(context, 'Failed to update: $e');
      }
    }
  }

  Future<void> _deleteGroup(StudyGroupModel group) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Group'),
        content: Text(
            'Are you sure you want to delete "${group.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete',
                  style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(groupsProvider.notifier).deleteGroup(group.groupId);
      if (mounted) context.go(RouteConstants.groups);
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(context, 'Failed to delete: $e');
      }
    }
  }

  Future<void> _leaveGroup(StudyGroupModel group) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Leave Group'),
        content: Text('Are you sure you want to leave "${group.name}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Leave',
                  style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(groupsProvider.notifier).leaveGroup(group.groupId);
      if (mounted) context.go(RouteConstants.groups);
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(context, 'Failed to leave: $e');
      }
    }
  }

  void _showIconPicker(BuildContext context, StudyGroupModel group) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _IconPickerSheet(
        currentIconName: group.iconName,
        onSelect: (key) async {
          await ref.read(groupsProvider.notifier).updateGroup(
                groupId: group.groupId,
                iconName: key,
              );
          if (context.mounted) {
            AppSnackBar.success(context, 'Group icon updated!');
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groups = ref.watch(groupsProvider);
    final group = groups
        .cast<StudyGroupModel?>()
        .firstWhere((g) => g?.groupId == widget.groupId, orElse: () => null);
    if (group == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundBlue,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          leading: IconButton(
              icon: const Icon(LucideIcons.arrowLeft),
              onPressed: () => context.pop()),
          title: const Text('Group Settings'),
        ),
        body: const Center(child: Text('Group not found')),
      );
    }

    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    final isAdmin = currentUid == group.adminId;

    return Scaffold(
      backgroundColor: AppColors.backgroundBlue,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        title: const Text('Group Settings',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87)),
        centerTitle: true,
        actions: [
          if (isAdmin && !_isEditing)
            IconButton(
              icon: const Icon(LucideIcons.pencil, size: 20),
              onPressed: () {
                _populateFields(group);
                setState(() => _isEditing = true);
              },
            ),
          if (isAdmin && _isEditing)
            IconButton(
              icon: const Icon(LucideIcons.x, size: 20),
              onPressed: () => setState(() => _isEditing = false),
            ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Group Info Card ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: _isEditing
                  ? _buildEditForm(group)
                  : _buildInfoView(group, isAdmin),
            ),
            const SizedBox(height: 16),
            // ── Members section ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(LucideIcons.users,
                          size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      const Text('Members',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${group.memberIds.length}/${group.maxMembers}',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...group.memberIds.map((uid) => _MemberRow(
                        uid: uid,
                        isAdmin: uid == group.adminId,
                        isCurrentUserAdmin: isAdmin,
                        groupId: group.groupId,
                      )),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // ── Danger zone ──
            if (isAdmin)
              _DangerButton(
                label: 'Delete Group',
                icon: LucideIcons.trash2,
                onTap: () => _deleteGroup(group),
              )
            else
              _DangerButton(
                label: 'Leave Group',
                icon: LucideIcons.logOut,
                onTap: () => _leaveGroup(group),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoView(StudyGroupModel group, bool isAdmin) {
    final iconData = GroupIcons.resolve(group.iconName);
    final iconColor = GroupIcons.resolveColor(group.iconName);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Group icon row (tappable for admin) ──────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(LucideIcons.image, size: 16, color: AppColors.textHint),
            const SizedBox(width: 10),
            const SizedBox(
              width: 90,
              child: Text('Icon',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(iconData, size: 20, color: iconColor),
            ),
            if (isAdmin) ...[
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => _showIconPicker(context, group),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Change',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary)),
                ),
              ),
            ],
          ],
        ),
        const Divider(height: 20),
        _InfoRow(icon: LucideIcons.bookmark, label: 'Name', value: group.name),
        const Divider(height: 20),
        _InfoRow(icon: LucideIcons.bookOpen, label: 'Course', value: group.course),
        const Divider(height: 20),
        _InfoRow(icon: LucideIcons.mapPin, label: 'Location', value: group.location),
        if (group.description.isNotEmpty) ...[
          const Divider(height: 20),
          _InfoRow(icon: LucideIcons.info, label: 'Description', value: group.description),
        ],
        const Divider(height: 20),
        _InfoRow(icon: LucideIcons.usersRound, label: 'Max Members', value: '${group.maxMembers}'),
        const Divider(height: 20),
        // Group ID row with copy button
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(LucideIcons.hash, size: 16, color: AppColors.textHint),
            const SizedBox(width: 10),
            const SizedBox(
              width: 90,
              child: Text('Group ID',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            ),
            Expanded(
              child: Text(
                group.groupId,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: group.groupId));
                AppSnackBar.success(context, 'Group ID copied!');
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.backgroundBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(LucideIcons.copy,
                    size: 15, color: AppColors.primary),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEditForm(StudyGroupModel group) {
    return Column(
      children: [
        _EditField(label: 'Name', controller: _nameCtrl),
        const SizedBox(height: 12),
        _EditField(label: 'Course', controller: _courseCtrl),
        const SizedBox(height: 12),
        _EditField(label: 'Location', controller: _locationCtrl),
        const SizedBox(height: 12),
        _EditField(
            label: 'Description', controller: _descCtrl, maxLines: 3),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _isSaving ? null : () => _saveChanges(group),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: _isSaving
                ? const SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Text('Save Changes',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textHint),
        const SizedBox(width: 10),
        SizedBox(
          width: 90,
          child: Text(label,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textSecondary)),
        ),
        Expanded(
          child: Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87)),
        ),
      ],
    );
  }
}

class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;
  const _EditField(
      {required this.label, required this.controller, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }
}

class _MemberRow extends ConsumerWidget {
  final String uid;
  final bool isAdmin;
  final bool isCurrentUserAdmin;
  final String groupId;
  const _MemberRow({
    required this.uid,
    required this.isAdmin,
    required this.isCurrentUserAdmin,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(memberUserProvider(uid));
    final name = userAsync.whenOrNull(data: (u) => u?.name) ?? uid;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor:
                isAdmin ? AppColors.primarySurface : AppColors.backgroundBlue,
            child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isAdmin
                        ? AppColors.primary
                        : AppColors.textSecondary)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(name,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          ),
          if (isAdmin)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(8)),
              child: const Text('Admin',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary)),
            ),
          if (isCurrentUserAdmin && !isAdmin)
            IconButton(
              icon: const Icon(LucideIcons.userMinus,
                  size: 16, color: Colors.redAccent),
              onPressed: () async {
                await ref
                    .read(groupsProvider.notifier)
                    .removeMember(groupId, uid);
              },
            ),
        ],
      ),
    );
  }
}

class _DangerButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _DangerButton(
      {required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.red, size: 18),
        label: Text(label,
            style: const TextStyle(
                color: Colors.red, fontWeight: FontWeight.w600)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

class _IconPickerSheet extends StatelessWidget {
  final String currentIconName;
  final ValueChanged<String> onSelect;
  const _IconPickerSheet({
    required this.currentIconName,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final keys = GroupIcons.all.keys.toList();
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const Text(
            'Choose Group Icon',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          const Text(
            'Tap an icon to update the group',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: keys.map((key) {
              final iconData = GroupIcons.resolve(key);
              final iconColor = GroupIcons.resolveColor(key);
              final isSelected = key == currentIconName;
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  onSelect(key);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? iconColor.withValues(alpha: 0.18)
                        : AppColors.backgroundBlue,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? iconColor : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Icon(iconData,
                      size: 24,
                      color: isSelected ? iconColor : AppColors.textSecondary),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
