import 'package:flutter/material.dart';
import 'package:studysync/core/widgets/reliability_ring.dart';

class ProfileHeaderCard extends StatelessWidget {
  final String name;
  final String major;
  final String year;
  final double reliabilityScore;
  final String reliabilityLabel;

  const ProfileHeaderCard({
    super.key,
    required this.name,
    required this.major,
    required this.year,
    required this.reliabilityScore,
    required this.reliabilityLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFFE2E8F0),
                  child: Icon(Icons.person, size: 40, color: Color(0xFF94A3B8)),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.edit, size: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.school_outlined, size: 14, color: Color(0xFF64748B)),
                const SizedBox(width: 8),
                Text('$major • $year', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
              ],
            ),
            const SizedBox(height: 20),
            ReliabilityRing(score: reliabilityScore, label: reliabilityLabel),
          ],
        ),
      ),
    );
  }
}

