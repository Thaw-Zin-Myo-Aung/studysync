import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:studysync/core/theme/app_colors.dart';
import 'package:studysync/core/widgets/reliability_ring.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String name;
  final String major;
  final String year;
  final double reliabilityScore;
  final String reliabilityLabel;

  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.major,
    required this.year,
    required this.reliabilityScore,
    required this.reliabilityLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.border,
                  child: Icon(LucideIcons.user, size: 40, color: AppColors.textHint),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(LucideIcons.pencil, size: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(LucideIcons.school, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 8),
                Text('$major • $year', style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
              ],
            ),
            const SizedBox(height: 20),
            ReliabilityRing(score: reliabilityScore, label: reliabilityLabel),
          ],
        ),
      ),
    );
  }
}
