import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:studysync/core/widgets/schedule_match_row.dart';
import 'package:studysync/core/widgets/match_reason_row.dart';

class WhyYouMatchSection extends StatelessWidget {
  final String scheduleText;
  final String goalText;
  final String sharedCourse;

  const WhyYouMatchSection({
    super.key,
    required this.scheduleText,
    required this.goalText,
    required this.sharedCourse,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WHY YOU MATCH',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade400, letterSpacing: 1.2),
        ),
        const SizedBox(height: 10),
        ScheduleMatchRow(scheduleText: scheduleText, subtitle: 'Perfect schedule alignment'),
        const SizedBox(height: 10),
        MatchReasonRow(icon: LucideIcons.target, label: goalText),
        const SizedBox(height: 10),
        MatchReasonRow(icon: LucideIcons.bookOpen, label: 'Shared: ', boldText: sharedCourse),
      ],
    );
  }
}

