import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    return Card(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFFEEF2FF),
                    child: Icon(Icons.group_outlined, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text('Your Groups', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Icon(_isExpanded ? Icons.expand_less : Icons.expand_more, color: Colors.grey),
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
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: widget.onCreateGroup,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('+ Create New Group', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

