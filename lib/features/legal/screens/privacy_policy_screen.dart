import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const List<_PolicySection> _sections = [
    _PolicySection(
      number: '01',
      title: 'Information We Collect',
      body:
          'We collect only the minimum data required to provide StudySync\'s core features. This includes information you provide such as your name, email address, major, year, enrolled courses, weekly availability, academic goals, learning style, optional profile picture, discussion posts, and attendance self-reports. We also collect limited automatic data like Firebase authentication tokens, device push notification tokens (FCM), anonymized analytics and crash data, and timestamps for created or updated records. We do not collect precise location, camera or microphone data, contacts, phone numbers, browsing history, payment information, or biometric data.',
    ),
    _PolicySection(
      number: '02',
      title: 'How We Use Your Information',
      body:
          'We use your data only to operate StudySync and improve the service. This includes compatibility matching based on schedule overlap (40%), shared courses (30%), academic goal similarity (20%), and learning style (10%); displaying your profile and reliability score; managing groups and sessions; supporting discussions; sending session reminders and optional notifications; and calculating reliability as sessions attended divided by sessions scheduled. We also use anonymized crash and usage data to improve stability. Under Thailand\'s PDPA, processing is based on contractual necessity, legitimate interests in security and improvement, and consent for optional features like profile photos and notifications.',
    ),
    _PolicySection(
      number: '03',
      title: 'Data Sharing & Third Parties',
      body:
          'We do not sell, rent, or trade your personal data. We use Google Firebase services for authentication, storage, messaging, analytics, and crash reporting, acting as a data processor on our behalf. Some profile information and reliability scores are visible to other StudySync users for matching, and discussion posts are visible to group members. Attendance status is visible to group admins. Your email address is never shown to other users. We may disclose data if required by law, and will notify you unless legally prohibited.',
    ),
    _PolicySection(
      number: '04',
      title: 'Data Retention',
      body:
          'We keep account data while your account is active. Group and session data is retained for 12 months after a group becomes inactive, then deleted. Discussion posts are retained while the group exists. Attendance records and reliability scores remain until account deletion. Anonymized analytics data is retained for up to 14 months by default. When you delete your account, personal data is removed within 30 days, while aggregated, non-identifiable data may be retained for statistics.',
    ),
    _PolicySection(
      number: '05',
      title: 'Your Rights Under PDPA',
      body:
          'You have the right to access your data, correct inaccuracies, request deletion, obtain a portable copy, restrict processing, object to processing based on legitimate interests, and withdraw consent for optional features. To exercise these rights, contact us at 6731503088@lamduan.mfu.ac.th. We respond within 30 days of a verified request. Account deletion requests are processed within 30 days.',
    ),
    _PolicySection(
      number: '06',
      title: 'Data Security',
      body:
          'We use Firebase Security Rules to limit access, encrypt data in transit via HTTPS/TLS, and rely on Firebase Authentication to securely manage passwords. The app is signed with a secured keystore and avoids hardcoded secrets. While we take reasonable measures, no system is completely secure. If a breach poses risk to your rights, we will notify affected users and authorities as required by law.',
    ),
    _PolicySection(
      number: '07',
      title: 'Children\'s Privacy',
      body:
          'StudySync is intended for university students aged 18 and older. We do not knowingly collect data from anyone under 18. If you believe a minor has provided information, contact us at 6731503088@lamduan.mfu.ac.th and we will delete it promptly.',
    ),
    _PolicySection(
      number: '08',
      title: 'Push Notifications',
      body:
          'We use Firebase Cloud Messaging to send study session reminders, group discussion updates (optional, enabled by default), and match request notifications. You can disable notifications in your device settings at any time. Disabling notifications does not affect other app features. We do not use notifications for marketing or promotions.',
    ),
    _PolicySection(
      number: '09',
      title: 'Changes to This Policy',
      body:
          'We may update this policy to reflect feature or legal changes. When we make material changes, we update the last updated date and notify users with a push notification and in-app notice. Continued use after the effective date indicates acceptance. If you do not agree, you may request account deletion.',
    ),
    _PolicySection(
      number: '10',
      title: 'Contact Us',
      body:
          'If you have questions or requests, contact the data controller: Thaw Zin Myo Aung, Developer of StudySync (Mobile Application Development Course 1305216), Mae Fah Luang University. Email: 6731503088@lamduan.mfu.ac.th. Address: Mae Fah Luang University, 333 Moo 1, Thasud, Mueang, Chiang Rai 57100, Thailand. Response time: within 30 days of a verified request.',
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
          'Privacy Policy',
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
                  _PolicyIntroCard(),
                  const SizedBox(height: 16),
                  ..._sections.map((section) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _PolicySectionCard(section: section),
                      )),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Last updated: April 2026 - StudySync - Mae Fah Luang University',
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

class _PolicyIntroCard extends StatelessWidget {
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
      child: const Text(
        'StudySync ("we," "our," or "us") is a mobile application built by Thaw Zin Myo Aung (Student ID: 6731503088) at Mae Fah Luang University as part of the Mobile Application Development course (1305216). StudySync helps students find compatible study partners, form study groups, coordinate sessions, and track attendance reliability. This policy explains what data we collect, how we use and protect it, and your rights under Thailand\'s PDPA. By using StudySync, you agree to these practices.',
        style: TextStyle(
          fontSize: 13,
          height: 1.6,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _PolicySection {
  final String number;
  final String title;
  final String body;

  const _PolicySection({
    required this.number,
    required this.title,
    required this.body,
  });
}

class _PolicySectionCard extends StatelessWidget {
  final _PolicySection section;

  const _PolicySectionCard({required this.section});

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

