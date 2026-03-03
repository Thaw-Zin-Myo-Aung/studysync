import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/settings_provider.dart';
import 'settings_section_header.dart';
import 'settings_item_row.dart';

class NotificationsSection extends ConsumerWidget {
  const NotificationsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pushEnabled = ref.watch(pushNotificationsProvider);
    final groupEnabled = ref.watch(groupMessagesProvider);

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
                icon: LucideIcons.bell,
                iconBgColor: const Color(0xFFF5F3FF),
                iconColor: const Color(0xFF8B5CF6),
                title: "Push Notifications",
                subtitle: "Receive reminders for sessions",
                trailing: Switch(
                  value: pushEnabled,
                  onChanged: (v) {
                    ref.read(pushNotificationsProvider.notifier).toggle(v);
                  },
                  activeTrackColor: AppColors.primary,
                ),
              ),
              const Divider(height: 1, indent: 68),
              SettingsItemRow(
                icon: LucideIcons.messageCircle,
                iconBgColor: const Color(0xFFFFF0F0),
                iconColor: const Color(0xFFEF4444),
                title: "Group Messages",
                subtitle: "New discussion posts",
                trailing: Switch(
                  value: groupEnabled,
                  onChanged: (v) {
                    ref.read(groupMessagesProvider.notifier).toggle(v);
                  },
                  activeTrackColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
