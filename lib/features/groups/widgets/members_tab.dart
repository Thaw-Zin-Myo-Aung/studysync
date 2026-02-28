import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../models/group_model.dart';

class MembersTab extends StatelessWidget {
  final GroupModel group;
  const MembersTab({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 20, bottom: 100),
      itemCount: group.members.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _MemberCard(member: group.members[index]),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final GroupMember member;
  const _MemberCard({required this.member});

  Color _reliabilityColor(int score) {
    if (score >= 90) return AppColors.success;
    if (score >= 75) return AppColors.warning;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    final color = _reliabilityColor(member.reliability);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48, height: 48,
            decoration: const BoxDecoration(color: AppColors.backgroundBlue, shape: BoxShape.circle),
            child: const Icon(LucideIcons.user, size: 22, color: AppColors.textSecondary),
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
                        member.isYou ? '${member.name} (You)' : member.name,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (member.isAdmin) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(8)),
                        child: const Text('Admin', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text('${member.major} • Year ${member.year}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(LucideIcons.shieldCheck, size: 12, color: Colors.grey.shade400),
                    const SizedBox(width: 4),
                    Text('RELIABILITY',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.8, color: Colors.grey.shade400)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Three dots + reliability circle
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => _showMemberOptions(context, member),
                child: Icon(LucideIcons.ellipsis, size: 18, color: Colors.grey.shade400),
              ),
              const SizedBox(height: 8),
              _ReliabilityCircle(score: member.reliability, color: color),
            ],
          ),
        ],
      ),
    );
  }

  void _showMemberOptions(BuildContext context, GroupMember member) {
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
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
            ),
            Text(member.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 4),
            Text('${member.major} • Year ${member.year}',
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            if (!member.isYou) ...[
              _OptionTile(icon: LucideIcons.userCheck, label: 'View Profile', color: AppColors.primary, onTap: () => Navigator.pop(context)),
              _OptionTile(icon: LucideIcons.messageCircle, label: 'Send Message', color: AppColors.primary, onTap: () => Navigator.pop(context)),
              if (!member.isAdmin)
                _OptionTile(icon: LucideIcons.shieldPlus, label: 'Make Admin', color: AppColors.warning, onTap: () => Navigator.pop(context)),
              _OptionTile(icon: LucideIcons.userMinus, label: 'Remove from Group', color: Colors.redAccent, onTap: () => Navigator.pop(context)),
            ] else ...[
              _OptionTile(icon: LucideIcons.logOut, label: 'Leave Group', color: Colors.redAccent, onTap: () => Navigator.pop(context)),
            ],
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _OptionTile({required this.icon, required this.label, required this.color, required this.onTap});

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

