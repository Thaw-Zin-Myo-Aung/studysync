import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/sheet_option_tile.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';

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
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                _showCreateGroupSheet(context);
              },
            ),
            const SizedBox(height: 12),

            // Join option
            SheetOptionTile(
              icon: LucideIcons.logIn,
              iconBgColor: const Color(0xFFE6FBF4),
              iconColor: const Color(0xFF10B981),
              title: 'Join Existing Group',
              subtitle: 'Enter a code or search by group name',
              onTap: () {
                Navigator.pop(context);
                _showJoinGroupSheet(context);
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

// ─── Create group sheet ───────────────────────────────────────────────────────

void _showCreateGroupSheet(BuildContext context) {
  final nameController = TextEditingController();
  final subjectController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => StatefulBuilder(
      builder: (ctx, _) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
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

              // Title
              const Text(
                'Create a New Group',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              const Text(
                'Fill in the details to start your study group.',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),

              CustomTextField(
                label: 'Group Name',
                hintText: 'e.g. Database Study Team',
                controller: nameController,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'Subject / Course',
                hintText: 'e.g. Database Systems',
                controller: subjectController,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 24),

              CustomButton(
                label: 'Create Group',
                onPressed: () => Navigator.pop(ctx),
                backgroundColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    ),
  ).whenComplete(() {
    nameController.dispose();
    subjectController.dispose();
  });
}

// ─── Join group sheet ─────────────────────────────────────────────────────────

void _showJoinGroupSheet(BuildContext context) {
  final codeController = TextEditingController();
  final searchController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => StatefulBuilder(
      builder: (ctx, _) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
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

              // Title
              const Text(
                'Join Existing Group',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              const Text(
                'Enter a group code or search by name.',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),

              CustomTextField(
                label: 'Group Code',
                hintText: 'e.g. GRP-1234',
                prefixIcon: LucideIcons.hash,
                controller: codeController,
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'Search by Name',
                hintText: 'e.g. Calculus Review',
                prefixIcon: LucideIcons.search,
                controller: searchController,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 24),

              CustomButton(
                label: 'Join Group',
                onPressed: () => Navigator.pop(ctx),
                backgroundColor: const Color(0xFF10B981),
              ),
            ],
          ),
        ),
      ),
    ),
  ).whenComplete(() {
    codeController.dispose();
    searchController.dispose();
  });
}

