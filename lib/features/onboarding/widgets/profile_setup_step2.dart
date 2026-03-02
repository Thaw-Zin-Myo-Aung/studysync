import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import 'course_card.dart';

const _teal = Color(0xFF0D9488);

class ProfileSetupStep2 extends StatelessWidget {
  final List<Map<String, String>> courses;
  final VoidCallback onAddCourse;
  final void Function(int index) onRemoveCourse;
  final void Function(int index, String newGoal) onChangeGoal;

  const ProfileSetupStep2({
    super.key,
    required this.courses,
    required this.onAddCourse,
    required this.onRemoveCourse,
    required this.onChangeGoal,
  });

  static const List<String> _grades = ['A', 'B+', 'B', 'C+', 'C', 'D+', 'D', 'F'];

  void _showGoalPicker(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
                color: AppColors.border, borderRadius: BorderRadius.circular(99)),
          ),
          const SizedBox(height: 16),
          const Text('Set Your Goal',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10, runSpacing: 10,
            children: _grades.map((g) {
              final isSelected = courses[index]['goal'] == g;
              return GestureDetector(
                onTap: () { onChangeGoal(index, g); Navigator.pop(context); },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? _teal : AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: isSelected ? _teal : AppColors.border)),
                  child: Text(g,
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : AppColors.textSecondary)),
                ),
              );
            }).toList(),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Helper text
        const Text(
          "Add all courses you're currently enrolled in. This powers your match results.",
          style: TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.5),
        ),
        const SizedBox(height: 20),

        // Course list
        ...List.generate(courses.length, (i) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: CourseCard(
            courseName: courses[i]['name']!,
            goal: courses[i]['goal']!,
            onRemove: () => onRemoveCourse(i),
            onTapGoal: () => _showGoalPicker(context, i),
          ),
        )),
        const SizedBox(height: 4),

        // Dashed 'Add a Course' button
        GestureDetector(
          onTap: onAddCourse,
          child: Container(
            width: double.infinity, height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.5), width: 1.5),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(LucideIcons.plus, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              const Text('Add a Course',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                      color: AppColors.primary)),
            ]),
          ),
        ),
        const SizedBox(height: 20),

        // Tip card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('💡', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Tip: Set your academic goal per course. The app uses this to find partners with the same targets.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.5),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

