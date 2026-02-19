import 'package:flutter/material.dart';
import 'package:studysync/core/widgets/session_info_row.dart';

class UpcomingSessionCard extends StatelessWidget {
  final String groupName;
  final String timeUntil;
  final String location;
  final String timeRange;
  final int attendeeCount;
  final bool canCheckIn;

  const UpcomingSessionCard({
    super.key,
    required this.groupName,
    required this.timeUntil,
    required this.location,
    required this.timeRange,
    required this.attendeeCount,
    required this.canCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(timeUntil, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFF97316))),
                ),
                CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  radius: 16,
                  child: Icon(Icons.explore_outlined, color: Colors.grey.shade500, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(groupName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 12),
            SessionInfoRow(icon: Icons.location_on_outlined, text: location),
            const SizedBox(height: 6),
            SessionInfoRow(icon: Icons.access_time_outlined, text: timeRange),
            const SizedBox(height: 6),
            SessionInfoRow(icon: Icons.group_outlined, text: '$attendeeCount Attendees confirmed'),
            const SizedBox(height: 16),
            if (canCheckIn)
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: const Text('Check-in', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Check-in  (Opens 15m before)',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

