import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

class GroupListItem extends StatelessWidget {
  final String groupName;
  final int memberCount;
  final Color avatarColor;
  final VoidCallback onTap;
  final IconData? groupIcon;
  final Color? groupIconColor;

  const GroupListItem({
    super.key,
    required this.groupName,
    required this.memberCount,
    required this.avatarColor,
    required this.onTap,
    this.groupIcon,
    this.groupIconColor,
  });

  @override
  Widget build(BuildContext context) {
    final icon = groupIcon ?? LucideIcons.users;
    final iconColor = groupIconColor ?? AppColors.primary;
    final bgColor = iconColor.withValues(alpha: 0.15);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                groupName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$memberCount mbrs',
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
