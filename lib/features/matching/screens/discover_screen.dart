import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/app_colors.dart';
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
        elevation: 0,
        backgroundColor: AppColors.surface,
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Discover', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            Text('Find your perfect study buddy', style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.tune_outlined, color: Colors.grey)),
        ],
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: mockMatches.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            if (index == mockMatches.length) {
              return Column(
                children: [
                  const SizedBox(height: 8),
                  Text("That's all for now!", style: const TextStyle(fontSize: 13, color: Colors.grey)),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0: context.go(RouteConstants.home); break;
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

