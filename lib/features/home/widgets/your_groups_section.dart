import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/groups/models/group_model.dart';
import 'group_list_item.dart';

class YourGroupsSection extends StatefulWidget {
  final List<GroupModel> groups;
  final VoidCallback onCreateGroup;

  const YourGroupsSection({super.key, required this.groups, required this.onCreateGroup});

  @override
  State<YourGroupsSection> createState() => _YourGroupsSectionState();
}

class _YourGroupsSectionState extends State<YourGroupsSection> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFFEEF2FF),
                  child: Icon(LucideIcons.users, color: AppColors.textMuted, size: 18),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Your Groups',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const Spacer(),
                Icon(
                  _isExpanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                  color: AppColors.textMuted,
                  size: 20,
                ),
              ],
            ),
          ),
          if (_isExpanded) ...[
            const SizedBox(height: 12),
            ...widget.groups.map((g) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GroupListItem(
                groupName: g.name,
                memberCount: g.memberInitials.length + g.extraMemberCount,
                avatarColor: g.iconBgColor,
                onTap: () => context.go('/groups/${g.id}'),
              ),
            )),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.backgroundPage,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: InkWell(
                onTap: widget.onCreateGroup,
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.plus, size: 16, color: AppColors.textMuted),
                    const SizedBox(width: 6),
                    const Text(
                      'Create New Group',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
