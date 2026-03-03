import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:studysync/core/theme/app_colors.dart';
import 'package:studysync/core/widgets/profile_section_header.dart';
import 'course_target_item.dart';

// Cycles through accent colours for variety
const _accentColors = [
  Color(0xFF93C5FD), // blue
  Color(0xFFFBBF24), // amber
  Color(0xFFC4B5FD), // purple
  Color(0xFF6EE7B7), // teal
  Color(0xFFFCA5A5), // red
  Color(0xFF86EFAC), // green
];

class EnrolledCoursesSection extends StatelessWidget {
  /// Each map has 'name' (String) and 'goal' (String).
  final List<Map<String, dynamic>> courses;

  const EnrolledCoursesSection({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileSectionHeader(icon: LucideIcons.bookOpen, title: 'Enrolled Courses'),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'No courses added yet. Complete your profile setup to add courses.',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ProfileSectionHeader(icon: LucideIcons.bookOpen, title: 'Enrolled Courses'),
        const SizedBox(height: 12),
        ...List.generate(courses.length, (i) {
          final c = courses[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CourseTargetItem(
              courseName: c['name']?.toString() ?? '—',
              targetGrade: c['goal']?.toString() ?? '—',
              accentColor: _accentColors[i % _accentColors.length],
            ),
          );
        }),
      ],
    );
  }
}
