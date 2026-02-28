import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/app_colors.dart';

class ScheduleMatchRow extends StatelessWidget {
  final String scheduleText;
  final String subtitle;

  const ScheduleMatchRow({super.key, required this.scheduleText, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.calendar, size: 18, color: AppColors.success),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(scheduleText, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.success)),
                Text(subtitle, style: TextStyle(fontSize: 11, color: AppColors.success.withValues(alpha: 0.7))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

