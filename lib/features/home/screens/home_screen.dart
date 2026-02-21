import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/home_header_card.dart';
import '../widgets/upcoming_session_card.dart';
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              HomeHeaderCard(userName: 'Thaw Zin', reliabilityScore: 95, onNotificationTap: () {}),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Upcoming Session', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                  TextButton(onPressed: () {}, child: const Text('See all', style: TextStyle(color: AppColors.primary, fontSize: 13))),
                ],
              ),
              const SizedBox(height: 12),
              const UpcomingSessionCard(
                groupName: 'Math Study Group',
                timeUntil: 'In 2 hours',
                location: 'Library 3F, Room 302',
                timeRange: '14:00 - 16:00 PM',
                attendeeCount: 3,
                canCheckIn: false,
              ),
              const SizedBox(height: 20),
              YourGroupsSection(groups: mockGroups, onCreateGroup: () {}),
              const SizedBox(height: 20),
              FindPartnerBanner(courseName: 'Engineering Math II', onFindPartner: () {}),
              const SizedBox(height: 20),
            ],
          ),
        ),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'Discover'),
          BottomNavigationBarItem(icon: Icon(Icons.group_outlined), label: 'Groups'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined), label: 'Profile'),
        ],
      ),
    );
  }
}

