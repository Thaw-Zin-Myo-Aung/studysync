import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/session_model.dart';
import '../../../models/study_group_model.dart';
import '../../../providers/sessions_provider.dart';

class SessionsTab extends ConsumerWidget {
  final StudyGroupModel group;
  const SessionsTab({super.key, required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(groupSessionsProvider(group.groupId));

    return sessionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error loading sessions')),
      data: (sessions) {
        final upcoming = sessions
            .where((s) => s.status == 'scheduled')
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));
        final past = sessions
            .where((s) => s.status != 'scheduled')
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));

        return RefreshIndicator(
          onRefresh: () async =>
              ref.invalidate(groupSessionsProvider(group.groupId)),
          child: ListView(
            padding: const EdgeInsets.only(top: 20, bottom: 100),
            children: [
              const _SectionHeader(
                  icon: LucideIcons.clock, label: 'UPCOMING SESSIONS'),
              const SizedBox(height: 12),
              if (upcoming.isEmpty)
                _EmptyCard(message: 'No upcoming sessions scheduled',
                    sub: 'Tap the + button to schedule a new session.')
              else
                ...upcoming.map((s) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _UpcomingSessionCard(
                          session: s, group: group),
                    )),
              const SizedBox(height: 28),
              const _SectionHeader(
                  icon: LucideIcons.history, label: 'PAST SESSIONS'),
              const SizedBox(height: 12),
              if (past.isEmpty)
                const _EmptyCard(
                    message: 'No past sessions yet.', sub: '')
              else
                ...past.map((s) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _PastSessionTile(session: s),
                    )),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SectionHeader({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: AppColors.textSecondary)),
      ],
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String message;
  final String sub;
  const _EmptyCard({required this.message, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(LucideIcons.calendarX, size: 36, color: AppColors.textHint),
          const SizedBox(height: 10),
          Text(message,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
          if (sub.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(sub,
                style:
                    const TextStyle(fontSize: 12, color: AppColors.textHint),
                textAlign: TextAlign.center),
          ],
        ],
      ),
    );
  }
}

class _UpcomingSessionCard extends ConsumerStatefulWidget {
  final SessionModel session;
  final StudyGroupModel group;
  const _UpcomingSessionCard(
      {required this.session, required this.group});

  @override
  ConsumerState<_UpcomingSessionCard> createState() =>
      _UpcomingSessionCardState();
}

class _UpcomingSessionCardState
    extends ConsumerState<_UpcomingSessionCard> {
  bool _attended = false;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.session;
    final g = widget.group;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.5), width: 1.5),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(20)),
                child: const Text('Upcoming',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success)),
              ),
              Text(s.time,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 14),
          Text(s.date,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          const SizedBox(height: 16),
          _InfoRow(
              icon: LucideIcons.mapPin,
              primary: s.location,
              secondary: ''),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                    color: AppColors.backgroundBlue,
                    shape: BoxShape.circle),
                child: const Icon(LucideIcons.users,
                    size: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 10),
              Text('${g.memberIds.length}/${g.maxMembers} members',
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: (_attended || _loading)
                  ? null
                  : () => _markAttendance(),
              style: ElevatedButton.styleFrom(
                backgroundColor: _attended
                    ? const Color(0xFFE8F5E9)
                    : AppColors.backgroundBlue,
                disabledBackgroundColor: const Color(0xFFE8F5E9),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(
                      _attended ? '✓ Attended' : 'Mark as Attended',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _attended
                              ? AppColors.success
                              : Colors.grey.shade500),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _markAttendance() async {
    setState(() => _loading = true);
    try {
      await markGroupSessionAttendance(
        ref,
        groupId:   widget.group.groupId,
        sessionId: widget.session.sessionId,
        attended:  true,
      );
      if (mounted) setState(() { _attended = true; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String primary;
  final String secondary;
  const _InfoRow(
      {required this.icon, required this.primary, required this.secondary});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
              color: AppColors.backgroundBlue, shape: BoxShape.circle),
          child: Icon(icon, size: 16, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(primary,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87)),
            if (secondary.isNotEmpty)
              Text(secondary,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
      ],
    );
  }
}

class _PastSessionTile extends StatelessWidget {
  final SessionModel session;
  const _PastSessionTile({required this.session});

  @override
  Widget build(BuildContext context) {
    final isCancelled = session.status == 'cancelled';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCancelled
                  ? AppColors.errorLight
                  : AppColors.successLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCancelled ? LucideIcons.x : LucideIcons.check,
              size: 18,
              color: isCancelled ? AppColors.error : AppColors.success,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(session.date,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87)),
                Text('${session.time} · ${session.location}',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isCancelled
                  ? AppColors.errorLight
                  : AppColors.successLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isCancelled ? 'Cancelled' : 'Completed',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isCancelled ? AppColors.error : AppColors.success,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
