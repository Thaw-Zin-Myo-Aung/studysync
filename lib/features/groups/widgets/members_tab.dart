import 'dart:math' show pi;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/study_group_model.dart';
import '../../../models/user_model.dart';
import '../../../providers/groups_provider.dart';
import '../../matching/widgets/user_profile_popup.dart';

class MembersTab extends ConsumerWidget {
  final StudyGroupModel group;
  const MembersTab({super.key, required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    return ListView(
      padding: const EdgeInsets.only(top: 16, bottom: 100),
      children: [
        // Member count header
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              const Text(
                'Members',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 1.1),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${group.memberIds.length}/${group.maxMembers}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        ...group.memberIds.map((memberId) {
          final isCurrentUser = memberId == currentUid;
          final isAdmin = memberId == group.adminId;
          final isCurrentUserAdmin = currentUid == group.adminId;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _MemberCard(
              memberId: memberId,
              isCurrentUser: isCurrentUser,
              isAdmin: isAdmin,
              isCurrentUserAdmin: isCurrentUserAdmin,
              group: group,
            ),
          );
        }),
      ],
    );
  }
}

class _MemberCard extends ConsumerWidget {
  final String memberId;
  final bool isCurrentUser;
  final bool isAdmin;
  final bool isCurrentUserAdmin;
  final StudyGroupModel group;
  const _MemberCard({
    required this.memberId,
    required this.isCurrentUser,
    required this.isAdmin,
    required this.isCurrentUserAdmin,
    required this.group,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(memberUserProvider(memberId));

    return userAsync.when(
      loading: () => _buildCard(context, ref, name: 'Loading...', major: '', reliability: 0),
      error: (_, __) => _buildCard(context, ref, name: memberId, major: 'Could not load', reliability: 0),
      data: (user) => _buildCard(
        context,
        ref,
        name: user?.name ?? memberId,
        major: user != null ? '${user.major} · Year ${user.year}' : '',
        reliability: user?.reliabilityScore ?? 0,
        user: user,
      ),
    );
  }

  Widget _buildCard(BuildContext context, WidgetRef ref, {
    required String name,
    required String major,
    required int reliability,
    UserModel? user,
  }) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final reliabilityColor = reliability >= 80
        ? AppColors.success
        : reliability >= 50
            ? AppColors.warning
            : AppColors.error;

    return GestureDetector(
      onTap: () => _showMemberDetail(context, ref, name, major, reliability, user),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Avatar with admin crown overlay
            Stack(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: isAdmin ? AppColors.primarySurface : AppColors.backgroundBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      initial,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isAdmin ? AppColors.primary : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                if (isAdmin)
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      width: 18, height: 18,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: const Icon(LucideIcons.crown, size: 10, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Name + info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isCurrentUser) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D9488).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('You', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0D9488))),
                        ),
                      ],
                      if (isAdmin) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(8)),
                          child: const Text('Admin', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        ),
                      ],
                    ],
                  ),
                  if (major.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(major, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ],
              ),
            ),
            // Reliability score
            if (reliability > 0)
              _ReliabilityCircle(score: reliability, color: reliabilityColor),
            const SizedBox(width: 4),
            const Icon(LucideIcons.chevronRight, size: 16, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }

  void _showMemberDetail(BuildContext context, WidgetRef ref, String name, String major, int reliability, UserModel? user) {
    final reliabilityColor = reliability >= 80
        ? AppColors.success
        : reliability >= 50
            ? AppColors.warning
            : AppColors.error;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
            ),
            // Avatar
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: isAdmin ? AppColors.primarySurface : AppColors.backgroundBlue,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isAdmin ? AppColors.primary : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            if (major.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(major, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            ],
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isAdmin)
                  Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(8)),
                    child: const Text('Admin', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  ),
                if (isCurrentUser)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D9488).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('You', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF0D9488))),
                  ),
                if (reliability > 0) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: reliabilityColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('$reliability% reliable',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: reliabilityColor)),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 24),
            if (!isCurrentUser) ...[
              _ActionTile(
                icon: LucideIcons.userCheck,
                label: 'View Profile',
                color: AppColors.primary,
                onTap: () {
                  Navigator.pop(context);
                  showUserProfilePopup(context, ref, memberId);
                },
              ),
              if (isCurrentUserAdmin && !isAdmin)
                _ActionTile(
                  icon: LucideIcons.shieldPlus,
                  label: 'Make Admin',
                  color: AppColors.warning,
                  onTap: () async {
                    Navigator.pop(context);
                    await ref.read(groupsProvider.notifier).makeAdmin(group.groupId, memberId);
                  },
                ),
              if (isCurrentUserAdmin)
                _ActionTile(
                  icon: LucideIcons.userMinus,
                  label: 'Remove from Group',
                  color: Colors.redAccent,
                  onTap: () async {
                    Navigator.pop(context);
                    await ref.read(groupsProvider.notifier).removeMember(group.groupId, memberId);
                  },
                ),
            ] else ...[
              _ActionTile(
                icon: LucideIcons.logOut,
                label: 'Leave Group',
                color: Colors.redAccent,
                onTap: () async {
                  Navigator.pop(context);
                  await ref.read(groupsProvider.notifier).leaveGroup(group.groupId);
                  if (context.mounted) context.go(RouteConstants.groups);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionTile({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color, size: 20),
      title: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: color)),
      onTap: onTap,
    );
  }
}

class _ReliabilityCircle extends StatelessWidget {
  final int score;
  final Color color;
  const _ReliabilityCircle({required this.score, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44, height: 44,
      child: CustomPaint(
        painter: _CirclePainter(score: score, color: color),
        child: Center(
          child: Text('$score', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
        ),
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final int score;
  final Color color;
  _CirclePainter({required this.score, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 3;
    final bgPaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;
    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);
    final sweep = 2 * pi * (score / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweep,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_CirclePainter old) => old.score != score;
}
