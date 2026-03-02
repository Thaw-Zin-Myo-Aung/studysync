import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

const _teal = Color(0xFF0D9488);

class AvailabilityCell extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const AvailabilityCell({
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        width: 38,
        height: 34,
        decoration: BoxDecoration(
          color: isSelected ? _teal : AppColors.scheduleFreeBg,
          borderRadius: BorderRadius.circular(7),
        ),
      ),
    );
  }
}

