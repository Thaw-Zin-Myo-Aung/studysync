import 'package:flutter/material.dart';
import 'package:studysync/core/widgets/reliability_badge.dart';

class HomeHeaderCard extends StatelessWidget {
  final String userName;
  final double reliabilityScore;
  final VoidCallback onNotificationTap;

  const HomeHeaderCard({super.key, required this.userName, required this.reliabilityScore, required this.onNotificationTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFFDBEAFE),
                      child: Icon(Icons.person, color: Color(0xFF2563EB)),
                    ),
                    Positioned(
                      bottom: 0,
                      right: -2,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xFF22C55E),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back,', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(userName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: onNotificationTap),
                    Positioned(
                      top: 10,
                      right: 12,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            ReliabilityBadge(score: reliabilityScore),
          ],
        ),
      ),
    );
  }
}

