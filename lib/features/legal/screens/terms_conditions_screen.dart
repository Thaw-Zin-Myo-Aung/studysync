import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  static const List<_TermsSection> _sections = [
    _TermsSection(
      number: '01',
      title: 'Acceptance of Terms',
      body:
          'By creating a StudySync account, you agree to these Terms. If you do not agree, do not use the app.',
    ),
    _TermsSection(
      number: '02',
      title: 'Eligibility',
      body:
          'StudySync is for university students aged 18 and older. By registering, you confirm you meet this requirement.',
    ),
    _TermsSection(
      number: '03',
      title: 'User Accounts',
      body:
          'You are responsible for maintaining the confidentiality of your account credentials. You agree to provide accurate information during registration.',
    ),
    _TermsSection(
      number: '04',
      title: 'Acceptable Use',
      body:
          'You must not: impersonate others, harass or harm other users, post false or misleading information, attempt to access other users\' private data, use the app for any commercial purpose.',
    ),
    _TermsSection(
      number: '05',
      title: 'Study Partner Matching',
      body:
          'Match scores are calculated based on schedule overlap (40%), shared courses (30%), academic goals (20%), and learning style (10%). Matches are suggestions only — StudySync does not guarantee compatibility.',
    ),
    _TermsSection(
      number: '06',
      title: 'User Content',
      body:
          'You retain ownership of content you post. By posting, you grant StudySync a non-exclusive license to display that content to relevant users within the app. You are responsible for all content you submit.',
    ),
    _TermsSection(
      number: '07',
      title: 'Reliability Score',
      body:
          'Your attendance reliability score is calculated from sessions you join. Consistent no-shows may affect your visibility in match results.',
    ),
    _TermsSection(
      number: '08',
      title: 'Termination',
      body:
          'We reserve the right to suspend or terminate accounts that violate these Terms, our Privacy Policy, or our Child Safety Standards.',
    ),
    _TermsSection(
      number: '09',
      title: 'Disclaimer',
      body:
          'StudySync is provided as-is for educational purposes as part of a university course project at Mae Fah Luang University. We make no guarantees about uptime or data permanence.',
    ),
    _TermsSection(
      number: '10',
      title: 'Contact',
      body:
          'For questions about these Terms, contact: vittayasak@mfu.ac.th',
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
          'Terms & Conditions',
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
                        child: _TermsSectionCard(section: section),
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

class _TermsSection {
  final String number;
  final String title;
  final String body;

  const _TermsSection({
    required this.number,
    required this.title,
    required this.body,
  });
}

class _TermsSectionCard extends StatelessWidget {
  final _TermsSection section;

  const _TermsSectionCard({required this.section});

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
        ],
      ),
    );
  }
}

