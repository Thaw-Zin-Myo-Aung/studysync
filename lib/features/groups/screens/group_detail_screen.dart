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
import '../widgets/discussion_tab.dart';
import '../widgets/sessions_tab.dart';
import '../widgets/members_tab.dart';

class GroupDetailScreen extends ConsumerStatefulWidget {
  final String groupId;

  const GroupDetailScreen({super.key, required this.groupId});

  @override
  ConsumerState<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends ConsumerState<GroupDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groups = ref.watch(groupsProvider);
    final StudyGroupModel? group = groups
        .cast<StudyGroupModel?>()
        .firstWhere((g) => g?.groupId == widget.groupId, orElse: () => null);

    if (group == null) {
      return const Scaffold(
        backgroundColor: AppColors.backgroundBlue,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundBlue,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.black87),
          onPressed: () => context.go(RouteConstants.groups),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              group.name,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              group.course,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(LucideIcons.settings, color: Colors.grey.shade400),
            onPressed: () => debugPrint('Settings'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          indicatorWeight: 2.5,
          tabs: const [
            Tab(text: 'Discussion'),
            Tab(text: 'Sessions'),
            Tab(text: 'Members'),
          ],
        ),
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
          // Main content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TabBarView(
              controller: _tabController,
              children: [
                DiscussionTab(groupId: group.groupId),
                SessionsTab(group: group),
                MembersTab(group: group),
              ],
            ),
          ),

        ],
      ),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton(
              onPressed: () => _showCreateSessionDialog(context, ref, group),
              backgroundColor: AppColors.primary,
              shape: const CircleBorder(),
              elevation: 3,
              child: const Icon(LucideIcons.calendarPlus, color: Colors.white, size: 22),
            )
          : _tabController.index == 2
              ? FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: AppColors.primary,
                  shape: const CircleBorder(),
                  elevation: 3,
                  child: const Icon(LucideIcons.userPlus, color: Colors.white, size: 22),
                )
              : null,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0: context.go(RouteConstants.home);     break;
            case 1: context.go(RouteConstants.discover); break;
            case 2: context.go(RouteConstants.groups);   break;
            case 3: context.go(RouteConstants.profile);  break;
          }
        },
      ),
    );
  }

  void _showCreateSessionDialog(
      BuildContext context, WidgetRef ref, StudyGroupModel group) {
    final dateCtrl = TextEditingController();
    final timeCtrl = TextEditingController();
    final locationCtrl = TextEditingController(text: group.location);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const Text('Schedule Session',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: dateCtrl,
                decoration: InputDecoration(
                  hintText: 'Date (e.g. Mar 10, 2026)',
                  prefixIcon: const Icon(LucideIcons.calendar, size: 18),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: timeCtrl,
                decoration: InputDecoration(
                  hintText: 'Time (e.g. 2:00 PM - 4:00 PM)',
                  prefixIcon: const Icon(LucideIcons.clock, size: 18),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locationCtrl,
                decoration: InputDecoration(
                  hintText: 'Location',
                  prefixIcon: const Icon(LucideIcons.mapPin, size: 18),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    if (dateCtrl.text.trim().isEmpty ||
                        timeCtrl.text.trim().isEmpty) {
                      return;
                    }
                    Navigator.pop(context);
                    await createGroupSession(
                      ref,
                      groupId:  group.groupId,
                      date:     dateCtrl.text.trim(),
                      time:     timeCtrl.text.trim(),
                      location: locationCtrl.text.trim(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Schedule',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

