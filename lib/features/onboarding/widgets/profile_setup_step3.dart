import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'availability_cell.dart';

const _teal = Color(0xFF0D9488);

class ProfileSetupStep3 extends StatelessWidget {
  final List<List<bool>> availability;
  final void Function(int dayIndex, int slotIndex) onToggle;

  const ProfileSetupStep3({
    super.key,
    required this.availability,
    required this.onToggle,
  });

  static const List<String> _days  = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const List<String> _slots = ['8AM', '10AM', '12PM', '2PM', '4PM', '7PM'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Helper text ──────────────────────────────────────
        const Text(
          'Tap time slots to mark when you are available to study.',
          style: TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.5),
        ),
        const SizedBox(height: 20),

        // ── Grid container ───────────────────────────────────
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black.withValues(alpha: 0.06))],
          ),
          child: Column(
            children: [
              // Day header row
              Row(children: [
                const SizedBox(width: 36),
                ...List.generate(7, (d) => Expanded(
                  child: Text(_days[d],
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                          color: AppColors.textMuted),
                      textAlign: TextAlign.center),
                )),
              ]),
              const SizedBox(height: 6),

              // 6 time-slot rows
              ...List.generate(6, (s) => Padding(
                padding: EdgeInsets.only(bottom: s < 5 ? 4.0 : 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Time label
                    SizedBox(
                      width: 36,
                      child: Text(_slots[s],
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500,
                              color: AppColors.textHint)),
                    ),
                    // 7 cells
                    ...List.generate(7, (d) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: AvailabilityCell(
                          isSelected: availability[d][s],
                          onTap: () => onToggle(d, s),
                        ),
                      ),
                    )),
                  ],
                ),
              )),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── Legend ───────────────────────────────────────────
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 16, height: 16,
              decoration: BoxDecoration(color: AppColors.scheduleFreeBg,
                  borderRadius: BorderRadius.circular(4))),
          const SizedBox(width: 6),
          const Text('Unavailable', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(width: 20),
          Container(width: 16, height: 16,
              decoration: BoxDecoration(color: _teal,
                  borderRadius: BorderRadius.circular(4))),
          const SizedBox(width: 6),
          const Text('Available to Study', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
        ]),
        const SizedBox(height: 8),
      ],
    );
  }
}

