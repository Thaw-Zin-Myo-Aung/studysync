import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/availability_grid.dart';

class ProfileSetupStep3 extends StatelessWidget {
  /// [dayIndex][slotIndex] grid — size must be
  /// [kAvailabilityDayCount × kAvailabilitySlotCount].
  final List<List<bool>> availability;
  final void Function(int dayIndex, int slotIndex) onToggle;

  const ProfileSetupStep3({
    super.key,
    required this.availability,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tap time slots to mark when you are available to study.',
          style: TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.5),
        ),
        const SizedBox(height: 20),
        AvailabilityGrid(
          availability: availability,
          onToggle: onToggle,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

