import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/app_colors.dart';

class LandingScreen extends ConsumerWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const _LandingView();
  }
}

// ─── Main view (StatefulWidget so we can use _isDesktop/_isTablet) ──────────

class _LandingView extends StatefulWidget {
  const _LandingView();

  @override
  State<_LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<_LandingView> {
  bool get _isDesktop => MediaQuery.of(context).size.width >= 1024;
  bool get _isTablet => MediaQuery.of(context).size.width >= 768;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPage,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _NavBar(isDesktop: _isDesktop),
            _HeroSection(isDesktop: _isDesktop, isTablet: _isTablet),
            _StatsBar(isDesktop: _isDesktop),
            _FeaturesSection(isDesktop: _isDesktop),
            _HowItWorksSection(isDesktop: _isDesktop),
            _CtaBanner(isDesktop: _isDesktop),
            const _Footer(),
          ],
        ),
      ),
    );
  }
}

// ─── SECTION 1: NAVBAR ───────────────────────────────────────────────────────

class _NavBar extends StatelessWidget {
  final bool isDesktop;
  const _NavBar({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isDesktop ? 64 : 56,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Study',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextSpan(
                      text: 'Sync',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Right buttons
          Row(
            children: [
              if (isDesktop) ...[
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => context.go(RouteConstants.login),
                  child: const Text('Sign In'),
                ),
                const SizedBox(width: 8),
              ],
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                onPressed: () => context.go(RouteConstants.signup),
                child: const Text('Get Started'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── SECTION 2: HERO ─────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  final bool isDesktop;
  final bool isTablet;
  const _HeroSection({required this.isDesktop, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    Widget content = isDesktop
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 1, child: _HeroText(isDesktop: isDesktop)),
              Expanded(flex: 1, child: _HeroMockup(isDesktop: isDesktop)),
            ],
          )
        : Column(
            children: [
              _HeroText(isDesktop: isDesktop),
              const SizedBox(height: 32),
              _HeroMockup(isDesktop: isDesktop),
            ],
          );

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.backgroundBlue, AppColors.backgroundPage],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Blob 1 — top right
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Blob 2 — mid left
          Positioned(
            top: 100,
            left: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF60A5FA).withValues(alpha: 0.20),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Blob 3 — center
          Positioned(
            top: 200,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFBAD7FF).withValues(alpha: 0.30),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Main content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 80 : 24,
              vertical: isDesktop ? 80 : 48,
            ),
            child: isDesktop
                ? Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: content,
                    ),
                  )
                : content,
          ),
        ],
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  final bool isDesktop;
  const _HeroText({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badge pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.backgroundBlue,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFDBEAFE)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(LucideIcons.zap, size: 14, color: AppColors.primary),
              SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Smart Study Matching for Students',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Headline
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Find Your Perfect\n',
                style: TextStyle(
                  fontSize: isDesktop ? 52 : 34,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1.15,
                ),
              ),
              TextSpan(
                text: 'Study Partner',
                style: TextStyle(
                  fontSize: isDesktop ? 52 : 34,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Subheadline
        Text(
          'Stop wasting 30–45 minutes messaging classmates.\n'
          'StudySync matches you with compatible study partners\n'
          'based on your schedule, courses, and academic goals.',
          style: const TextStyle(
            fontSize: 17,
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 32),
        // CTA buttons
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton.icon(
              icon: const Icon(LucideIcons.arrowRight, size: 18),
              label: const Text('Get Started Free'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 52),
                padding: const EdgeInsets.symmetric(horizontal: 28),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              onPressed: () => context.go(RouteConstants.signup),
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                minimumSize: const Size(0, 52),
                padding: const EdgeInsets.symmetric(horizontal: 28),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => context.go(RouteConstants.login),
              child: const Text('Sign In'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Trust row
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: const [
            _TrustItem(text: 'Free for students'),
            _TrustItem(text: 'No credit card'),
            _TrustItem(text: 'Takes 2 minutes'),
          ],
        ),
      ],
    );
  }
}

class _HeroMockup extends StatelessWidget {
  final bool isDesktop;
  const _HeroMockup({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final frameWidth = isDesktop ? 280.0 : 240.0;
    return Center(
      child: SizedBox(
        height: isDesktop ? 520 : 420,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Phone frame
            Transform.rotate(
              angle: 0.035,
              child: Container(
                width: frameWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36),
                  border: Border.all(color: AppColors.border, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      blurRadius: 40,
                      offset: const Offset(0, 16),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.asset(
                  'assets/images/Dashboard_mockup.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            // Floating badge top-left
            Positioned(
              top: 60,
              left: -20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 8),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(LucideIcons.users,
                        size: 16, color: AppColors.primary),
                    SizedBox(width: 6),
                    Text(
                      '127 Active Groups',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Floating badge bottom-right
            Positioned(
              bottom: 70,
              right: -20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 8),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(LucideIcons.star,
                        size: 16, color: AppColors.warning),
                    SizedBox(width: 6),
                    Text(
                      '96% Match Rate',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
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

// ─── SECTION 3: STATS BAR ────────────────────────────────────────────────────

class _StatsBar extends StatelessWidget {
  final bool isDesktop;
  const _StatsBar({required this.isDesktop});

  static const _stats = [
    _StatData('500+', 'Students'),
    _StatData('92%', 'Match Success Rate'),
    _StatData('75%', 'Avg. Attendance Rate'),
    _StatData('2 min', 'To Find a Partner'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border.symmetric(
          horizontal: BorderSide(color: AppColors.border),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      child: isDesktop
          ? Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(_stats.length * 2 - 1, (i) {
                    if (i.isOdd) {
                      return const SizedBox(
                        height: 48,
                        child: VerticalDivider(
                          color: AppColors.border,
                          width: 1,
                          thickness: 1,
                        ),
                      );
                    }
                    final s = _stats[i ~/ 2];
                    return Expanded(child: _StatItem(s.value, s.label));
                  }),
                ),
              ),
            )
          : Wrap(
              alignment: WrapAlignment.spaceEvenly,
              runSpacing: 24,
              spacing: 24,
              children: _stats
                  .map((s) => SizedBox(
                        width: 140,
                        child: _StatItem(s.value, s.label),
                      ))
                  .toList(),
            ),
    );
  }
}

class _StatData {
  final String value;
  final String label;
  const _StatData(this.value, this.label);
}

// ─── SECTION 4: FEATURES ─────────────────────────────────────────────────────

class _FeaturesSection extends StatelessWidget {
  final bool isDesktop;
  const _FeaturesSection({required this.isDesktop});

  static const _cards = [
    _FeatureData(
      iconBg: AppColors.backgroundBlue,
      iconColor: AppColors.primary,
      icon: LucideIcons.target,
      title: 'Smart Compatibility Matching',
      desc:
          'Algorithm scores partners on schedule overlap (40%), shared courses (30%), academic goals (20%), and learning style (10%).',
    ),
    _FeatureData(
      iconBg: AppColors.successLight,
      iconColor: AppColors.success,
      icon: LucideIcons.shieldCheck,
      title: 'Reliability Scores',
      desc:
          'Every student has a public reliability score. See who actually shows up before forming a group — no more last-minute cancellations.',
    ),
    _FeatureData(
      iconBg: AppColors.purpleLight,
      iconColor: AppColors.purple,
      icon: LucideIcons.users,
      title: 'One-Tap Group Creation',
      desc:
          'Form study groups directly from matches. Set location, schedule, and manage members — all without leaving the app.',
    ),
    _FeatureData(
      iconBg: AppColors.warningLight,
      iconColor: AppColors.warning,
      icon: LucideIcons.calendar,
      title: 'Session Scheduling',
      desc:
          'Schedule recurring or one-time sessions. Upcoming sessions appear on your home dashboard so you never miss a study day.',
    ),
    _FeatureData(
      iconBg: AppColors.backgroundBlue,
      iconColor: AppColors.primary,
      icon: LucideIcons.messageSquare,
      title: 'Group Discussion Board',
      desc:
          'Coordinate sessions, share notes, ask questions — all in one threaded board per group. No more jumping between apps.',
    ),
    _FeatureData(
      iconBg: AppColors.successLight,
      iconColor: AppColors.success,
      icon: LucideIcons.circleCheck,
      title: 'Attendance Tracking',
      desc:
          'Mark attendance after each session with one tap. Your reliability score updates automatically, building your academic reputation.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundPage,
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Section header
              const Text(
                'WHY STUDYSYNC',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Everything you need to study smarter',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isDesktop ? 34 : 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Built specifically for students who want results, not just group chats.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 48),
              // Responsive feature grid
              LayoutBuilder(
                builder: (context, constraints) {
                  int columns;
                  if (constraints.maxWidth >= 900) {
                    columns = 3;
                  } else if (constraints.maxWidth >= 600) {
                    columns = 2;
                  } else {
                    columns = 1;
                  }
                  final spacing = 16.0;
                  final cardWidth =
                      (constraints.maxWidth - spacing * (columns - 1)) /
                          columns;
                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: _cards
                        .map((c) => _FeatureCard(
                              data: c,
                              width: cardWidth,
                            ))
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureData {
  final Color iconBg;
  final Color iconColor;
  final IconData icon;
  final String title;
  final String desc;
  const _FeatureData({
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    required this.title,
    required this.desc,
  });
}

// ─── SECTION 5: HOW IT WORKS ─────────────────────────────────────────────────

class _HowItWorksSection extends StatelessWidget {
  final bool isDesktop;
  const _HowItWorksSection({required this.isDesktop});

  static const _steps = [
    _StepData(
      number: '01',
      title: 'Create Your Profile',
      desc:
          'Add your courses, mark your weekly availability on the visual calendar, and set your academic goals per subject.',
    ),
    _StepData(
      number: '02',
      title: 'Get Matched',
      desc:
          "StudySync shows your top 5 compatible partners with match percentage and reasons — like 'Both free Thu 7–9 PM'.",
    ),
    _StepData(
      number: '03',
      title: 'Start Studying',
      desc:
          'Form a group, schedule your first session, and track attendance. Watch your reliability score grow.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const Text(
                '3 STEPS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Get started in 3 steps',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isDesktop ? 34 : 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 48),
              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(_steps.length * 2 - 1, (i) {
                        if (i.isOdd) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 26),
                              child: CustomPaint(
                                painter: _DottedLinePainter(),
                                child: const SizedBox(height: 2),
                              ),
                            ),
                          );
                        }
                        return Expanded(
                          flex: 3,
                          child: _StepCard(_steps[i ~/ 2]),
                        );
                      }),
                    )
                  : Column(
                      children: _steps
                          .map((s) => Padding(
                                padding: const EdgeInsets.only(bottom: 32),
                                child: _StepCard(s),
                              ))
                          .toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepData {
  final String number;
  final String title;
  final String desc;
  const _StepData({
    required this.number,
    required this.title,
    required this.desc,
  });
}

class _DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_DottedLinePainter oldDelegate) => false;
}

// ─── SECTION 6: CTA BANNER ───────────────────────────────────────────────────

class _CtaBanner extends StatelessWidget {
  final bool isDesktop;
  const _CtaBanner({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 72, horizontal: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Decorative blobs
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Content
          Center(
            child: Column(
              children: [
                Text(
                  'Ready to find your\nstudy partner?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isDesktop ? 40 : 30,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Join students already using StudySync to improve their grades.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 36),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        minimumSize: const Size(0, 52),
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () => context.go(RouteConstants.signup),
                      child: const Text(
                        'Get Started Free',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.6)),
                        minimumSize: const Size(0, 52),
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => context.go(RouteConstants.login),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Exclusive to University students',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.60),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── SECTION 7: FOOTER ───────────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0A0F1E),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Text(
                    'Study',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Sync',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const Flexible(
                child: Text(
                  '© 2026 StudySync. Built for students.',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFFCBD5E1),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── REUSABLE PRIVATE WIDGETS ─────────────────────────────────────────────────

class _TrustItem extends StatelessWidget {
  final String text;
  const _TrustItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(LucideIcons.circleCheck,
            size: 14, color: AppColors.success),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final _FeatureData data;
  final double width;
  const _FeatureCard({required this.data, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: data.iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(data.icon, color: data.iconColor, size: 22),
            ),
            const SizedBox(height: 16),
            Text(
              data.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              data.desc,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final _StepData data;
  const _StepCard(this.data);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              data.number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          data.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          data.desc,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}



