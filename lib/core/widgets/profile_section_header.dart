import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ProfileSectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const ProfileSectionHeader({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textMuted),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 1.2),
        ),
      ],
    );
  }
}

