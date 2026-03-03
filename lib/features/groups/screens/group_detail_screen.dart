import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/group_icons.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../../models/study_group_model.dart';
import '../../../providers/groups_provider.dart';
import '../../../providers/sessions_provider.dart';
import '../widgets/discussion_tab.dart';
import '../widgets/invite_member_sheet.dart';
import '../widgets/sessions_tab.dart';
import '../widgets/members_tab.dart';
import '../../../providers/auth_provider.dart';

class GroupDetailScreen extends ConsumerStatefulWidget {
  final String groupId;
  final int initialTab;

  const GroupDetailScreen({
    super.key,
    required this.groupId,
    this.initialTab = 0,
  });

  @override
  ConsumerState<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends ConsumerState<GroupDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTab.clamp(0, 2),
    );
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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: GroupIcons.resolveColor(group.iconName).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                GroupIcons.resolve(group.iconName),
                size: 17,
                color: GroupIcons.resolveColor(group.iconName),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  group.course,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(LucideIcons.settings, color: Colors.grey.shade400),
            onPressed: () => context.push('/groups/${group.groupId}/settings'),
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
      floatingActionButton: _tabController.index == 1 &&
              ref.watch(authProvider)?.userId == group.adminId
          ? FloatingActionButton(
              onPressed: () => _showCreateSessionDialog(context, ref, group),
              backgroundColor: AppColors.primary,
              shape: const CircleBorder(),
              elevation: 3,
              child: const Icon(LucideIcons.calendarPlus, color: Colors.white, size: 22),
            )
          : _tabController.index == 2 &&
                  ref.watch(authProvider)?.userId == group.adminId
              ? FloatingActionButton(
                  onPressed: () => showInviteMemberSheet(context, ref, group),
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
    final titleCtrl    = TextEditingController();
    final locationCtrl = TextEditingController(text: group.location);
    DateTime? pickedDate;
    TimeOfDay? startTime;
    TimeOfDay? endTime;

    final dateCtrl      = TextEditingController();
    final startTimeCtrl = TextEditingController();
    final endTimeCtrl   = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (sheetCtx, setSheetState) {
          final bool isValid =
              titleCtrl.text.trim().isNotEmpty &&
              pickedDate != null && startTime != null && endTime != null;

          Future<void> pickDate() async {
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: sheetCtx,
              initialDate: pickedDate ?? now,
              firstDate: now,
              lastDate: now.add(const Duration(days: 365)),
            );
            if (picked != null) {
              setSheetState(() {
                pickedDate = picked;
                dateCtrl.text = DateFormat('EEE, MMM d yyyy').format(picked);
              });
            }
          }

          Future<void> pickStartTime() async {
            final picked = await showTimePicker(
              context: sheetCtx,
              initialTime: startTime ?? const TimeOfDay(hour: 14, minute: 0),
            );
            if (picked != null) {
              setSheetState(() {
                startTime = picked;
                startTimeCtrl.text = picked.format(sheetCtx);
              });
            }
          }

          Future<void> pickEndTime() async {
            final picked = await showTimePicker(
              context: sheetCtx,
              initialTime: endTime ?? const TimeOfDay(hour: 16, minute: 0),
            );
            if (picked != null) {
              setSheetState(() {
                endTime = picked;
                endTimeCtrl.text = picked.format(sheetCtx);
              });
            }
          }

          String formatTimeOfDay(TimeOfDay t) {
            final now = DateTime.now();
            final dt = DateTime(now.year, now.month, now.day, t.hour, t.minute);
            return DateFormat('h:mm a').format(dt);
          }

          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetCtx).viewInsets.bottom),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
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
                  // Title field
                  TextField(
                    controller: titleCtrl,
                    onChanged: (_) => setSheetState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Session title (e.g. Midterm Review)',
                      prefixIcon:
                          const Icon(LucideIcons.bookOpen, size: 18),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Date picker field
                  TextField(
                    controller: dateCtrl,
                    readOnly: true,
                    onTap: pickDate,
                    decoration: InputDecoration(
                      hintText: 'Select date',
                      prefixIcon:
                          const Icon(LucideIcons.calendar, size: 18),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Time range pickers
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: startTimeCtrl,
                          readOnly: true,
                          onTap: pickStartTime,
                          decoration: InputDecoration(
                            hintText: 'Start time',
                            prefixIcon:
                                const Icon(LucideIcons.clock, size: 18),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: endTimeCtrl,
                          readOnly: true,
                          onTap: pickEndTime,
                          decoration: InputDecoration(
                            hintText: 'End time',
                            prefixIcon:
                                const Icon(LucideIcons.clock, size: 18),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: locationCtrl,
                    decoration: InputDecoration(
                      hintText: 'Location',
                      prefixIcon:
                          const Icon(LucideIcons.mapPin, size: 18),
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
                      onPressed: isValid
                          ? () async {
                              Navigator.pop(sheetCtx);
                              final dateStr = dateCtrl.text.trim();
                              final timeStr =
                                  '${formatTimeOfDay(startTime!)} - ${formatTimeOfDay(endTime!)}';
                              await createGroupSession(
                                ref,
                                groupId:  group.groupId,
                                title:    titleCtrl.text.trim(),
                                date:     dateStr,
                                time:     timeStr,
                                location: locationCtrl.text.trim(),
                              );
                              if (context.mounted) {
                                AppSnackBar.success(context, 'Session scheduled!');
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isValid
                            ? AppColors.primary
                            : Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Schedule',
                          style: TextStyle(
                              color: isValid
                                  ? Colors.white
                                  : Colors.grey.shade500,
                              fontWeight: FontWeight.w600)),
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

