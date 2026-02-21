import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MatchScoreBadge extends StatelessWidget {
  final int score;

  const MatchScoreBadge({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.successSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$score% Match',
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: AppColors.success,
        ),
      ),
    );
  }
}

