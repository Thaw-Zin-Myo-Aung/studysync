import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/onboarding_progress_bar.dart';
import '../widgets/profile_setup_step1.dart';
import '../widgets/profile_setup_step2.dart';
import '../widgets/profile_setup_step3.dart';
import '../widgets/profile_setup_step4.dart';

class _CourseEntry {
  String name;
  String goal;
  _CourseEntry({required this.name, required this.goal});
  Map<String, String> toMap() => {'name': name, 'goal': goal};
}

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  int _step = 0;
  late final PageController _pageController;
  final _nameCtrl = TextEditingController(text: 'Thaw Zin Myo Aung');
  final _idCtrl   = TextEditingController();
  String _major   = 'Software Engineering';
  int _year       = 2;
  final List<_CourseEntry> _courses = [
    _CourseEntry(name: 'Engineering Mathematics II', goal: 'B+'),
    _CourseEntry(name: 'Database Systems', goal: 'B+'),
  ];
  late List<List<bool>> _availability;
  String _learningStyle = 'visual';

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _availability = List.generate(7, (d) => List.generate(6, (s) {
      if (d == 3 && s == 5) return true; // Thu 7PM
      if (d == 1 && s == 5) return true; // Tue 7PM
      if (d == 3 && s == 3) return true; // Thu 2PM
      return false;
    }));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameCtrl.dispose();
    _idCtrl.dispose();
    super.dispose();
  }

  void _addCourse() {
    final ctrl = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Add a Course'),
      content: TextField(
        controller: ctrl, autofocus: true,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(hintText: 'Course name')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context),
          child: const Text('Cancel')),
        TextButton(onPressed: () {
          if (ctrl.text.trim().isNotEmpty) {
            setState(() => _courses.add(
              _CourseEntry(name: ctrl.text.trim(), goal: 'B+')));
          }
          Navigator.pop(context);
        }, child: const Text('Add')),
      ]));
  }

  void _removeCourse(int i) => setState(() => _courses.removeAt(i));
  void _changeGoal(int i, String g) => setState(() => _courses[i].goal = g);

  void _toggleAvailability(int day, int slot) =>
      setState(() => _availability[day][slot] = !_availability[day][slot]);

  void _next() {
    if (_step < 3) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _step++);
    } else {
      // TODO: persist data before navigating
      context.go(RouteConstants.profileComplete);
    }
  }

  void _back() {
    if (_step > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _step--);
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    const stepTitles = [
      'Set Up Your Profile', 'Your Courses',
      'When Are You Free?', 'How Do You Learn Best?'
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundBlue,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Blob 1 — large primary glow, bottom-left
          Positioned(
            bottom: -40, left: -60,
            child: Container(
              width: 260, height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.primary.withValues(alpha: 0.22),
                  AppColors.primary.withValues(alpha: 0.0),
                ]),
              ),
            ),
          ),
          // Blob 2 — medium glow, top-right
          Positioned(
            top: -30, right: -50,
            child: Container(
              width: 220, height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.primarySurface.withValues(alpha: 0.35),
                  AppColors.primarySurface.withValues(alpha: 0.0),
                ]),
              ),
            ),
          ),
          // Blob 3 — small accent, mid-right
          Positioned(
            top: 240, right: -30,
            child: Container(
              width: 140, height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.primaryLight.withValues(alpha: 0.45),
                  AppColors.primaryLight.withValues(alpha: 0.0),
                ]),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // ── Header row ──────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(stepTitles[_step],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary),
                            textAlign: TextAlign.left),
                      ),
                      Text('Step ${_step + 1} of 4',
                          style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    ],
                  ),
                ),

                // ── Progress bar ─────────────────────────────────
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
                  child: OnboardingProgressBar(currentStep: _step + 1),
                ),

                // ── Card ─────────────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 20,
                            color: Colors.black.withValues(alpha: 0.08),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // ── Page content ──────────────────────
                          Expanded(
                            child: PageView(
                              controller: _pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                SingleChildScrollView(
                                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                                  child: ProfileSetupStep1(
                                    nameController: _nameCtrl,
                                    studentIdController: _idCtrl,
                                    selectedMajor: _major,
                                    onMajorChanged: (v) => setState(() => _major = v),
                                    selectedYear: _year,
                                    onYearChanged: (v) => setState(() => _year = v),
                                    onAvatarTap: () => ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Photo picker coming in a future update'))),
                                  ),
                                ),
                                SingleChildScrollView(
                                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                                  child: ProfileSetupStep2(
                                    courses: _courses.map((c) => c.toMap()).toList(),
                                    onAddCourse: _addCourse,
                                    onRemoveCourse: _removeCourse,
                                    onChangeGoal: _changeGoal,
                                  ),
                                ),
                                SingleChildScrollView(
                                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                                  child: ProfileSetupStep3(
                                    availability: _availability,
                                    onToggle: _toggleAvailability,
                                  ),
                                ),
                                SingleChildScrollView(
                                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                                  child: ProfileSetupStep4(
                                    selectedStyle: _learningStyle,
                                    onStyleChanged: (v) => setState(() => _learningStyle = v),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // ── Button inside card ────────────────
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                            child: Row(
                              children: [
                                // Previous button — invisible on step 1 to keep Next same size
                                Expanded(
                                  child: _step > 0
                                      ? SizedBox(
                                          height: 52,
                                          child: OutlinedButton.icon(
                                            icon: const Icon(LucideIcons.arrowLeft, size: 16),
                                            label: const Text('Previous',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600)),
                                            onPressed: _back,
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: AppColors.textSecondary,
                                              side: const BorderSide(
                                                  color: AppColors.border, width: 1.5),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(14)),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(height: 52),
                                ),
                                const SizedBox(width: 12),

                                // Next / Finish button
                                Expanded(
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 250),
                                    child: _step < 3
                                        ? SizedBox(
                                            key: const ValueKey('next'),
                                            height: 52,
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: _next,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColors.primary,
                                                foregroundColor: Colors.white,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(14)),
                                              ),
                                              child: const Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text('Next',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.white)),
                                                  SizedBox(width: 6),
                                                  Icon(LucideIcons.arrowRight,
                                                      color: Colors.white, size: 16),
                                                ],
                                              ),
                                            ),
                                          )
                                        : SizedBox(
                                            key: const ValueKey('finish'),
                                            height: 52,
                                            width: double.infinity,
                                            child: ElevatedButton.icon(
                                              icon: const Icon(LucideIcons.circleCheck,
                                                  color: Colors.white, size: 20),
                                              label: const Text('Complete',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.white)),
                                              onPressed: _next,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColors.success,
                                                foregroundColor: Colors.white,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(14)),
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

