import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import 'learner_type_card.dart';

class ProfileSetupStep4 extends StatelessWidget {
  final String selectedStyle;
  final ValueChanged<String> onStyleChanged;

  const ProfileSetupStep4({
    super.key,
    required this.selectedStyle,
    required this.onStyleChanged,
  });

  static const _styles = [
    (
      key: 'visual',
      icon: LucideIcons.eye,
      title: 'Visual Learner',
      description: 'I learn best through diagrams, charts, and written notes.',
    ),
    (
      key: 'auditory',
      icon: LucideIcons.headphones,
      title: 'Auditory Learner',
      description: 'I learn best by listening and discussing out loud.',
    ),
    (
      key: 'hands-on',
      icon: LucideIcons.hammer,
      title: 'Hands-On Learner',
      description: 'I learn best by doing, practicing, and problem-solving.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'This helps us match you with compatible study partners.',
          style: TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.5),
        ),
        const SizedBox(height: 24),
        ...List.generate(_styles.length, (i) => Padding(
          padding: EdgeInsets.only(bottom: i < _styles.length - 1 ? 14.0 : 0),
          child: LearnerTypeCard(
            icon: _styles[i].icon,
            title: _styles[i].title,
            description: _styles[i].description,
            isSelected: selectedStyle == _styles[i].key,
            onTap: () => onStyleChanged(_styles[i].key),
          ),
        )),
        const SizedBox(height: 8),
      ],
    );
  }
}

