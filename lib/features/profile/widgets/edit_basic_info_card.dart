import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/mfu_majors.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_text_field.dart';
import 'edit_section_card.dart';

class EditBasicInfoCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController idController;
  final String selectedMajor;
  final ValueChanged<String> onMajorChanged;
  final int selectedYear;
  final ValueChanged<int> onYearChanged;

  const EditBasicInfoCard({
    super.key,
    required this.nameController,
    required this.idController,
    required this.selectedMajor,
    required this.onMajorChanged,
    required this.selectedYear,
    required this.onYearChanged,
  });

  static const _yearLabels = ['1st', '2nd', '3rd', '4th'];

  static final _inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide.none,
  );

  @override
  Widget build(BuildContext context) {
    return EditSectionCard(
      icon: LucideIcons.user,
      title: 'Basic Info',
      children: [
        CustomTextField(
          label: 'Full Name',
          hintText: 'e.g. Thaw Zin Myo Aung',
          prefixIcon: LucideIcons.user,
          controller: nameController,
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          label: 'Student ID',
          hintText: 'Auto-filled from your account',
          prefixIcon: LucideIcons.hash,
          controller: idController,
          keyboardType: TextInputType.number,
          readOnly: true,
        ),
        const SizedBox(height: 16),

        // ── Major ──────────────────────────────────────────────
        const Text('Major',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
        const SizedBox(height: 8),
        DropdownSearch<String>(
          items: (filter, _) {
            if (filter.isEmpty) return mfuMajors;
            final q = filter.toLowerCase();
            return mfuMajors
                .where((m) =>
                    m.toLowerCase().contains(q) ||
                    (mfuMajorSchools[m] ?? '').toLowerCase().contains(q))
                .toList();
          },
          selectedItem: selectedMajor,
          onChanged: (v) { if (v != null) onMajorChanged(v); },
          popupProps: PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: 'Search major or school…',
                hintStyle:
                    const TextStyle(fontSize: 13, color: AppColors.textHint),
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
              final school = mfuMajorSchools[item] ?? '';
              final idx = mfuMajors.indexOf(item);
              final showHeader = idx == 0 ||
                  mfuMajorSchools[mfuMajors[idx - 1]] != school;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showHeader)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 2),
                      child: Text(school,
                          style: const TextStyle(
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
                        ? const Icon(LucideIcons.check,
                            size: 16, color: AppColors.primary)
                        : null,
                  ),
                ],
              );
            },
            menuProps:
                MenuProps(borderRadius: BorderRadius.circular(14), elevation: 4),
            constraints: const BoxConstraints(maxHeight: 320),
            emptyBuilder: (_, __) => const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No majors found',
                  style:
                      TextStyle(fontSize: 14, color: AppColors.textMuted)),
            ),
          ),
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.primarySurface,
              hintText: 'Select your major',
              hintStyle:
                  const TextStyle(fontSize: 14, color: AppColors.textHint),
              prefixIcon: const Icon(LucideIcons.graduationCap,
                  color: Colors.grey, size: 20),
              border: _inputBorder,
              enabledBorder: _inputBorder,
              focusedBorder: _inputBorder,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ── Year chips ─────────────────────────────────────────
        const Text('Year',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
        const SizedBox(height: 10),
        Row(
          children: List.generate(4, (i) {
            final year = i + 1;
            final sel = selectedYear == year;
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
                      color: sel ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: sel ? AppColors.primary : AppColors.border,
                          width: 1.5),
                    ),
                    child: Text(_yearLabels[i],
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: sel
                                ? Colors.white
                                : AppColors.textSecondary)),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

