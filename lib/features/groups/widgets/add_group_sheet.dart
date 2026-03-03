import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/sheet_option_tile.dart';
import 'join_group_sheet.dart';

// ─── Public entry point ───────────────────────────────────────────────────────

void showAddGroupSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _AddGroupSheet(),
  );
}

// ─── Option picker sheet ──────────────────────────────────────────────────────

class _AddGroupSheet extends StatelessWidget {
  const _AddGroupSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Section label
            const Text(
              'ADD A STUDY GROUP',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),

            // Create option
            SheetOptionTile(
              icon: LucideIcons.users,
              iconBgColor: AppColors.primarySurface,
              iconColor: AppColors.primary,
              title: 'Create a New Group',
              subtitle: 'Start a study group and invite members',
              onTap: () {
                Navigator.pop(context);
                context.push(RouteConstants.createGroup);
              },
            ),
            const SizedBox(height: 12),

            // Join option
            SheetOptionTile(
              icon: LucideIcons.logIn,
              iconBgColor: const Color(0xFFE6FBF4),
              iconColor: const Color(0xFF10B981),
              title: 'Join Existing Group',
              subtitle: 'Search by group name or group ID',
              onTap: () {
                Navigator.pop(context);
                showJoinGroupSheet(context);
              },
            ),
            const SizedBox(height: 20),

            // Cancel
            Center(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

