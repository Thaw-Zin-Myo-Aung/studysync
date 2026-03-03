import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:studysync/features/onboarding/widgets/profile_setup_step2.dart';
import 'package:studysync/features/profile/widgets/edit_section_card.dart';

class EditCoursesCard extends StatelessWidget {
  final List<Map<String, String>> courses;
  final VoidCallback onAddCourse;
  final void Function(int index) onRemoveCourse;
  final void Function(int index, String newGoal) onChangeGoal;

  const EditCoursesCard({
    super.key,
    required this.courses,
    required this.onAddCourse,
    required this.onRemoveCourse,
    required this.onChangeGoal,
  });

  @override
  Widget build(BuildContext context) {
    return EditSectionCard(
      icon: LucideIcons.bookOpen,
      title: 'My Courses',
      children: [
        ProfileSetupStep2(
          courses: courses,
          onAddCourse: onAddCourse,
          onRemoveCourse: onRemoveCourse,
          onChangeGoal: onChangeGoal,
        ),
      ],
    );
  }
}


