import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

const _teal = Color(0xFF0D9488);

class CourseCard extends StatelessWidget {
  final String courseName;
  final String goal;
  final VoidCallback onRemove;
  final VoidCallback onTapGoal;

  const CourseCard({
    super.key,
    required this.courseName,
    required this.goal,
    required this.onRemove,
    required this.onTapGoal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black.withValues(alpha: 0.05))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Course name
          Expanded(
            child: Text(courseName,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: 10),

          // Goal badge
          GestureDetector(
            onTap: onTapGoal,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: _teal.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(goal,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700, color: _teal)),
                const SizedBox(width: 3),
                const Icon(LucideIcons.chevronDown, size: 12, color: _teal),
              ]),
            ),
          ),
          const SizedBox(width: 8),

          // Remove button
          GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(LucideIcons.x, size: 14, color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

