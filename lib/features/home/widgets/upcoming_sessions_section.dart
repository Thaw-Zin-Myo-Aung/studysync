import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'upcoming_session_card.dart';

class UpcomingSessionsSection extends StatefulWidget {
  final VoidCallback onSeeAll;

  const UpcomingSessionsSection({super.key, required this.onSeeAll});

  @override
  State<UpcomingSessionsSection> createState() => _UpcomingSessionsSectionState();
}

class _UpcomingSessionsSectionState extends State<UpcomingSessionsSection> {
  int _currentPage = 0;

  final List<Map<String, dynamic>> sessions = [
    {
      'groupName': 'Math Study Group',
      'timeUntil': 'In 2 hours',
      'location': 'Library 3F, Room 302',
      'timeRange': '14:00 - 16:00 PM',
      'attendeeCount': 3,
      'canCheckIn': false,
    },
    {
      'groupName': 'Web Dev Finals',
      'timeUntil': 'Tomorrow',
      'location': 'Online',
      'timeRange': '2:00 - 4:00 PM',
      'attendeeCount': 3,
      'canCheckIn': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Upcoming Sessions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            TextButton(
              onPressed: widget.onSeeAll,
              child: const Text('See all', style: TextStyle(fontSize: 13, color: AppColors.primary)),
            ),
          ],
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
              child: UpcomingSessionCard(
                groupName: sessions[i]['groupName'] as String,
                timeUntil: sessions[i]['timeUntil'] as String,
                location: sessions[i]['location'] as String,
                timeRange: sessions[i]['timeRange'] as String,
                attendeeCount: sessions[i]['attendeeCount'] as int,
                canCheckIn: sessions[i]['canCheckIn'] as bool,
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
