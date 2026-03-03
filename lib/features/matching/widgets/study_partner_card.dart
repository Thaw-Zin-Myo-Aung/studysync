import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:studysync/core/theme/app_colors.dart';
import 'package:studysync/core/widgets/match_score_badge.dart';
import 'package:studysync/core/widgets/reliability_badge.dart';
import 'why_you_match_section.dart';

class StudyPartnerCard extends StatelessWidget {
  final String userId;
  final String name;
  final String major;
  final int matchScore;
  final double reliabilityScore;
  final String scheduleText;
  final String goalText;
  final String sharedCourse;
  final VoidCallback onCreateGroup;
  final VoidCallback onInviteToGroup;
  final VoidCallback? onViewProfile;

  const StudyPartnerCard({
    super.key,
    required this.userId,
    required this.name,
    required this.major,
    required this.matchScore,
    required this.reliabilityScore,
    required this.scheduleText,
    required this.goalText,
    required this.sharedCourse,
    required this.onCreateGroup,
    required this.onInviteToGroup,
    this.onViewProfile,
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
            // ── Header — tappable for profile popup ──
            GestureDetector(
              onTap: onViewProfile,
              behavior: HitTestBehavior.opaque,
              child: Stack(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.primarySurface,
                        child: Icon(LucideIcons.user, color: AppColors.primary, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 4),
                              Icon(LucideIcons.chevronRight, size: 14, color: AppColors.textHint),
                            ],
                          ),
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
            ),
            const Divider(height: 32),
            WhyYouMatchSection(scheduleText: scheduleText, goalText: goalText, sharedCourse: sharedCourse),
            const SizedBox(height: 16),
            // ── Action buttons ──
            Row(
              children: [
                // Invite to existing group
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: OutlinedButton.icon(
                      onPressed: onInviteToGroup,
                      icon: const Icon(LucideIcons.userPlus, color: AppColors.primary, size: 16),
                      label: const Text('Invite to Group',
                          style: TextStyle(color: AppColors.primary, fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Create Group
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: onCreateGroup,
                      icon: const Icon(LucideIcons.plus, color: Colors.white, size: 16),
                      label: const Text('Create Group',
                          style: TextStyle(color: Colors.white, fontSize: 12)),
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
