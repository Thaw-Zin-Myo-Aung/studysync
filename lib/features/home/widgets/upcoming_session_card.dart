import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:studysync/core/theme/app_colors.dart';
import 'package:studysync/core/widgets/session_info_row.dart';

class UpcomingSessionCard extends StatelessWidget {
  final String groupName;
  final String timeUntil;
  final String location;
  final String timeRange;
  final int attendeeCount;
  final bool canCheckIn;
  final bool isCheckedIn;
  final bool isLoading;
  final VoidCallback? onCheckIn;

  const UpcomingSessionCard({
    super.key,
    required this.groupName,
    required this.timeUntil,
    required this.location,
    required this.timeRange,
    required this.attendeeCount,
    required this.canCheckIn,
    this.isCheckedIn = false,
    this.isLoading = false,
    this.onCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.warningLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(timeUntil,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.warning)),
                ),
                CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  radius: 16,
                  child: Icon(LucideIcons.compass,
                      color: Colors.grey.shade500, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(groupName,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 10),
            SessionInfoRow(icon: LucideIcons.mapPin, text: location),
            const SizedBox(height: 10),
            SessionInfoRow(icon: LucideIcons.clock, text: timeRange),
            const SizedBox(height: 10),
            SessionInfoRow(
                icon: LucideIcons.users,
                text: '$attendeeCount Attendees confirmed'),
            const SizedBox(height: 10),
            // ── Check-in button ─────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 38,
              child: isCheckedIn
                  ? Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LucideIcons.circleCheck,
                              size: 16, color: AppColors.success),
                          SizedBox(width: 6),
                          Text('Attended',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.success)),
                        ],
                      ),
                    )
                  : ElevatedButton(
                      onPressed: isLoading ? null : onCheckIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor:
                            AppColors.primary.withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Text('Mark as Attended',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13)),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
