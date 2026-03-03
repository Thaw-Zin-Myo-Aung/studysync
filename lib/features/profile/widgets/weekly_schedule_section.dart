import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:studysync/core/constants/availability_constants.dart';
import 'package:studysync/core/theme/app_colors.dart';
import 'package:studysync/core/widgets/availability_grid.dart';
import 'package:studysync/core/widgets/profile_section_header.dart';

class WeeklyScheduleSection extends StatelessWidget {
  final Map<String, List<String>> availability;

  const WeeklyScheduleSection({super.key, required this.availability});

  @override
  Widget build(BuildContext context) {
    final grid = availabilityMapToGrid(availability);
    final hasAny = grid.any((day) => day.any((v) => v));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ProfileSectionHeader(icon: LucideIcons.calendar, title: 'My Schedule'),
        const SizedBox(height: 12),
        if (hasAny)
          AvailabilityGrid(availability: grid, readOnly: true)
        else
          Card(
            color: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Center(
                child: Text(
                  'No availability set yet.',
                  style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
