import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/learning_style_card.dart';
import '../widgets/enrolled_courses_section.dart';
import '../widgets/weekly_schedule_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const ProfileHeaderCard(
                name: 'Thaw Zin',
                major: 'Computer Science',
                year: 'Junior Year',
                reliabilityScore: 100,
                reliabilityLabel: 'High Reliability',
              ),
              const SizedBox(height: 24),
              const LearningStyleCard(style: 'Visual Learner', description: 'Learns best with charts & diagrams'),
              const SizedBox(height: 24),
              const EnrolledCoursesSection(),
              const SizedBox(height: 24),
              const WeeklyScheduleSection(),
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                        label: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0: context.go(RouteConstants.home); break;
            case 1: context.go(RouteConstants.discover); break;
            case 2: context.go(RouteConstants.groups); break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(LucideIcons.house), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.compass), label: 'Discover'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.users), label: 'Groups'),
          BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: 'Profile'),
        ],
      ),
    );
  }
}
