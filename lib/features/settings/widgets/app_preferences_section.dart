import 'package:flutter/material.dart';
import 'settings_section_header.dart';
import 'settings_item_row.dart';

class AppPreferencesSection extends StatelessWidget {
  const AppPreferencesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionHeader(title: "App Preferences"),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SettingsItemRow(
            icon: Icons.language,
            iconBgColor: const Color(0xFFF0FDF4),
            iconColor: const Color(0xFF10B981),
            title: "Language",
            trailing: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "English",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.chevron_right, color: Color(0xFFCBD5E1), size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

