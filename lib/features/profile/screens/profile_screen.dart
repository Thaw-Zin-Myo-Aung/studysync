import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../../providers/auth_provider.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/learning_style_card.dart';
import '../widgets/enrolled_courses_section.dart';
import '../widgets/weekly_schedule_section.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {

  // Maps the stored learning-style key → display label + description
  static const _styleInfo = {
    'visual':   ('Visual Learner',   'Learns best with diagrams, charts & written notes'),
    'auditory': ('Auditory Learner', 'Learns best by listening and discussing out loud'),
    'hands-on': ('Hands-On Learner', 'Learns best by doing, practising & problem-solving'),
  };

  static String _yearLabel(int y) {
    const ordinals = {1: '1st', 2: '2nd', 3: '3rd', 4: '4th'};
    final ord = ordinals[y] ?? '${y}th';
    return '$ord Year';
  }

  static String _reliabilityLabel(int score) {
    if (score >= 90) return 'High Reliability';
    if (score >= 70) return 'Good Reliability';
    if (score >= 50) return 'Fair Reliability';
    return 'Building Reliability';
  }

  @override
  void initState() {
    super.initState();
    // Re-fetch latest data from Firestore every time the profile screen opens
    Future.microtask(() => ref.read(authProvider.notifier).refreshUser());
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);

    // Show a loading indicator while the initial fetch is in progress
    if (user == null) {
      return const Scaffold(
        backgroundColor: AppColors.backgroundBlue,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final styleKey = user.learningStyles.isNotEmpty
        ? user.learningStyles.first
        : 'visual';
    final (styleLabel, styleDesc) =
        _styleInfo[styleKey] ?? ('Visual Learner', 'Learns best with diagrams & notes');

    return Scaffold(
      backgroundColor: AppColors.backgroundBlue,
      body: Stack(
        children: [
          // Blob 1 — large primary glow, top-right
          Positioned(
            top: -20,
            right: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.28),
                    AppColors.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          // Blob 2 — medium glow, mid-left
          Positioned(
            top: 30,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF60A5FA).withValues(alpha: 0.22),
                    const Color(0xFF60A5FA).withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          // Blob 3 — small accent, top-center
          Positioned(
            top: 60,
            left: 130,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFBAD7FF).withValues(alpha: 0.35),
                    const Color(0xFFBAD7FF).withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          // Main scrollable content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ProfileHeaderCard(
                    name: user.name,
                    major: user.major,
                    year: _yearLabel(user.year),
                    reliabilityScore: user.reliabilityScore.toDouble(),
                    reliabilityLabel: _reliabilityLabel(user.reliabilityScore),
                  ),
                  const SizedBox(height: 24),
                  LearningStyleCard(
                    style: styleLabel,
                    description: styleDesc,
                  ),
                  const SizedBox(height: 24),
                  EnrolledCoursesSection(
                    courses: user.courses,
                  ),
                  const SizedBox(height: 24),
                  WeeklyScheduleSection(
                    availability: user.availability,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: OutlinedButton.icon(
                            onPressed: () => context.go(RouteConstants.settings),
                            icon: const Icon(LucideIcons.settings, color: Colors.black87),
                            label: const Text('Settings', style: TextStyle(color: Colors.black87)),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: AppColors.surface,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: () => context.go(RouteConstants.editProfile),
                            icon: const Icon(LucideIcons.penLine, color: Colors.white),
                            label: const Text('Edit Profile',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0: context.go(RouteConstants.home);     break;
            case 1: context.go(RouteConstants.discover); break;
            case 2: context.go(RouteConstants.groups);   break;
          }
        },
      ),
    );
  }
}
