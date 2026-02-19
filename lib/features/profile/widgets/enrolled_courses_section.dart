import 'package:flutter/material.dart';
import 'package:studysync/core/widgets/profile_section_header.dart';
import 'course_target_item.dart';

class EnrolledCoursesSection extends StatelessWidget {
  const EnrolledCoursesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = [
      {'name': 'Engineering Math II', 'grade': 'A', 'color': const Color(0xFF93C5FD)},
      {'name': 'Database Systems', 'grade': 'B+', 'color': const Color(0xFFFBBF24)},
      {'name': 'Web Development', 'grade': 'A', 'color': const Color(0xFFC4B5FD)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ProfileSectionHeader(icon: Icons.menu_book_outlined, title: 'Enrolled Courses'),
        const SizedBox(height: 12),
        ...courses.map((c) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: CourseTargetItem(
            courseName: c['name'] as String,
            targetGrade: c['grade'] as String,
            accentColor: c['color'] as Color,
          ),
        )),
      ],
    );
  }
}

