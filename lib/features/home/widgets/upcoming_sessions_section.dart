import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'upcoming_session_card.dart';

class UpcomingSessionsSection extends StatelessWidget {
  final VoidCallback onSeeAll;

  const UpcomingSessionsSection({super.key, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final sessions = [
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Upcoming Sessions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            TextButton(
              onPressed: onSeeAll,
              child: const Text(
                'See all',
                style: TextStyle(fontSize: 13, color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 260,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: 16),
            itemCount: sessions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) => UpcomingSessionCard(
              groupName: sessions[i]['groupName'] as String,
              timeUntil: sessions[i]['timeUntil'] as String,
              location: sessions[i]['location'] as String,
              timeRange: sessions[i]['timeRange'] as String,
              attendeeCount: sessions[i]['attendeeCount'] as int,
              canCheckIn: sessions[i]['canCheckIn'] as bool,
            ),
          ),
        ),
      ],
    );
  }
}

