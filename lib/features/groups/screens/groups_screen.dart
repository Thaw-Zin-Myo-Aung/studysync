import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/route_constants.dart';
import '../widgets/groups_header.dart';
import '../widgets/group_card.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> groups = [
      {
        'name': 'Finals Prep - Web', 'subject': 'Web Development',
        'session': 'Tomorrow, 10:00 AM',
        'icon': Icons.code, 'iconBg': const Color(0xFFF3E8FF),
        'iconColor': const Color(0xFF9333EA),
        'initials': ['A', 'B', 'C'], 'extra': 1, 'unread': true,
      },
      {
        'name': 'Calculus Review', 'subject': 'Calculus I',
        'session': 'Wed, 2:00 PM',
        'icon': Icons.calculate_outlined, 'iconBg': const Color(0xFFFFF7ED),
        'iconColor': const Color(0xFFF97316),
        'initials': ['A', 'B', 'C'], 'extra': 0, 'unread': false,
      },
      {
        'name': 'History Study', 'subject': 'World History',
        'session': 'Friday, 1:00 PM',
        'icon': Icons.menu_book_outlined, 'iconBg': const Color(0xFFF0FDF4),
        'iconColor': const Color(0xFF16A34A),
        'initials': ['A', 'B', 'C'], 'extra': 2, 'unread': true,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GroupsHeader(
                groupCount: 3,
                onAdd: () => print('Create group'),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: groups.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => GroupCard(
                    groupName: groups[i]['name'] as String,
                    subject: groups[i]['subject'] as String,
                    nextSession: groups[i]['session'] as String,
                    groupIcon: groups[i]['icon'] as IconData,
                    iconBgColor: groups[i]['iconBg'] as Color,
                    iconColor: groups[i]['iconColor'] as Color,
                    memberInitials: List<String>.from(groups[i]['initials'] as List),
                    extraMemberCount: groups[i]['extra'] as int,
                    hasUnread: groups[i]['unread'] as bool,
                    onTap: () => print('Tapped ${groups[i]['name']}'),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tap a group to chat or view schedule',
                style: TextStyle(fontSize: 12, color: Color(0xFFCBD5E1)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0: context.go(RouteConstants.home); break;
            case 1: context.go(RouteConstants.discover); break;
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

