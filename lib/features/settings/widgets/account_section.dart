import 'package:flutter/material.dart';
import 'settings_section_header.dart';
import 'settings_item_row.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsSectionHeader(title: "Account"),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              SettingsItemRow(
                icon: Icons.person_outlined,
                iconBgColor: const Color(0xFFEFF6FF),
                iconColor: const Color(0xFF60A5FA),
                title: "Thaw Zin",
                subtitle: "thaw.zin@student.mfu.ac.th",
                trailing: const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1)),
              ),
              const Divider(height: 1, indent: 68),
              SettingsItemRow(
                icon: Icons.lock_outline,
                iconBgColor: const Color(0xFFEFF6FF),
                iconColor: const Color(0xFF60A5FA),
                title: "Change Password",
              ),
              const Divider(height: 1, indent: 68),
              SettingsItemRow(
                icon: Icons.verified_user_outlined,
                iconBgColor: const Color(0xFFF0FDF4),
                iconColor: const Color(0xFF22C55E),
                title: "University Verified",
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "Verified (MFU)",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 14),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

