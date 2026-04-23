import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/session_model.dart';
import '../../../providers/sessions_provider.dart';
import '../../../providers/auth_provider.dart';
import 'upcoming_session_card.dart';

class UpcomingSessionsSection extends ConsumerStatefulWidget {
  final List<SessionModel> sessions;

  const UpcomingSessionsSection({super.key, required this.sessions});

  @override
  ConsumerState<UpcomingSessionsSection> createState() =>
      _UpcomingSessionsSectionState();
}

class _UpcomingSessionsSectionState
    extends ConsumerState<UpcomingSessionsSection> {
  int _currentPage = 0;
  // Track which sessions the user has already checked in to this session
  final Set<String> _checkedIn = {};
  final Set<String> _loading   = {};

  DateTime? _parseSessionStart(SessionModel s) {
    try {
      final date = DateFormat('EEE, MMM d yyyy').parseStrict(s.date);
      final startLabel = s.time.split('-').first.trim();
      final startTime = DateFormat('h:mm a').parseStrict(startLabel);
      return DateTime(
        date.year,
        date.month,
        date.day,
        startTime.hour,
        startTime.minute,
      );
    } catch (_) {
      try {
        final date = DateFormat('EEE, MMM d yyyy').parseStrict(s.date);
        return DateTime(date.year, date.month, date.day);
      } catch (_) {
        return null;
      }
    }
  }

  bool _canCheckIn(SessionModel s) {
    final start = _parseSessionStart(s);
    if (start == null) return false;
    final now = DateTime.now();
    return now.isAfter(start) || now.isAtSameMomentAs(start);
  }

  Future<void> _checkIn(SessionModel s) async {
    if (_checkedIn.contains(s.sessionId) || _loading.contains(s.sessionId)) {
      return;
    }
    if (!_canCheckIn(s)) return;
    setState(() => _loading.add(s.sessionId));
    try {
      await markGroupSessionAttendance(
        ref,
        groupId:   s.groupId,
        sessionId: s.sessionId,
        attended:  true,
      );
      await ref.read(authProvider.notifier).refreshUser();
      ref.invalidate(upcomingSessionsProvider);
      if (mounted) {
        setState(() {
          _checkedIn.add(s.sessionId);
          _currentPage = 0;
        });
      }
    } finally {
      if (mounted) setState(() => _loading.remove(s.sessionId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleSessions = widget.sessions
        .where((s) => !_checkedIn.contains(s.sessionId))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming Sessions',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 12),

        // ── Empty state ────────────────────────────────────────
        if (visibleSessions.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(LucideIcons.calendarOff,
                      size: 26, color: AppColors.primary),
                ),
                const SizedBox(height: 14),
                const Text('No upcoming sessions',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 6),
                const Text('Sessions scheduled in your groups\nwill appear here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textMuted, height: 1.5)),
              ],
            ),
          )
        else ...[
          // ── Carousel ───────────────────────────────────────────
          SizedBox(
            height: 236,
            child: PageView.builder(
              itemCount: visibleSessions.length,
              padEnds: false,
              physics: const PageScrollPhysics(),
              controller: PageController(viewportFraction: 0.88),
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (_, i) {
                final s = visibleSessions[i];
                final checked = _checkedIn.contains(s.sessionId);
                final loading = _loading.contains(s.sessionId);
                final canCheckIn = _canCheckIn(s);
                return Padding(
                  padding: const EdgeInsets.only(
                      top: 4, right: 6, bottom: 6, left: 6),
                  child: UpcomingSessionCard(
                    groupName:    s.title.isNotEmpty ? s.title : s.date,
                    timeUntil:    s.date,
                    location:     s.location,
                    timeRange:    s.time,
                    attendeeCount: 0,
                    canCheckIn:   canCheckIn,
                    isCheckedIn:  checked,
                    isLoading:    loading,
                    onCheckIn:    checked ? null : () => _checkIn(s),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          // Dot indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(visibleSessions.length, (i) {
              final active = i == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active ? AppColors.primary : AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}
