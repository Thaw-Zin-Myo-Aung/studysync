import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../../providers/auth_provider.dart';
import '../widgets/account_section.dart';
import '../widgets/notifications_section.dart';
import '../widgets/app_preferences_section.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    // Confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(authProvider.notifier).signOut();
      if (context.mounted) context.go(RouteConstants.login);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlue,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.surface,
        elevation: 2,
        shadowColor: Colors.black12,
        foregroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.go(RouteConstants.profile),
        ),
      ),
      body: Stack(
        children: [
          // Blob 1 — large primary glow, top-right
          Positioned(
            top: -20,
            right: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.28),
                    AppColors.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          // Blob 2 — medium glow, mid-left
          Positioned(
            top: 30,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF60A5FA).withValues(alpha: 0.22),
                    const Color(0xFF60A5FA).withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          // Blob 3 — small accent, top-center
          Positioned(
            top: 60,
            left: 130,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFBAD7FF).withValues(alpha: 0.35),
                    const Color(0xFFBAD7FF).withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          // Main scrollable content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AccountSection(),
                  const SizedBox(height: 16),
                  const NotificationsSection(),
                  const SizedBox(height: 16),
                  const AppPreferencesSection(),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(LucideIcons.logOut, color: AppColors.error),
                      label: const Text(
                        "Log Out",
                        style: TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.errorSurface),
                        backgroundColor: AppColors.errorLight,
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _handleLogout(context, ref),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      "Version 1.0.0",
                      style: TextStyle(fontSize: 12, color: AppColors.textDisabled),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0: context.go(RouteConstants.home);     break;
            case 1: context.go(RouteConstants.discover); break;
            case 2: context.go(RouteConstants.groups);   break;
            case 3: context.go(RouteConstants.profile);  break;
          }
        },
      ),
    );
  }
}
