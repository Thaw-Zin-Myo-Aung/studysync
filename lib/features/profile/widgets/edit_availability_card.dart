import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:studysync/features/onboarding/widgets/profile_setup_step3.dart';
import 'package:studysync/features/profile/widgets/edit_section_card.dart';

class EditAvailabilityCard extends StatelessWidget {
  final List<List<bool>> availability;
  final void Function(int dayIndex, int slotIndex) onToggle;

  const EditAvailabilityCard({
    super.key,
    required this.availability,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return EditSectionCard(
      icon: LucideIcons.calendarDays,
      title: 'Availability',
      children: [
        ProfileSetupStep3(
          availability: availability,
          onToggle: onToggle,
        ),
      ],
    );
  }
}


