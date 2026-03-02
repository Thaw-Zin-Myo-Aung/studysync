import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_text_field.dart';

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

  static const List<String> _majors = [
    'Software Engineering', 'Computer Science', 'Information Technology',
    'Data Science', 'Business Administration', 'International Business',
    'Tourism Management', 'Nursing', 'Chinese Studies', 'English Studies',
  ];

  static const List<String> _yearLabels = ['1st', '2nd', '3rd', '4th'];

  static final _segmentBorder = OutlineInputBorder(
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
                      child: const Icon(LucideIcons.camera, size: 14, color: Colors.white),
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

        // ── Student ID ─────────────────────────────────
        CustomTextField(
          label: 'Student ID',
          hintText: '10-digit Student ID',
          prefixIcon: LucideIcons.hash,
          controller: studentIdController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),

        // ── Major dropdown ─────────────────────────────
        const Text('Major',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: selectedMajor,
          onChanged: (v) { if (v != null) onMajorChanged(v); },
          items: _majors.map((m) => DropdownMenuItem(
            value: m,
            child: Text(m, style: const TextStyle(fontSize: 14)),
          )).toList(),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.primarySurface,
            prefixIcon: const Icon(LucideIcons.graduationCap, color: Colors.grey, size: 20),
            border: _segmentBorder,
            enabledBorder: _segmentBorder,
            focusedBorder: _segmentBorder,
          ),
          dropdownColor: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        const SizedBox(height: 16),

        // ── Year chips ─────────────────────────────────
        const Text('Year',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
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
                      color: isSelected ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    child: Text(_yearLabels[i],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.textSecondary,
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


