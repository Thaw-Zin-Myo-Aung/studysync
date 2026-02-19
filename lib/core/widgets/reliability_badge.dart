import 'package:flutter/material.dart';

class ReliabilityBadge extends StatelessWidget {
  final double score;

  const ReliabilityBadge({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Reliability Score: ${score.toInt()}%',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2563EB),
            ),
          ),
        ],
      ),
    );
  }
}

