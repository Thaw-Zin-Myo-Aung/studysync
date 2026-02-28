import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../widgets/user_profile_card.dart';
import '../widgets/upcoming_sessions_section.dart';
import '../widgets/your_groups_section.dart';
import '../widgets/find_partner_banner.dart';
import '../../groups/models/group_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlue,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 2,
        shadowColor: Colors.black12,
        centerTitle: false,
        titleSpacing: 20,
        title: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: 'Study', style: TextStyle(color: Colors.black87)),
              TextSpan(text: 'Sync', style: TextStyle(color: AppColors.primary)),
            ],
          ),
        ),
        actions: [
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundBlue,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(LucideIcons.bell, color: Colors.black87, size: 20),
                    onPressed: () {},
                  ),
                ),
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '19',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          // Blob 1 — large glow centered-right behind profile card
          Positioned(
            top: 30,
            right: -60,
            child: Container(
              width: 260,
              height: 260,
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
          // Blob 2 — medium glow centered-left behind profile card
          Positioned(
            top: 20,
            left: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF60A5FA).withValues(alpha: 0.25),
                    const Color(0xFF60A5FA).withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          // Blob 3 — small warm accent, dead center of card
          Positioned(
            top: 50,
            left: 140,
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
                  const UserProfileCard(
                    fullName: 'Mr. Thaw Zin Myo Aung',
                    reliability: 95,
                    studentId: '6731503088',
                    major: 'Software Engineering',
                  ),
                  const SizedBox(height: 20),
                  UpcomingSessionsSection(onSeeAll: () {}),
                  const SizedBox(height: 20),
                  YourGroupsSection(groups: mockGroups, onCreateGroup: () {}),
                  const SizedBox(height: 20),
                  FindPartnerBanner(
                    courseName: 'Engineering Math II',
                    onFindPartner: () => context.go(RouteConstants.discover),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 1: context.go(RouteConstants.discover); break;
            case 2: context.go(RouteConstants.groups); break;
            case 3: context.go(RouteConstants.profile); break;
          }
        },
      ),
    );
  }
}


