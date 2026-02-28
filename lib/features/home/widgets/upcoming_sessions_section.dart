import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/route_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../groups/models/group_model.dart';
import 'upcoming_session_card.dart';

class UpcomingSessionsSection extends StatefulWidget {
  const UpcomingSessionsSection({super.key});

  @override
  State<UpcomingSessionsSection> createState() =>
      _UpcomingSessionsSectionState();
}

class _UpcomingSessionsSectionState extends State<UpcomingSessionsSection> {
  int _currentPage = 0;

  /// Derive session cards directly from mockGroups — single source of truth.
  /// When backend is added, replace mockGroups with the API response here only.
  List<Map<String, dynamic>> get _sessions => mockGroups.map((g) => {
        'groupId': g.id,
        'groupName': g.name,
        'timeUntil': g.nextSession,
        'location': g.upcomingLocation,
        'locationDetail': g.upcomingLocationDetail,
        'timeRange': g.upcomingTimeRange,
        'attendeeCount': g.upcomingAttendees,
        'canCheckIn': false,
      }).toList();

  @override
  Widget build(BuildContext context) {
    final sessions = _sessions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        const Text(
          'Upcoming Sessions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 12),
        // PageView carousel
        SizedBox(
          height: 270,
          child: PageView.builder(
            itemCount: sessions.length,
            padEnds: false,
            controller: PageController(viewportFraction: 0.88),
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () => context.push(
                  RouteConstants.groupDetail.replaceFirst(
                      ':groupId', sessions[i]['groupId'] as String),
                ),
                child: UpcomingSessionCard(
                  groupName: sessions[i]['groupName'] as String,
                  timeUntil: sessions[i]['timeUntil'] as String,
                  location:
                      '${sessions[i]['location']}, ${sessions[i]['locationDetail']}',
                  timeRange: sessions[i]['timeRange'] as String,
                  attendeeCount: sessions[i]['attendeeCount'] as int,
                  canCheckIn: sessions[i]['canCheckIn'] as bool,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(sessions.length, (index) {
            final isActive = index == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}
