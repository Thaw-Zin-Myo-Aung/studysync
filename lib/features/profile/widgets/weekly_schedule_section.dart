import 'package:flutter/material.dart';
import 'package:studysync/core/theme/app_colors.dart';
import 'package:studysync/core/widgets/profile_section_header.dart';

class WeeklyScheduleSection extends StatelessWidget {
  const WeeklyScheduleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final schedule = [
      [false, true, false, true],
      [false, false, false, false],
      [true, false, true, false],
      [false, true, true, false],
      [false, true, false, false],
    ];
    final days = ['M', 'T', 'W', 'T', 'F'];

    return Card(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const ProfileSectionHeader(icon: Icons.calendar_month_outlined, title: 'My Schedule'),
            const SizedBox(height: 16),
            Row(
              children: List.generate(days.length, (i) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: i == 0 ? 0 : 2, right: i == days.length - 1 ? 0 : 2),
                    child: Column(
                      children: [
                        Text(days[i], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
                        const SizedBox(height: 8),
                        ...schedule[i].map((busy) => Container(
                          height: 20,
                          margin: const EdgeInsets.only(bottom: 6),
                          decoration: BoxDecoration(
                            color: busy ? AppColors.scheduleBusyBg : AppColors.scheduleFreeBg,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        )),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _dot(AppColors.scheduleLegFree),
                Text(' Free', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(width: 16),
                _dot(AppColors.scheduleBusyBg),
                Text(' Busy', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

