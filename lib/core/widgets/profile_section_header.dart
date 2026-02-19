import 'package:flutter/material.dart';

class ProfileSectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const ProfileSectionHeader({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF64748B)),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 1.2),
        ),
      ],
    );
  }
}

