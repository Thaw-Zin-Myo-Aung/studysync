import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../models/group_model.dart';

class SessionsTab extends StatelessWidget {
  final GroupModel group;
  const SessionsTab({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 20, bottom: 100),
      children: [
        const _SectionHeader(icon: LucideIcons.clock, label: 'UPCOMING SESSION'),
        const SizedBox(height: 12),
        _UpcomingSessionCard(group: group),
        const SizedBox(height: 28),
        const _SectionHeader(icon: LucideIcons.history, label: 'PAST SESSIONS'),
        const SizedBox(height: 12),
        _PastSessionsCard(sessions: group.pastSessions),
      ],
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
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _UpcomingSessionCard extends StatefulWidget {
  final GroupModel group;
  const _UpcomingSessionCard({required this.group});

  @override
  State<_UpcomingSessionCard> createState() => _UpcomingSessionCardState();
}

class _UpcomingSessionCardState extends State<_UpcomingSessionCard> {
  bool _attended = false;

  @override
  Widget build(BuildContext context) {
    final g = widget.group;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.5), width: 1.5),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(20)),
                child: const Text('Upcoming', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.success)),
              ),
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(10)),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(LucideIcons.calendarPlus, size: 18, color: AppColors.primary),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(g.upcomingDate, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 4),
          Text(g.upcomingTimeRange, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          _InfoRow(icon: LucideIcons.mapPin, primary: g.upcomingLocation, secondary: g.upcomingLocationDetail),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: const BoxDecoration(color: AppColors.backgroundBlue, shape: BoxShape.circle),
                child: const Icon(LucideIcons.users, size: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 24,
                width: (g.upcomingAttendees * 16 + 8).toDouble(),
                child: Stack(
                  children: List.generate(g.upcomingAttendees, (i) => _MiniAvatar(
                    label: g.memberInitials.length > i ? g.memberInitials[i] : '?',
                    left: i * 16.0,
                  )),
                ),
              ),
              const SizedBox(width: 8),
              Text('${g.upcomingAttendees}/${g.upcomingTotal} members attending',
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: _attended ? null : () => setState(() => _attended = true),
              style: ElevatedButton.styleFrom(
                backgroundColor: _attended ? const Color(0xFFE8F5E9) : AppColors.backgroundBlue,
                disabledBackgroundColor: const Color(0xFFE8F5E9),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                _attended ? '✓ Attended' : 'Mark as Attended',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                    color: _attended ? AppColors.success : Colors.grey.shade500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String primary;
  final String secondary;
  const _InfoRow({required this.icon, required this.primary, required this.secondary});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36, height: 36,
          decoration: const BoxDecoration(color: AppColors.backgroundBlue, shape: BoxShape.circle),
          child: Icon(icon, size: 16, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(primary, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
            Text(secondary, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
      ],
    );
  }
}

class _MiniAvatar extends StatelessWidget {
  final String label;
  final double left;
  const _MiniAvatar({required this.label, required this.left});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      child: Container(
        width: 24, height: 24,
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Center(
          child: Text(label, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.primary)),
        ),
      ),
    );
  }
}

class _PastSessionsCard extends StatelessWidget {
  final List<PastSession> sessions;
  const _PastSessionsCard({required this.sessions});

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: const Center(
          child: Text('No past sessions yet.', style: TextStyle(fontSize: 13, color: AppColors.textHint)),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: sessions.length,
        separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.border),
        itemBuilder: (context, index) {
          final s = sessions[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.date, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 3),
                      Text('${s.time} • ${s.location}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: s.attended ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(s.attended ? LucideIcons.check : LucideIcons.x,
                          size: 12, color: s.attended ? AppColors.success : Colors.redAccent),
                      const SizedBox(width: 4),
                      Text(
                        s.attended ? 'Attended' : 'Missed',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                            color: s.attended ? AppColors.success : Colors.redAccent),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

