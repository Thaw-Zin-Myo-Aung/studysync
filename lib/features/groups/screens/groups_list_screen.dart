import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../../models/study_group_model.dart';
import '../../../providers/groups_provider.dart';
import '../../../providers/sessions_provider.dart';
import '../models/group_model.dart';
import '../widgets/group_card.dart';
import '../widgets/add_group_sheet.dart';

class GroupsListScreen extends ConsumerWidget {
  const GroupsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestoreGroups = ref.watch(groupsProvider);

    return Scaffold(
      // ...existing scaffold code unchanged...
      backgroundColor: AppColors.backgroundBlue,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 2,
        shadowColor: Colors.black12,
        centerTitle: false,
        titleSpacing: 20,
        automaticallyImplyLeading: false,
        title: const Text.rich(
          TextSpan(
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: 'My ', style: TextStyle(color: Colors.black87)),
              TextSpan(text: 'Groups', style: TextStyle(color: AppColors.primary)),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: -20, right: -40,
            child: Container(
              width: 220, height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.primary.withValues(alpha: 0.28),
                  AppColors.primary.withValues(alpha: 0.0),
                ]),
              ),
            ),
          ),
          Positioned(
            top: 30, left: -50,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFF60A5FA).withValues(alpha: 0.22),
                  const Color(0xFF60A5FA).withValues(alpha: 0.0),
                ]),
              ),
            ),
          ),
          Positioned(
            top: 60, left: 130,
            child: Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFFBAD7FF).withValues(alpha: 0.35),
                  const Color(0xFFBAD7FF).withValues(alpha: 0.0),
                ]),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: firestoreGroups.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 64, height: 64,
                                  decoration: BoxDecoration(
                                    color: AppColors.primarySurface,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: const Icon(LucideIcons.users,
                                      size: 32, color: AppColors.primary),
                                ),
                                const SizedBox(height: 16),
                                const Text("You haven't joined any group yet",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary)),
                                const SizedBox(height: 6),
                                const Text(
                                    'Tap + to create or join a study group.',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textMuted)),
                              ],
                            ),
                          )
                        : ListView.separated(
                            itemCount: firestoreGroups.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (_, i) => _GroupCardWithSession(
                              firestoreGroup: firestoreGroups[i],
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tap a group to chat or view schedule',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textDisabled),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        width: 56, height: 56,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(LucideIcons.plus, color: Colors.white, size: 28),
          onPressed: () => showAddGroupSheet(context),
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

/// Watches the sessions for a single group and passes the next upcoming
/// session label (title + date) down to [GroupCard].
class _GroupCardWithSession extends ConsumerWidget {
  final StudyGroupModel firestoreGroup;
  const _GroupCardWithSession({required this.firestoreGroup});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync =
        ref.watch(groupSessionsProvider(firestoreGroup.groupId));

    final nextSession = sessionsAsync.whenOrNull(
      data: (sessions) {
        final upcoming = sessions
            .where((s) => s.status == 'scheduled')
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));
        if (upcoming.isEmpty) return null;
        final s = upcoming.first;
        return s.title.isNotEmpty
            ? '${s.title} · ${s.date}'
            : s.date;
      },
    );

    final group = GroupModel(
      id: firestoreGroup.groupId,
      name: firestoreGroup.name,
      subject: firestoreGroup.course,
      nextSession: nextSession ?? 'No session scheduled',
      icon: LucideIcons.users,
      iconBgColor: AppColors.primarySurface,
      iconColor: AppColors.primary,
      memberInitials: [],
      extraMemberCount: firestoreGroup.memberIds.length > 3
          ? firestoreGroup.memberIds.length - 3
          : 0,
      hasUnread: false,
      upcomingDate: '',
      upcomingTimeRange: '',
      upcomingLocation: firestoreGroup.location,
      upcomingLocationDetail: '',
      upcomingAttendees: 0,
      upcomingTotal: firestoreGroup.memberIds.length,
      pastSessions: [],
      members: [],
    );

    return GroupCard(group: group);
  }
}

