import 'package:flutter/material.dart';

class ScheduleMatchRow extends StatelessWidget {
  final String scheduleText;
  final String subtitle;

  const ScheduleMatchRow({super.key, required this.scheduleText, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF16A34A)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(scheduleText, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF16A34A))),
                Text(subtitle, style: TextStyle(fontSize: 11, color: const Color(0xFF16A34A).withValues(alpha: 0.7))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

