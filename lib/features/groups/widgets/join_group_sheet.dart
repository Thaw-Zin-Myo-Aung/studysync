import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../models/notification_model.dart';
import '../../../models/study_group_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/groups_provider.dart';
import '../../../services/firebase/group_service.dart';
import '../../../services/firebase/notification_service.dart';

void showJoinGroupSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _JoinGroupSheet(),
  );
}

class _JoinGroupSheet extends ConsumerStatefulWidget {
  const _JoinGroupSheet();

  @override
  ConsumerState<_JoinGroupSheet> createState() => _JoinGroupSheetState();
}

class _JoinGroupSheetState extends ConsumerState<_JoinGroupSheet> {
  final _searchCtrl = TextEditingController();
  final _groupService = GroupService();

  List<StudyGroupModel> _results = [];
  bool _isSearching = false;
  bool _hasSearched = false;
  String? _joiningId;   // groupId currently being joined

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final q = _searchCtrl.text.trim();
    if (q.isEmpty) return;
    setState(() { _isSearching = true; _hasSearched = true; });
    try {
      final results = await _groupService.searchGroups(q);
      if (mounted) setState(() => _results = results);
    } catch (_) {
      if (mounted) setState(() => _results = []);
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  Future<void> _join(String groupId) async {
    setState(() => _joiningId = groupId);
    try {
      final currentUser = ref.read(authProvider);
      if (currentUser == null) return;

      // Find the group to get admin info
      final group = _results.firstWhere((g) => g.groupId == groupId);

      // Send join_request notification to admin
      final notifRef =
          FirebaseFirestore.instance.collection('notifications').doc();
      await NotificationService().createNotification(NotificationModel(
        notifId: notifRef.id,
        userId: group.adminId,
        type: 'join_request',
        title: 'Join Request',
        body: '${currentUser.name} wants to join ${group.name}',
        isRead: false,
        createdAt: DateTime.now(),
        data: {
          'groupId': group.groupId,
          'groupName': group.name,
          'requesterId': currentUser.userId,
          'requesterName': currentUser.name,
        },
      ));

      if (mounted) {
        Navigator.pop(context);
        AppSnackBar.success(context, 'Join request sent! Waiting for admin approval.');
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(context, 'Failed to send request: $e');
      }
    } finally {
      if (mounted) setState(() => _joiningId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final alreadyJoined = ref
        .watch(groupsProvider)
        .map((g) => g.groupId)
        .toSet();

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Title
            const Text('Join a Study Group',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
            const SizedBox(height: 4),
            const Text('Search by group name or paste a group ID.',
                style: TextStyle(
                    fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 20),

            // Search bar
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _search(),
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Group name or ID…',
                    hintStyle: const TextStyle(
                        fontSize: 14, color: AppColors.textHint),
                    prefixIcon: const Icon(LucideIcons.search,
                        size: 18, color: AppColors.textMuted),
                    filled: true,
                    fillColor: AppColors.primarySurface,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 1.5)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSearching ? null : _search,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: _isSearching
                      ? const SizedBox(
                          width: 18, height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Text('Search',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ]),
            const SizedBox(height: 16),

            // Results
            if (_isSearching)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primary)),
              )
            else if (_hasSearched && _results.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(LucideIcons.searchX,
                        size: 36, color: AppColors.textHint),
                    const SizedBox(height: 10),
                    const Text('No groups found.',
                        style: TextStyle(
                            fontSize: 14, color: AppColors.textMuted)),
                  ]),
                ),
              )
            else if (_results.isNotEmpty)
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight:
                        MediaQuery.of(context).size.height * 0.35),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _results.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final g = _results[i];
                    final joined = alreadyJoined.contains(g.groupId);
                    final joiningThis = _joiningId == g.groupId;
                    return _GroupResultTile(
                      group: g,
                      alreadyJoined: joined,
                      isJoining: joiningThis,
                      onJoin: joined ? null : () => _join(g.groupId),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Single search result tile ─────────────────────────────────────────────────

class _GroupResultTile extends StatelessWidget {
  final StudyGroupModel group;
  final bool alreadyJoined;
  final bool isJoining;
  final VoidCallback? onJoin;

  const _GroupResultTile({
    required this.group,
    required this.alreadyJoined,
    required this.isJoining,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        // Icon
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(LucideIcons.users,
              size: 22, color: AppColors.primary),
        ),
        const SizedBox(width: 12),

        // Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(group.name,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 3),
              Text(group.course,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textMuted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 3),
              Row(children: [
                const Icon(LucideIcons.users,
                    size: 11, color: AppColors.textHint),
                const SizedBox(width: 4),
                Text('${group.memberIds.length}/${group.maxMembers}',
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textHint)),
                const SizedBox(width: 10),
                const Icon(LucideIcons.mapPin,
                    size: 11, color: AppColors.textHint),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(group.location,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textHint),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
              ]),
            ],
          ),
        ),
        const SizedBox(width: 10),

        // Join button
        alreadyJoined
            ? Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.successSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Joined',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success)),
              )
            : SizedBox(
                height: 34,
                child: ElevatedButton(
                  onPressed: isJoining ? null : onJoin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: isJoining
                      ? const SizedBox(
                          width: 14, height: 14,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Text('Request',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                ),
              ),
      ]),
    );
  }
}

