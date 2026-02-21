import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/route_constants.dart';
import '../models/group_model.dart';
import '../widgets/groups_header.dart';
import '../widgets/group_card.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GroupsHeader(
                groupCount: mockGroups.length,
                onAdd: () => print('Create group'),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: mockGroups.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => GroupCard(
                    group: mockGroups[i],
                    onTap: () => context.push(
                      RouteConstants.groupDetail.replaceAll(':groupId', mockGroups[i].id),
                    ),
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

