import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

class ChildSafetyScreen extends StatelessWidget {
  const ChildSafetyScreen({super.key});

  static const List<_ChildSafetySection> _sections = [
    _ChildSafetySection(
      number: '01',
      title: 'Our Commitment',
      body:
          'StudySync is committed to providing a safe platform for all users. We strictly prohibit any content, behavior, or activity that exploits, abuses, or endangers children in any way, including child sexual abuse and exploitation (CSAE). StudySync is designed exclusively for university students aged 18 and older.',
    ),
    _ChildSafetySection(
      number: '02',
      title: 'Prohibited Content & Behavior',
      body:
          'The following are strictly prohibited:',
      bullets: [
        'Child sexual abuse material (CSAM) in any form',
        'Grooming, solicitation, or exploitation of minors',
        'Any content that sexualizes or endangers children',
        'Sharing personal information of minors without consent',
        'Any communication intended to gain inappropriate access to a minor',
      ],
      footer:
          'Accounts violating these rules are permanently banned and reported to authorities.',
    ),
    _ChildSafetySection(
      number: '03',
      title: 'Reporting Mechanisms',
      body:
          'StudySync provides in-app reporting tools on all user profiles and content. Reports are reviewed within 24 to 48 hours. Confirmed violations result in immediate permanent ban and are reported to relevant authorities.',
    ),
    _ChildSafetySection(
      number: '04',
      title: 'Compliance',
      body:
          'StudySync complies with all applicable child safety laws and regulations. We report confirmed CSAM cases to national and regional authorities including NCMEC where applicable.',
    ),
    _ChildSafetySection(
      number: '05',
      title: 'Designated Point of Contact',
      body:
          'For child safety concerns or CSAE-related reports, contact:',
      lines: [
        'Email: vittayasak@mfu.ac.th',
        'Organization: StudySync — Mae Fah Luang University',
        'Response time: Within 48 hours',
      ],
    ),
    _ChildSafetySection(
      number: '06',
      title: 'Policy Updates',
      body:
          'We may update these standards periodically. Continued use of StudySync constitutes acceptance of the current version.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlue,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 2,
        shadowColor: Colors.black12,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Child Safety Standards',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          // Blob 1 — large primary glow, top-right
          Positioned(
            top: -20,
            right: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.28),
                    AppColors.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          // Blob 2 — medium glow, mid-left
          Positioned(
            top: 30,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF60A5FA).withValues(alpha: 0.22),
                    const Color(0xFF60A5FA).withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          // Blob 3 — small accent, top-center
          Positioned(
            top: 60,
            left: 130,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFBAD7FF).withValues(alpha: 0.35),
                    const Color(0xFFBAD7FF).withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._sections.map((section) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _ChildSafetySectionCard(section: section),
                      )),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Last updated: April 2026 · StudySync · Mae Fah Luang University',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textDisabled,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChildSafetySection {
  final String number;
  final String title;
  final String body;
  final List<String> bullets;
  final List<String> lines;
  final String footer;

  const _ChildSafetySection({
    required this.number,
    required this.title,
    required this.body,
    this.bullets = const [],
    this.lines = const [],
    this.footer = '',
  });
}

class _ChildSafetySectionCard extends StatelessWidget {
  final _ChildSafetySection section;

  const _ChildSafetySectionCard({required this.section});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.number,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            section.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            section.body,
            style: const TextStyle(
              fontSize: 13,
              height: 1.6,
              color: AppColors.textSecondary,
            ),
          ),
          if (section.bullets.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...section.bullets.map((text) => _BulletLine(text: text)),
          ],
          if (section.lines.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...section.lines.map((text) => _PlainLine(text: text)),
          ],
          if (section.footer.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              section.footer,
              style: const TextStyle(
                fontSize: 13,
                height: 1.6,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  final String text;

  const _BulletLine({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                height: 1.6,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlainLine extends StatelessWidget {
  final String text;

  const _PlainLine({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          height: 1.6,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

