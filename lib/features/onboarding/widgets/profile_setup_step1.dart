import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/mfu_majors.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_text_field.dart';

String _schoolFor(String major) => mfuMajorSchools[major] ?? '';

// ── Widget ───────────────────────────────────────────────────────────────────

class ProfileSetupStep1 extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController studentIdController;
  final String selectedMajor;
  final ValueChanged<String> onMajorChanged;
  final int selectedYear;
  final ValueChanged<int> onYearChanged;
  final VoidCallback onAvatarTap;

  const ProfileSetupStep1({
    super.key,
    required this.nameController,
    required this.studentIdController,
    required this.selectedMajor,
    required this.onMajorChanged,
    required this.selectedYear,
    required this.onYearChanged,
    required this.onAvatarTap,
  });

  static const List<String> _yearLabels = ['1st', '2nd', '3rd', '4th'];

  static final _inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide.none,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),

        // ── Avatar picker ──────────────────────────────
        Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: onAvatarTap,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 52,
                      backgroundColor: AppColors.primarySurface,
                      child: Icon(LucideIcons.user, size: 48,
                          color: AppColors.primary.withValues(alpha: 0.45)),
                    ),
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primary,
                      child: const Icon(LucideIcons.camera, size: 14,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text('Add a photo (optional)',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // ── Full Name ──────────────────────────────────
        CustomTextField(
          label: 'Full Name',
          hintText: 'e.g. Thaw Zin Myo Aung',
          prefixIcon: LucideIcons.user,
          controller: nameController,
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),

        // ── Student ID (read-only, auto-filled) ────────
        CustomTextField(
          label: 'Student ID',
          hintText: 'Auto-filled from your account',
          prefixIcon: LucideIcons.hash,
          controller: studentIdController,
          keyboardType: TextInputType.number,
          readOnly: true,
        ),
        const SizedBox(height: 16),

        // ── Major searchable dropdown ──────────────────
        const Text('Major',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
        const SizedBox(height: 8),
        DropdownSearch<String>(
          items: (filter, _) => filter.isEmpty
              ? mfuMajors
              : mfuMajors
                  .where((m) =>
                      m.toLowerCase().contains(filter.toLowerCase()) ||
                      _schoolFor(m)
                          .toLowerCase()
                          .contains(filter.toLowerCase()))
                  .toList(),
          selectedItem: mfuMajors.contains(selectedMajor)
              ? selectedMajor
              : null,
          onChanged: (v) { if (v != null) onMajorChanged(v); },
          // ── Popup with search box ──────────────────
          popupProps: PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: 'Search major or school…',
                hintStyle: const TextStyle(
                    fontSize: 13, color: AppColors.textHint),
                prefixIcon: const Icon(LucideIcons.search,
                    size: 18, color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.backgroundPage,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
              ),
            ),
            itemBuilder: (ctx, item, isDisabled, isSelected) {
              final school = _schoolFor(item);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Show school header only when first item of that group
                  if (mfuMajors.indexOf(item) == 0 ||
                      _schoolFor(mfuMajors[
                              mfuMajors.indexOf(item) - 1]) !=
                          school)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 2),
                      child: Text(school,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                              letterSpacing: 0.4)),
                    ),
                  ListTile(
                    dense: true,
                    title: Text(item,
                        style: TextStyle(
                            fontSize: 14,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textPrimary,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal)),
                    trailing: isSelected
                        ? Icon(LucideIcons.check,
                            size: 16, color: AppColors.primary)
                        : null,
                  ),
                ],
              );
            },
            menuProps: MenuProps(
              borderRadius: BorderRadius.circular(14),
              elevation: 4,
            ),
            constraints: const BoxConstraints(maxHeight: 320),
            emptyBuilder: (_, __) => const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No majors found',
                  style: TextStyle(
                      fontSize: 14, color: AppColors.textMuted)),
            ),
          ),
          // ── Closed field appearance ────────────────
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.primarySurface,
              hintText: 'Select your major',
              hintStyle: const TextStyle(
                  fontSize: 14, color: AppColors.textHint),
              prefixIcon: const Icon(LucideIcons.graduationCap,
                  color: Colors.grey, size: 20),
              border: _inputBorder,
              enabledBorder: _inputBorder,
              focusedBorder: _inputBorder,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ── Year chips ─────────────────────────────────
        const Text('Year',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
        const SizedBox(height: 10),
        Row(
          children: List.generate(4, (i) {
            final year = i + 1;
            final isSelected = selectedYear == year;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: i < 3 ? 8.0 : 0),
                child: GestureDetector(
                  onTap: () => onYearChanged(year),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    child: Text(_yearLabels[i],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                        )),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
