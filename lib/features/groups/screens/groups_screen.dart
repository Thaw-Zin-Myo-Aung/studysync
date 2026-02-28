import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../models/group_model.dart';
import '../widgets/groups_header.dart';
import '../widgets/group_card.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

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
        automaticallyImplyLeading: false,
        title: Text.rich(
          TextSpan(
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: 'My ', style: TextStyle(color: Colors.black87)),
              TextSpan(text: 'Groups', style: TextStyle(color: AppColors.primary)),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  itemCount: mockGroups.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => GroupCard(group: mockGroups[i]),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tap a group to chat or view schedule',
                style: TextStyle(fontSize: 12, color: AppColors.textDisabled),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: IconButton(
          icon: const Icon(LucideIcons.plus, color: Colors.white, size: 28),
          onPressed: () => debugPrint('Create group'),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0: context.go(RouteConstants.home);     break;
            case 1: context.go(RouteConstants.discover); break;
            case 3: context.go(RouteConstants.profile);  break;
          }
        },
      ),
    );
  }
}
