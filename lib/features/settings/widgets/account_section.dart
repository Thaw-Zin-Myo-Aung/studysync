import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/snackbar_utils.dart';
import '../../../providers/auth_provider.dart';
import 'settings_section_header.dart';
import 'settings_item_row.dart';

class AccountSection extends ConsumerWidget {
  const AccountSection({super.key});

  void _showChangePasswordSheet(BuildContext context) {
    final currentPwdCtrl = TextEditingController();
    final newPwdCtrl = TextEditingController();
    final confirmPwdCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const Text('Change Password',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: currentPwdCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Current Password',
                  prefixIcon: const Icon(LucideIcons.lock, size: 18),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPwdCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'New Password',
                  prefixIcon: const Icon(LucideIcons.keyRound, size: 18),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmPwdCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirm New Password',
                  prefixIcon: const Icon(LucideIcons.keyRound, size: 18),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    final currentPwd = currentPwdCtrl.text.trim();
                    final newPwd = newPwdCtrl.text.trim();
                    final confirmPwd = confirmPwdCtrl.text.trim();

                    if (newPwd.length < 6) {
                      AppSnackBar.error(context, 'Password must be at least 6 characters');
                      return;
                    }
                    if (newPwd != confirmPwd) {
                      AppSnackBar.error(context, 'Passwords do not match');
                      return;
                    }

                    try {
                      final user = FirebaseAuth.instance.currentUser!;
                      final cred = EmailAuthProvider.credential(
                        email: user.email!,
                        password: currentPwd,
                      );
                      await user.reauthenticateWithCredential(cred);
                      await user.updatePassword(newPwd);
                      if (context.mounted) {
                        Navigator.pop(context);
                        AppSnackBar.success(context, 'Password updated successfully');
                      }
                    } catch (e) {
                      if (context.mounted) {
                        AppSnackBar.error(context, e.toString());
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Update Password',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
              SettingsItemRow(
                icon: LucideIcons.lock,
                iconBgColor: const Color(0xFFEFF6FF),
                iconColor: const Color(0xFF60A5FA),
                title: "Change Password",
                onTap: () => _showChangePasswordSheet(context),
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
