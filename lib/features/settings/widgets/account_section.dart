import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/route_constants.dart';
import '../../../providers/auth_provider.dart';
import 'settings_section_header.dart';
import 'settings_item_row.dart';

class AccountSection extends ConsumerWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

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
                icon: LucideIcons.user,
                iconBgColor: const Color(0xFFEFF6FF),
                iconColor: const Color(0xFF60A5FA),
                title: user?.name ?? 'Student',
                subtitle: user?.email ?? '',
                trailing: const Icon(LucideIcons.chevronRight, color: Color(0xFFCBD5E1)),
                onTap: () => context.go(RouteConstants.editProfile),
              ),
              const Divider(height: 1, indent: 68),
              const SettingsItemRow(
                icon: LucideIcons.lock,
                iconBgColor: Color(0xFFEFF6FF),
                iconColor: Color(0xFF60A5FA),
                title: "Change Password",
              ),
              const Divider(height: 1, indent: 68),
              SettingsItemRow(
                icon: LucideIcons.shieldCheck,
                iconBgColor: const Color(0xFFF0FDF4),
                iconColor: const Color(0xFF22C55E),
                title: "University Verified",
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      user?.email.endsWith('@lamduan.mfu.ac.th') == true
                          ? 'Verified (MFU)'
                          : 'Unverified',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: user?.email.endsWith('@lamduan.mfu.ac.th') == true
                            ? const Color(0xFF16A34A)
                            : const Color(0xFFEF4444),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      LucideIcons.shieldCheck,
                      color: user?.email.endsWith('@lamduan.mfu.ac.th') == true
                          ? const Color(0xFF16A34A)
                          : const Color(0xFFEF4444),
                      size: 14,
                    ),
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
