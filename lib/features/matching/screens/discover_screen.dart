import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../../models/notification_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../services/firebase/notification_service.dart';
import '../providers/matching_provider.dart';
import '../widgets/study_partner_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/add_friend_sheet.dart';
import '../widgets/user_profile_popup.dart';
import '../widgets/select_group_sheet.dart';

class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesAsync = ref.watch(matchingProvider);

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
              decoration: const BoxDecoration(
                color: AppColors.backgroundBlue,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(LucideIcons.slidersHorizontal, color: Colors.black87, size: 20),
                onPressed: () => showFilterBottomSheet(context, ref),
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
            child: matchesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Could not load matches'),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => ref.read(matchingProvider.notifier).refresh(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (matches) {
                if (matches.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.search, size: 48, color: AppColors.textHint),
                        const SizedBox(height: 12),
                        const Text('No matches found yet',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        const Text('Complete your profile to find study partners!',
                            style: TextStyle(fontSize: 13, color: AppColors.textHint)),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => ref.read(matchingProvider.notifier).refresh(),
                          child: const Text('Refresh'),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => ref.read(matchingProvider.notifier).refresh(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: matches.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      if (index == matches.length) {
                        return Column(
                          children: [
                            const SizedBox(height: 8),
                            const Text("That's all for now!", style: TextStyle(fontSize: 13, color: Colors.grey)),
                            TextButton(
                              onPressed: () => showFilterBottomSheet(context, ref),
                              child: const Text('Adjust Filters', style: TextStyle(color: AppColors.primary)),
                            ),
                          ],
                        );
                      }
                      final m = matches[index];
                      return StudyPartnerCard(
                        userId: m.userId,
                        name: m.name,
                        major: m.major,
                        matchScore: m.matchScore,
                        reliabilityScore: m.reliabilityScore.toDouble(),
                        scheduleText: m.scheduleOverlap,
                        goalText: m.goalSimilarity,
                        sharedCourse: m.courseOverlap,
                        onViewProfile: () => showUserProfilePopup(context, ref, m.userId),
                        onPass: () {
                          // Dismiss locally — remove from list by refreshing
                          // In a real app you'd track dismissed matches
                        },
                        onCreateGroup: () => _sendGroupCreateInvite(context, ref, m.userId, m.name),
                        onInviteToGroup: () => showSelectGroupSheet(
                          context, ref,
                          targetUserId: m.userId,
                          targetUserName: m.name,
                        ),
                      );
                    },
                  ),
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
            case 0:
              context.go(RouteConstants.home);
              break;
            case 2:
              context.go(RouteConstants.groups);
              break;
            case 3:
              context.go(RouteConstants.profile);
              break;
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddFriendSheet(context),
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        elevation: 3,
        child: const Icon(LucideIcons.userPlus, color: Colors.white, size: 22),
      ),
    );
  }

  /// Sends a "group_create_invite" notification.
  /// The group is only created when the recipient accepts.
  void _sendGroupCreateInvite(
      BuildContext context, WidgetRef ref, String targetUserId, String targetName) async {
    final currentUser = ref.read(authProvider);
    if (currentUser == null) return;

    try {
      final notifRef =
          FirebaseFirestore.instance.collection('notifications').doc();
      await NotificationService().createNotification(NotificationModel(
        notifId: notifRef.id,
        userId: targetUserId,
        type: 'group_create_invite',
        title: 'Study Group Invitation',
        body:
            '${currentUser.name} wants to create a study group with you',
        isRead: false,
        createdAt: DateTime.now(),
        data: {
          'senderId': currentUser.userId,
          'senderName': currentUser.name,
        },
      ));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Group invite sent to $targetName!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send invite: $e')),
        );
      }
    }
  }
}
