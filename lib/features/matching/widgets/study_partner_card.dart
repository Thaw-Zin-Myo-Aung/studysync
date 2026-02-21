import 'package:flutter/material.dart';
import 'package:studysync/core/theme/app_colors.dart';
import 'package:studysync/core/widgets/match_score_badge.dart';
import 'package:studysync/core/widgets/reliability_badge.dart';
import 'why_you_match_section.dart';

class StudyPartnerCard extends StatelessWidget {
  final String name;
  final String major;
  final int matchScore;
  final double reliabilityScore;
  final String scheduleText;
  final String goalText;
  final String sharedCourse;
  final VoidCallback onPass;
  final VoidCallback onRequest;

  const StudyPartnerCard({
    super.key,
    required this.name,
    required this.major,
    required this.matchScore,
    required this.reliabilityScore,
    required this.scheduleText,
    required this.goalText,
    required this.sharedCourse,
    required this.onPass,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.primarySurface,
                      child: Icon(Icons.person, color: AppColors.primary, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(major, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                        const SizedBox(height: 8),
                        ReliabilityBadge(score: reliabilityScore),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: MatchScoreBadge(score: matchScore),
                ),
              ],
            ),
            const Divider(height: 32),
            WhyYouMatchSection(scheduleText: scheduleText, goalText: goalText, sharedCourse: sharedCourse),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: OutlinedButton.icon(
                      onPressed: onPass,
                      icon: Icon(Icons.close, color: Colors.grey.shade600, size: 18),
                      label: Text('Pass', style: TextStyle(color: Colors.grey.shade600)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: onRequest,
                      icon: const Icon(Icons.check, color: Colors.white, size: 18),
                      label: const Text('Request', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

