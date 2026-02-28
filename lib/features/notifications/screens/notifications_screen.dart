import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/route_constants.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final newNotifications = [
      _NotificationItem(
        icon: LucideIcons.clock,
        iconBgColor: const Color(0xFFFFF3E0),
        iconColor: AppColors.warning,
        title: 'Session starting soon!',
        body: 'Math Study Group - Library 3F, Room 302 - in 1 hour',
        time: '1h ago',
        type: _NotifType.plain,
      ),
      _NotificationItem(
        icon: LucideIcons.userPlus,
        iconBgColor: AppColors.backgroundBlue,
        iconColor: AppColors.primary,
        title: 'New Group Request',
        body: 'Kay Suwannarat invited you to join Calculus Prep Team.',
        time: '3h ago',
        type: _NotifType.actionable,
        acceptLabel: 'Accept',
        declineLabel: 'Decline',
      ),
    ];

    final earlierNotifications = [
      _NotificationItem(
        icon: LucideIcons.messageSquare,
        iconBgColor: AppColors.backgroundBlue,
        iconColor: Colors.blueGrey,
        title: 'New post in Database Team',
        body: 'Som: Does anyone have the notes from Tuesday?',
        time: 'Yesterday',
        type: _NotifType.plain,
      ),
      _NotificationItem(
        icon: LucideIcons.circleCheck,
        iconBgColor: const Color(0xFFE8F5E9),
        iconColor: AppColors.success,
        title: 'How was your session?',
        body: 'Confirm attendance to keep your 95% Reliability Score.',
        time: 'Yesterday',
        type: _NotifType.outlined,
        acceptLabel: 'Mark Attendance',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundBlue,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 20, color: Colors.black87),
          onPressed: () => context.go(RouteConstants.home),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Mark all read',
              style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          const _SectionLabel(label: 'NEW'),
          const SizedBox(height: 10),
          ...newNotifications.map((n) => _NotifCard(item: n)),
          const SizedBox(height: 20),
          const _SectionLabel(label: 'EARLIER'),
          const SizedBox(height: 10),
          ...earlierNotifications.map((n) => _NotifCard(item: n)),
        ],
      ),
    );
  }
}

// ─── Enums & Models ───────────────────────────────
enum _NotifType { plain, actionable, outlined }

class _NotificationItem {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String body;
  final String time;
  final _NotifType type;
  final String? acceptLabel;
  final String? declineLabel;

  const _NotificationItem({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.body,
    required this.time,
    required this.type,
    this.acceptLabel,
    this.declineLabel,
  });
}

// ─── Section Label ────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: AppColors.textSecondary,
      ),
    );
  }
}

// ─── Notification Card ────────────────────────────
class _NotifCard extends StatelessWidget {
  final _NotificationItem item;
  const _NotifCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: item.iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, color: item.iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.body,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Actionable buttons
          if (item.type == _NotifType.actionable && item.acceptLabel != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  ),
                  child: Text(item.acceptLabel!, style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  ),
                  child: Text(item.declineLabel ?? 'Decline', style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                ),
              ],
            ),
          ],

          // Outlined single button
          if (item.type == _NotifType.outlined && item.acceptLabel != null) ...[
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.success),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              ),
              child: Text(item.acceptLabel!, style: const TextStyle(fontSize: 13, color: AppColors.success, fontWeight: FontWeight.w600)),
            ),
          ],

          // Timestamp
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              item.time,
              style: const TextStyle(fontSize: 12, color: AppColors.textHint),
            ),
          ),
        ],
      ),
    );
  }
}

