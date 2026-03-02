import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/app_colors.dart';

class ProfileCompleteScreen extends StatefulWidget {
  const ProfileCompleteScreen({super.key});

  @override
  State<ProfileCompleteScreen> createState() => _ProfileCompleteScreenState();
}

class _ProfileCompleteScreenState extends State<ProfileCompleteScreen>
    with TickerProviderStateMixin {
  late final AnimationController _checkController;
  late final AnimationController _dotController;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;
  late final List<Animation<double>> _dotOffsets;
  late final List<Animation<double>> _dotOpacities;

  @override
  void initState() {
    super.initState();

    // ── Checkmark animation ──────────────────────
    _checkController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _scaleAnim = CurvedAnimation(
        parent: _checkController, curve: Curves.elasticOut);
    _fadeAnim = CurvedAnimation(
        parent: _checkController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn));
    _checkController.forward();

    // ── Dot animation ────────────────────────────
    _dotController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat();
    final starts = [0.0, 0.2, 0.4];
    _dotOffsets = starts.map((s) =>
      Tween<double>(begin: 0, end: -7).animate(CurvedAnimation(
          parent: _dotController,
          curve: Interval(s, s + 0.5, curve: Curves.easeInOut)))
    ).toList();
    _dotOpacities = starts.map((s) =>
      Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(
          parent: _dotController,
          curve: Interval(s, s + 0.5, curve: Curves.easeInOut)))
    ).toList();

    // ── Auto-navigate after 3 seconds ───────────
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) context.go(RouteConstants.home);
    });
  }

  @override
  void dispose() {
    _checkController.dispose();
    _dotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Animated checkmark circle ──────────────────
                FadeTransition(
                  opacity: _fadeAnim,
                  child: ScaleTransition(
                    scale: _scaleAnim,
                    child: Stack(alignment: Alignment.center, children: [
                      Container(
                          width: 160, height: 160,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: AppColors.successSurface)),
                      Container(
                          width: 120, height: 120,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: AppColors.success)),
                      const Icon(LucideIcons.check, size: 58, color: Colors.white),
                    ]),
                  ),
                ),
                const SizedBox(height: 36),

                // ── Title ──────────────────────────────────────
                const Text("You're all set! 🎉",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary),
                    textAlign: TextAlign.center),
                const SizedBox(height: 14),

                // ── Body text ──────────────────────────────────
                const Text(
                  'Your profile is ready. We are finding your top 5 study matches now...',
                  style: TextStyle(fontSize: 15, color: AppColors.textMuted, height: 1.6),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),

                // ── Three animated loading dots ─────────────────
                AnimatedBuilder(
                  animation: _dotController,
                  builder: (_, __) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) => Transform.translate(
                      offset: Offset(0, _dotOffsets[i].value),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Opacity(
                          opacity: _dotOpacities[i].value,
                          child: Container(
                            width: 9, height: 9,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: AppColors.success),
                          ),
                        ),
                      ),
                    )),
                  ),
                ),
                const SizedBox(height: 40),

                // ── Auto-navigate label ─────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(99),
                    border: Border.all(color: AppColors.success.withValues(alpha: 0.25)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(LucideIcons.timer, size: 13, color: AppColors.success),
                    const SizedBox(width: 6),
                    const Text('Auto-navigates to Home Dashboard after 3 seconds',
                        style: TextStyle(fontSize: 11, color: AppColors.success,
                            fontWeight: FontWeight.w500)),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

