import 'package:flutter/material.dart';
import 'package:studysync/core/theme/app_colors.dart';

class CourseTargetItem extends StatelessWidget {
  final String courseName;
  final String targetGrade;
  final Color accentColor;

  const CourseTargetItem({super.key, required this.courseName, required this.targetGrade, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 36,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(courseName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: 'Target:  ', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                TextSpan(text: targetGrade, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

