import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'settings_section_header.dart';
import 'settings_item_row.dart';

class NotificationsSection extends StatefulWidget {
  const NotificationsSection({super.key});

  @override
  State<NotificationsSection> createState() => _NotificationsSectionState();
}

class _NotificationsSectionState extends State<NotificationsSection> {
  bool _pushEnabled = true;
  bool _groupEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionHeader(title: "Notifications"),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              SettingsItemRow(
                icon: Icons.notifications_outlined,
                iconBgColor: const Color(0xFFF5F3FF),
                iconColor: const Color(0xFF8B5CF6),
                title: "Push Notifications",
                subtitle: "Receive reminders for sessions",
                trailing: Switch(
                  value: _pushEnabled,
                  onChanged: (v) => setState(() => _pushEnabled = v),
                  activeThumbColor: AppColors.primary,
                ),
              ),
              const Divider(height: 1, indent: 68),
              SettingsItemRow(
                icon: Icons.chat_bubble_outline,
                iconBgColor: const Color(0xFFFFF0F0),
                iconColor: const Color(0xFFEF4444),
                title: "Group Messages",
                subtitle: "New discussion posts",
                trailing: Switch(
                  value: _groupEnabled,
                  onChanged: (v) => setState(() => _groupEnabled = v),
                  activeThumbColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

