import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/availability_constants.dart';
import '../../../core/constants/mfu_majors.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../widgets/edit_basic_info_card.dart';
import '../widgets/edit_courses_card.dart';
import '../widgets/edit_availability_card.dart';
import '../widgets/edit_learning_style_card.dart';

// ── Local course entry ────────────────────────────────────────────────────────
class _CourseEntry {
  String name;
  String goal;
  _CourseEntry({required this.name, required this.goal});
  Map<String, String> toMap() => {'name': name, 'goal': goal};
}

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  // ── Editable state ───────────────────────────────────────────────────────
  late final TextEditingController _nameCtrl;
  late final TextEditingController _idCtrl;
  late String _selectedMajor;
  late int _selectedYear;
  late List<_CourseEntry> _courses;
  late List<List<bool>> _availability;
  late String _learningStyle;
  bool _isSaving = false;

  // ── Originals for dirty detection ────────────────────────────────────────
  late String _origName;
  late String _origMajor;
  late int _origYear;
  late List<Map<String, String>> _origCourses;
  late List<List<bool>> _origAvailability;
  late String _origLearningStyle;

  // ─────────────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider);

    _nameCtrl = TextEditingController(text: user?.name ?? '');
    _idCtrl   = TextEditingController(text: user?.studentId ?? '');
    _selectedMajor = (user?.major != null && mfuMajors.contains(user!.major))
        ? user.major : mfuMajors.first;
    _selectedYear = (user?.year != null && user!.year >= 1 && user.year <= 4)
        ? user.year : 1;

    final storedCourses = user?.courses ?? [];
    _courses = storedCourses.isNotEmpty
        ? storedCourses.map((c) => _CourseEntry(
              name: c['name']?.toString() ?? '',
              goal: c['goal']?.toString() ?? 'B+',
            )).toList()
        : [];

    _availability = availabilityMapToGrid(user?.availability ?? {});
    _learningStyle = user?.learningStyles.isNotEmpty == true
        ? user!.learningStyles.first : 'visual';

    // Snapshot originals
    _origName          = _nameCtrl.text;
    _origMajor         = _selectedMajor;
    _origYear          = _selectedYear;
    _origCourses       = _courses.map((c) => c.toMap()).toList();
    _origAvailability  = List.generate(
        _availability.length, (d) => List<bool>.from(_availability[d]));
    _origLearningStyle = _learningStyle;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _idCtrl.dispose();
    super.dispose();
  }

  // ── Dirty detection ──────────────────────────────────────────────────────
  bool _hasUnsavedChanges() {
    if (_nameCtrl.text != _origName) return true;
    if (_selectedMajor != _origMajor) return true;
    if (_selectedYear  != _origYear)  return true;
    if (_learningStyle != _origLearningStyle) return true;
    final cur = _courses.map((c) => c.toMap()).toList();
    if (cur.length != _origCourses.length) { return true; }
    for (int i = 0; i < cur.length; i++) {
      if (cur[i]['name'] != _origCourses[i]['name'] ||
          cur[i]['goal'] != _origCourses[i]['goal']) { return true; }
    }
    for (int d = 0; d < _availability.length; d++) {
      for (int s = 0; s < _availability[d].length; s++) {
        if (_availability[d][s] != _origAvailability[d][s]) { return true; }
      }
    }
    return false;
  }

  // ── Unsaved-changes dialog ───────────────────────────────────────────────
  Future<bool> _confirmDiscard() async {
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Unsaved Changes'),
        content: const Text(
            'You have unsaved changes. Do you want to save them before leaving?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'discard'),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Discard'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, 'save'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result == 'save') { await _save(); return false; }
    return result == 'discard';
  }

  Future<void> _onBackPressed() async {
    if (!_hasUnsavedChanges()) {
      context.go(RouteConstants.profile);
      return;
    }
    final shouldLeave = await _confirmDiscard();
    if (shouldLeave && mounted) context.go(RouteConstants.profile);
  }

  // ── Add-course dialog ────────────────────────────────────────────────────
  void _addCourse() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add a Course'),
        content: TextField(
          controller: ctrl, autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(hintText: 'Course name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                setState(() => _courses
                    .add(_CourseEntry(name: ctrl.text.trim(), goal: 'B+')));
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // ── Save ─────────────────────────────────────────────────────────────────
  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Full name cannot be empty')));
      return;
    }
    final uid = ref.read(authProvider)?.userId;
    if (uid == null) return;

    setState(() => _isSaving = true);
    try {
      final availMap = availabilityGridToMap(_availability);
      await ref.read(authServiceProvider).updateOnboardingStep(
        uid: uid,
        data: {
          'name':           _nameCtrl.text.trim(),
          'major':          _selectedMajor,
          'year':           _selectedYear,
          'courses':        _courses.map((c) => c.toMap()).toList(),
          'availability':   availMap,
          'learningStyles': [_learningStyle],
        },
      );
      final current = ref.read(authProvider);
      if (current != null) {
        ref.read(authProvider.notifier).updateUser(current.copyWith(
          name:           _nameCtrl.text.trim(),
          major:          _selectedMajor,
          year:           _selectedYear,
          courses:        _courses.map((c) => c.toMap()).toList(),
          availability:   availMap,
          learningStyles: [_learningStyle],
        ));
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Profile saved successfully!'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ));
        context.go(RouteConstants.profile);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to save: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _onBackPressed();
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundBlue,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 2,
          shadowColor: Colors.black12,
          foregroundColor: AppColors.textPrimary,
          leading: IconButton(
            icon: const Icon(LucideIcons.arrowLeft),
            onPressed: _onBackPressed,
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
            // ── Blobs ────────────────────────────────────────────
            Positioned(top: -20, right: -40,
              child: Container(width: 220, height: 220,
                decoration: BoxDecoration(shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    AppColors.primary.withValues(alpha: 0.22),
                    AppColors.primary.withValues(alpha: 0.0),
                  ])))),
            Positioned(top: 30, left: -50,
              child: Container(width: 200, height: 200,
                decoration: BoxDecoration(shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    const Color(0xFF60A5FA).withValues(alpha: 0.18),
                    const Color(0xFF60A5FA).withValues(alpha: 0.0),
                  ])))),
            Positioned(bottom: 60, right: -30,
              child: Container(width: 160, height: 160,
                decoration: BoxDecoration(shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    const Color(0xFFBAD7FF).withValues(alpha: 0.28),
                    const Color(0xFFBAD7FF).withValues(alpha: 0.0),
                  ])))),

            // ── Form ─────────────────────────────────────────────
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 24),
                child: Column(
                  children: [
                    EditBasicInfoCard(
                      nameController: _nameCtrl,
                      idController: _idCtrl,
                      selectedMajor: _selectedMajor,
                      onMajorChanged: (v) =>
                          setState(() => _selectedMajor = v),
                      selectedYear: _selectedYear,
                      onYearChanged: (v) =>
                          setState(() => _selectedYear = v),
                    ),
                    const SizedBox(height: 16),
                    EditCoursesCard(
                      courses: _courses.map((c) => c.toMap()).toList(),
                      onAddCourse: _addCourse,
                      onRemoveCourse: (i) =>
                          setState(() => _courses.removeAt(i)),
                      onChangeGoal: (i, g) =>
                          setState(() => _courses[i].goal = g),
                    ),
                    const SizedBox(height: 16),
                    EditAvailabilityCard(
                      availability: _availability,
                      onToggle: (d, s) => setState(
                          () => _availability[d][s] = !_availability[d][s]),
                    ),
                    const SizedBox(height: 16),
                    EditLearningStyleCard(
                      selectedStyle: _learningStyle,
                      onStyleChanged: (v) =>
                          setState(() => _learningStyle = v),
                    ),
                    const SizedBox(height: 24),

                    // ── Save button ───────────────────────────────
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
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                width: 22, height: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2.5, color: Colors.white))
                            : const Text('Save Changes',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
