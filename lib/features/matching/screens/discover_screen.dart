import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../widgets/study_partner_card.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mockMatches = [
      {'name': 'Jane', 'major': 'Software Eng', 'matchScore': 92, 'reliability': 88.0, 'schedule': 'Both free Thursday 7-9 PM', 'goal': 'Both targeting B+ in Math', 'course': 'Database Systems'},
      {'name': 'Sarah', 'major': 'Computer Science', 'matchScore': 85, 'reliability': 94.0, 'schedule': 'Both free Friday 1-3 PM', 'goal': 'Both preparing for Midterm', 'course': 'Data Structures'},
      {'name': 'James', 'major': 'IT', 'matchScore': 78, 'reliability': 82.0, 'schedule': 'Both free Monday Morning', 'goal': 'Pass/Fail focus', 'course': 'Web Technologies'},
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundBlue,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 2,
        shadowColor: Colors.black12,
        centerTitle: false,
        titleSpacing: 20,
        title: const Text(
          'Discover',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        actions: [
          Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.backgroundBlue,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(LucideIcons.slidersHorizontal, color: Colors.black87, size: 20),
                onPressed: () {},
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
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
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: mockMatches.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                if (index == mockMatches.length) {
                  return Column(
                    children: [
                      const SizedBox(height: 8),
                      const Text("That's all for now!", style: TextStyle(fontSize: 13, color: Colors.grey)),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Adjust Filters', style: TextStyle(color: AppColors.primary)),
                      ),
                    ],
                  );
                }
                final m = mockMatches[index];
                return StudyPartnerCard(
                  name: m['name'] as String,
                  major: m['major'] as String,
                  matchScore: m['matchScore'] as int,
                  reliabilityScore: m['reliability'] as double,
                  scheduleText: m['schedule'] as String,
                  goalText: m['goal'] as String,
                  sharedCourse: m['course'] as String,
                  onPass: () {},
                  onRequest: () {},
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0: context.go(RouteConstants.home);    break;
            case 2: context.go(RouteConstants.groups);  break;
            case 3: context.go(RouteConstants.profile); break;
          }
        },
      ),
    );
  }
}

