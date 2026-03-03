import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../models/notification_model.dart';
import '../../../models/user_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/groups_provider.dart';
import '../../../services/firebase/notification_service.dart';
import '../../groups/widgets/create_group_form.dart';
import 'select_group_sheet.dart';

void showAddFriendSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _AddFriendSheet(ref: ref),
  );
}

class _AddFriendSheet extends ConsumerStatefulWidget {
  final WidgetRef ref;
  const _AddFriendSheet({required this.ref});

  @override
  ConsumerState<_AddFriendSheet> createState() => _AddFriendSheetState();
}

class _AddFriendSheetState extends ConsumerState<_AddFriendSheet> {
  final TextEditingController _controller = TextEditingController();
  bool _isSearching = false;
  String? _errorMessage;
  UserModel? _foundUser;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _searchUser() async {
    final id = _controller.text.trim();
    if (id.isEmpty) {
      setState(() => _errorMessage = 'Please enter a student ID.');
      return;
    }
    setState(() { _isSearching = true; _errorMessage = null; _foundUser = null; });

    try {
      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('studentId', isEqualTo: id)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        setState(() {
          _isSearching = false;
          _errorMessage = 'No student found with ID "$id".';
        });
        return;
      }

      final data = query.docs.first.data();
      // Make sure they're not searching themselves
      final me = ref.read(authProvider);
      if (data['userId'] == me?.userId) {
        setState(() {
          _isSearching = false;
          _errorMessage = 'That\'s your own student ID!';
        });
        return;
      }

      setState(() {
        _isSearching = false;
        _foundUser = UserModel.fromJson(data);
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
        _errorMessage = 'Search failed. Please try again.';
      });
    }
  }

  void _inviteToGroup(UserModel user) {
    Navigator.pop(context);
    showSelectGroupSheet(
      context,
      widget.ref,
      targetUserId: user.userId,
      targetUserName: user.name,
    );
  }

  void _createGroup(UserModel user) {
    Navigator.pop(context);
    _showCreateGroupSheet(context, widget.ref, user.userId, user.name);
  }

  void _showCreateGroupSheet(
      BuildContext ctx, WidgetRef ref, String targetUserId, String targetName) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final courseCtrl = TextEditingController();
    final locationCtrl = TextEditingController();
    final descriptionCtrl = TextEditingController();
    int maxMembers = 6;
    bool isLoading = false;

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (sheetCtx, setSheetState) => Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(sheetCtx).viewInsets.bottom),
          child: Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(sheetCtx).size.height * 0.85),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 8),
                  child: Center(
                    child: Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2)),
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
                          builder: (c, r, _) => CreateGroupForm(
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

                                      await ref.read(groupsProvider.notifier).createGroup(
                                            name: nameCtrl.text.trim(),
                                            course: courseCtrl.text.trim(),
                                            location: locationCtrl.text.trim(),
                                            description: descriptionCtrl.text.trim(),
                                            maxMembers: maxMembers,
                                          );

                                      final groups = ref.read(groupsProvider);
                                      final newGroup = groups.isNotEmpty ? groups.last : null;

                                      if (newGroup != null) {
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
                                      if (ctx.mounted) {
                                        AppSnackBar.success(ctx,
                                            'Group created! Invitation sent to $targetName');
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
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
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),

            // Title row
            Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: const BoxDecoration(
                      color: AppColors.primarySurface,
                      shape: BoxShape.circle),
                  child: const Icon(LucideIcons.userPlus,
                      color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Find Study Partner',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    Text('Search by MFU student ID',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(LucideIcons.x,
                      size: 20, color: Colors.black45),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Search input ──────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    onChanged: (_) =>
                        setState(() { _errorMessage = null; _foundUser = null; }),
                    onSubmitted: (_) => _searchUser(),
                    decoration: InputDecoration(
                      hintText: 'e.g. 6731503088',
                      hintStyle: const TextStyle(
                          fontSize: 13, color: AppColors.textHint),
                      prefixIcon: const Icon(LucideIcons.hash,
                          size: 18, color: AppColors.textSecondary),
                      filled: true,
                      fillColor: AppColors.backgroundBlue,
                      errorText: _errorMessage,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: AppColors.primary, width: 1.5)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Colors.redAccent)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isSearching ? null : _searchUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: _isSearching
                        ? const SizedBox(
                            width: 18, height: 18,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Icon(LucideIcons.search,
                            color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),

            // ── Found user card ───────────────────────────────────
            if (_foundUser != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.backgroundBlue,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.primarySurface,
                          child: Text(
                            _foundUser!.name.isNotEmpty
                                ? _foundUser!.name[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_foundUser!.name,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87)),
                              const SizedBox(height: 2),
                              Text(
                                '${_foundUser!.major} · Year ${_foundUser!.year}',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary),
                              ),
                              Text(
                                _foundUser!.studentId,
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textHint),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.successLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('Found',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.success)),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _inviteToGroup(_foundUser!),
                            icon: const Icon(LucideIcons.userPlus, size: 16),
                            label: const Text('Invite to Group',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(
                                  color: AppColors.primary, width: 1.5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _createGroup(_foundUser!),
                            icon: const Icon(LucideIcons.usersRound,
                                size: 16, color: Colors.white),
                            label: const Text('Create Group',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

