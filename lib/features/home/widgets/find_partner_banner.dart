import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

class FindPartnerBanner extends StatelessWidget {
  final String courseName;
  final VoidCallback onFindPartner;

  const FindPartnerBanner({super.key, required this.courseName, required this.onFindPartner});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0x33FFFFFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(LucideIcons.search, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 16),
          const Text('Need a study buddy?', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 13, color: Colors.white),
              children: [
                const TextSpan(text: 'Find a partner for '),
                TextSpan(text: courseName, style: const TextStyle(fontWeight: FontWeight.bold)),
                const TextSpan(text: ' and boost your activity'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onFindPartner,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surface,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Find Partner', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}

