import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/groups_provider.dart';

/// Shows a bottom sheet with full user details: courses, learning styles,
/// availability, reliability.
void showUserProfilePopup(BuildContext context, WidgetRef ref, String userId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _UserProfileSheet(userId: userId),
  );
}

class _UserProfileSheet extends ConsumerWidget {
  final String userId;
  const _UserProfileSheet({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(memberUserProvider(userId));

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      expand: false,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: userAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(child: Text('Could not load profile')),
          data: (user) {
            if (user == null) {
              return const Center(child: Text('User not found'));
            }
            return ListView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40, height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Avatar + Name
                Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.primarySurface,
                      child: Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('${user.major} · Year ${user.year}',
                              style: const TextStyle(
                                  fontSize: 13, color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          _ReliabilityChip(score: user.reliabilityScore),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Courses
                _SectionHeader(icon: LucideIcons.bookOpen, label: 'Courses'),
                const SizedBox(height: 8),
                if (user.courses.isEmpty)
                  const _EmptyHint('No courses listed')
                else
                  ...user.courses.map((c) {
                    final name = c['name'] as String? ?? '';
                    final goal = c['academicGoal'] as String? ?? '';
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(name,
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600)),
                          ),
                          if (goal.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primarySurface,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('Goal: $goal',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary)),
                            ),
                        ],
                      ),
                    );
                  }),
                const SizedBox(height: 20),

                // Learning Styles
                _SectionHeader(
                    icon: LucideIcons.lightbulb, label: 'Learning Styles'),
                const SizedBox(height: 8),
                if (user.learningStyles.isEmpty)
                  const _EmptyHint('No learning styles set')
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: user.learningStyles
                        .map((s) => Chip(
                              label: Text(s,
                                  style: const TextStyle(fontSize: 12)),
                              backgroundColor: AppColors.primarySurface,
                              side: BorderSide.none,
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                            ))
                        .toList(),
                  ),
                const SizedBox(height: 20),

                // Availability / Free Times
                _SectionHeader(
                    icon: LucideIcons.calendar, label: 'Availability'),
                const SizedBox(height: 8),
                if (user.availability.isEmpty)
                  const _EmptyHint('No availability set')
                else
                  ...user.availability.entries.map((entry) {
                    final day = entry.key[0].toUpperCase() +
                        entry.key.substring(1);
                    final slots = entry.value;
                    if (slots.isEmpty) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 80,
                            child: Text(day,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary)),
                          ),
                          Expanded(
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: slots
                                  .map((s) => Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.backgroundBlue,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(s,
                                            style: const TextStyle(
                                                fontSize: 11,
                                                color:
                                                    AppColors.textSecondary)),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SectionHeader({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black87)),
      ],
    );
  }
}

class _EmptyHint extends StatelessWidget {
  final String text;
  const _EmptyHint(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(text,
          style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
    );
  }
}

class _ReliabilityChip extends StatelessWidget {
  final int score;
  const _ReliabilityChip({required this.score});

  @override
  Widget build(BuildContext context) {
    final color = score >= 80
        ? AppColors.success
        : score >= 50
            ? AppColors.warning
            : AppColors.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('$score% reliable',
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w700, color: color)),
    );
  }
}


