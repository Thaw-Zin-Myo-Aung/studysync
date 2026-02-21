import 'package:flutter/material.dart';
import 'group_icon_badge.dart';
import 'member_avatar_stack.dart';

class GroupCard extends StatelessWidget {
  final String groupName;
  final String subject;
  final String nextSession;
  final IconData groupIcon;
  final Color iconBgColor;
  final Color iconColor;
  final List<String> memberInitials;
  final int extraMemberCount;
  final bool hasUnread;
  final VoidCallback onTap;

  const GroupCard({
    super.key,
    required this.groupName,
    required this.subject,
    required this.nextSession,
    required this.groupIcon,
    required this.iconBgColor,
    required this.iconColor,
    required this.memberInitials,
    this.extraMemberCount = 0,
    this.hasUnread = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        ),
        child: Row(
          children: [
            GroupIconBadge(
              icon: groupIcon,
              backgroundColor: iconBgColor,
              iconColor: iconColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        groupName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      if (hasUnread) ...[
                        const SizedBox(width: 6),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subject,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.access_time_outlined, size: 13, color: Color(0xFF2563EB)),
                      const SizedBox(width: 4),
                      Text(
                        nextSession,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            MemberAvatarStack(
              initials: memberInitials,
              extraCount: extraMemberCount,
            ),
          ],
        ),
      ),
    );
  }
}

