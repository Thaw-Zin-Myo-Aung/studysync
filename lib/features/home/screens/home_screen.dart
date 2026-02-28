import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/user_profile_card.dart';
import '../widgets/upcoming_sessions_section.dart';
import '../widgets/your_groups_section.dart';
import '../widgets/find_partner_banner.dart';
import '../../groups/models/group_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

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
          // Blob 1 — large primary glow, top-right behind profile card
          Positioned(
            top: -20,
            right: -30,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.30),
                    AppColors.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          // Blob 2 — mid-left softer glow
          Positioned(
            top: 40,
            left: -50,
            child: Container(
              width: 180,
              height: 180,
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
          // Blob 3 — small accent top-center
          Positioned(
            top: 10,
            left: 120,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFA5C8FE).withValues(alpha: 0.25),
                    const Color(0xFFA5C8FE).withValues(alpha: 0.0),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _currentIndex = index);
          switch (index) {
            case 1: context.go(RouteConstants.discover); break;
            case 2: context.go(RouteConstants.groups); break;
            case 3: context.go(RouteConstants.profile); break;
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
