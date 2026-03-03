import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/mfu_majors.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../providers/auth_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _idCtrl;
  late String _selectedMajor;
  late int _selectedYear;
  bool _isSaving = false;

  static const _yearLabels = ['1st', '2nd', '3rd', '4th'];

  static final _inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide.none,
  );

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider);
    _nameCtrl = TextEditingController(text: user?.name ?? '');
    _idCtrl   = TextEditingController(text: user?.studentId ?? '');
    _selectedMajor = (user?.major != null && mfuMajors.contains(user!.major))
        ? user.major
        : mfuMajors.first;
    _selectedYear = user?.year ?? 1;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _idCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Full name cannot be empty')),
      );
      return;
    }
    final uid = ref.read(authProvider)?.userId;
    if (uid == null) return;
    setState(() => _isSaving = true);
    try {
      await ref.read(authServiceProvider).updateProfile(
        uid: uid,
        major: _selectedMajor,
        year: _selectedYear,
      );
      final current = ref.read(authProvider);
      if (current != null) {
        ref.read(authProvider.notifier).updateUser(
          current.copyWith(
            name:  _nameCtrl.text.trim(),
            major: _selectedMajor,
            year:  _selectedYear,
          ),
        );
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated!')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlue,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 2,
        shadowColor: Colors.black12,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => context.pop(),
        ),
        title: const Text('Edit Profile',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Blob 1
          Positioned(
            top: -20, right: -40,
            child: Container(
              width: 220, height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.primary.withValues(alpha: 0.22),
                  AppColors.primary.withValues(alpha: 0.0),
                ]),
              ),
            ),
          ),
          // Blob 2
          Positioned(
            top: 30, left: -50,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFF60A5FA).withValues(alpha: 0.18),
                  const Color(0xFF60A5FA).withValues(alpha: 0.0),
                ]),
              ),
            ),
          ),
          // Blob 3
          Positioned(
            bottom: 60, right: -30,
            child: Container(
              width: 160, height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFFBAD7FF).withValues(alpha: 0.28),
                  const Color(0xFFBAD7FF).withValues(alpha: 0.0),
                ]),
              ),
            ),
          ),
          // Form card
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 24),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 28),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      color: Colors.black.withValues(alpha: 0.07),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full Name
                    CustomTextField(
                      label: 'Full Name',
                      hintText: 'e.g. Thaw Zin Myo Aung',
                      prefixIcon: LucideIcons.user,
                      controller: _nameCtrl,
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 16),
                    // Student ID — read-only
                    CustomTextField(
                      label: 'Student ID',
                      hintText: 'Auto-filled from your account',
                      prefixIcon: LucideIcons.hash,
                      controller: _idCtrl,
                      keyboardType: TextInputType.number,
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    // Major
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
                                (mfuMajorSchools[m] ?? '')
                                    .toLowerCase()
                                    .contains(q))
                            .toList();
                      },
                      selectedItem: _selectedMajor,
                      onChanged: (v) {
                        if (v != null) setState(() => _selectedMajor = v);
                      },
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            hintText: 'Search major or school…',
                            hintStyle: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textHint),
                            prefixIcon: const Icon(LucideIcons.search,
                                size: 18,
                                color: AppColors.textMuted),
                            filled: true,
                            fillColor: AppColors.backgroundPage,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(10),
                                borderSide: BorderSide.none),
                            contentPadding:
                                const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                          ),
                        ),
                        itemBuilder:
                            (ctx, item, isDisabled, isSelected) {
                          final school =
                              mfuMajorSchools[item] ?? '';
                          final idx = mfuMajors.indexOf(item);
                          final showHeader = idx == 0 ||
                              mfuMajorSchools[
                                      mfuMajors[idx - 1]] !=
                                  school;
                          return Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (showHeader)
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(
                                          16, 10, 16, 2),
                                  child: Text(school,
                                      style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight:
                                              FontWeight.w700,
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
                                        size: 16,
                                        color: AppColors.primary)
                                    : null,
                              ),
                            ],
                          );
                        },
                        menuProps: MenuProps(
                          borderRadius: BorderRadius.circular(14),
                          elevation: 4,
                        ),
                        constraints:
                            const BoxConstraints(maxHeight: 320),
                        emptyBuilder: (_, __) => const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('No majors found',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textMuted)),
                        ),
                      ),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.primarySurface,
                          hintText: 'Select your major',
                          hintStyle: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textHint),
                          prefixIcon: const Icon(
                              LucideIcons.graduationCap,
                              color: Colors.grey,
                              size: 20),
                          border: _inputBorder,
                          enabledBorder: _inputBorder,
                          focusedBorder: _inputBorder,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Year
                    const Text('Year',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87)),
                    const SizedBox(height: 10),
                    Row(
                      children: List.generate(4, (i) {
                        final year = i + 1;
                        final sel = _selectedYear == year;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: i < 3 ? 8.0 : 0),
                            child: GestureDetector(
                              onTap: () => setState(
                                  () => _selectedYear = year),
                              child: AnimatedContainer(
                                duration: const Duration(
                                    milliseconds: 200),
                                height: 44,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: sel
                                      ? AppColors.primary
                                      : AppColors.surface,
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  border: Border.all(
                                    color: sel
                                        ? AppColors.primary
                                        : AppColors.border,
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(_yearLabels[i],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: sel
                                          ? Colors.white
                                          : AppColors.textSecondary,
                                    )),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 28),
                    // Save button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(14)),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white))
                            : const Text('Save Changes',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


