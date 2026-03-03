import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../../models/notification_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/groups_provider.dart';
import '../../../services/firebase/notification_service.dart';
import '../providers/matching_provider.dart';
import '../widgets/study_partner_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/add_friend_sheet.dart';
import '../widgets/user_profile_popup.dart';
import '../widgets/select_group_sheet.dart';
import '../../groups/widgets/create_group_form.dart';

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
                        onCreateGroup: () => _showCreateGroupSheet(context, ref, m.userId, m.name),
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
        onPressed: () => showAddFriendSheet(context, ref),
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        elevation: 3,
        child: const Icon(LucideIcons.userPlus, color: Colors.white, size: 22),
      ),
    );
  }

  /// Shows a bottom sheet with the create group form.
  /// After the group is created, sends a group_invite to the matched user
  /// and navigates to the group detail screen.
  void _showCreateGroupSheet(
      BuildContext context, WidgetRef ref, String targetUserId, String targetName) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final courseCtrl = TextEditingController();
    final locationCtrl = TextEditingController();
    final descriptionCtrl = TextEditingController();
    int maxMembers = 6;
    bool isLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (sheetCtx, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetCtx).viewInsets.bottom),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(sheetCtx).size.height * 0.85,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    child: Center(
                      child: Container(
                        width: 40, height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Create Group with $targetName',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(LucideIcons.x, size: 20),
                          onPressed: () => Navigator.pop(sheetCtx),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Consumer(
                            builder: (ctx, cRef, _) => CreateGroupForm(
                              formKey: formKey,
                              nameController: nameCtrl,
                              courseController: courseCtrl,
                              locationController: locationCtrl,
                              descriptionController: descriptionCtrl,
                              maxMembers: maxMembers,
                              onMaxMembersChanged: (v) =>
                                  setSheetState(() => maxMembers = v),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton.icon(
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      if (!formKey.currentState!.validate()) return;
                                      setSheetState(() => isLoading = true);
                                      try {
                                        final currentUser = ref.read(authProvider);
                                        if (currentUser == null) return;

                                        // Create the group
                                        await ref.read(groupsProvider.notifier).createGroup(
                                          name: nameCtrl.text.trim(),
                                          course: courseCtrl.text.trim(),
                                          location: locationCtrl.text.trim(),
                                          description: descriptionCtrl.text.trim(),
                                          maxMembers: maxMembers,
                                        );

                                        // Get the newly created group
                                        final groups = ref.read(groupsProvider);
                                        final newGroup = groups.isNotEmpty ? groups.last : null;

                                        if (newGroup != null) {
                                          // Send invite to matched user
                                          final notifRef = FirebaseFirestore.instance
                                              .collection('notifications')
                                              .doc();
                                          await NotificationService().createNotification(
                                            NotificationModel(
                                              notifId: notifRef.id,
                                              userId: targetUserId,
                                              type: 'group_invite',
                                              title: 'Group Invitation',
                                              body: '${currentUser.name} invited you to join ${newGroup.name}',
                                              isRead: false,
                                              createdAt: DateTime.now(),
                                              data: {
                                                'groupId': newGroup.groupId,
                                                'groupName': newGroup.name,
                                                'senderId': currentUser.userId,
                                                'senderName': currentUser.name,
                                              },
                                            ),
                                          );
                                        }

                                        if (sheetCtx.mounted) Navigator.pop(sheetCtx);
                                        if (context.mounted) {
                                          AppSnackBar.success(context, 'Group created! Invitation sent to $targetName');
                                          if (newGroup != null) {
                                            context.go(RouteConstants.groupDetailPath(
                                                newGroup.groupId));
                                          }
                                        }
                                      } catch (e) {
                                        if (sheetCtx.mounted) {
                                          setSheetState(() => isLoading = false);
                                          AppSnackBar.error(sheetCtx, 'Failed: $e');
                                        }
                                      }
                                    },
                              icon: isLoading
                                  ? const SizedBox(
                                      width: 18, height: 18,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: Colors.white))
                                  : const Icon(LucideIcons.users,
                                      size: 18, color: Colors.white),
                              label: Text(
                                isLoading ? 'Creating...' : 'Create Group & Invite',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
