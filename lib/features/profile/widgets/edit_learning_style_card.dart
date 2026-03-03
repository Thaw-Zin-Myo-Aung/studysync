import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:studysync/features/onboarding/widgets/profile_setup_step4.dart';
import 'package:studysync/features/profile/widgets/edit_section_card.dart';

class EditLearningStyleCard extends StatelessWidget {
  final String selectedStyle;
  final ValueChanged<String> onStyleChanged;

  const EditLearningStyleCard({
    super.key,
    required this.selectedStyle,
    required this.onStyleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return EditSectionCard(
      icon: LucideIcons.zap,
      title: 'Learning Style',
      children: [
        ProfileSetupStep4(
          selectedStyle: selectedStyle,
          onStyleChanged: onStyleChanged,
        ),
      ],
    );
  }
}


