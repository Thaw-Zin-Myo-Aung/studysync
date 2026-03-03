import 'package:flutter/material.dart';
import '../../core/constants/availability_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../features/onboarding/widgets/availability_cell.dart';

/// Reusable availability grid widget — works in two modes:
///
/// **Interactive** (`readOnly: false`, default)
///   — renders tappable [AvailabilityCell] tiles.
///   — requires [onToggle] callback.
///
/// **Read-only** (`readOnly: true`)
///   — renders plain coloured containers (no tap targets).
///   — used on the Profile screen to display stored availability.
///
/// Both modes use [kAvailabilityDays], [kAvailabilitySlots], and
/// [kAvailabilityTeal] from [availability_constants.dart] — the only
/// place these values are defined.
class AvailabilityGrid extends StatelessWidget {
  /// [dayIndex][slotIndex] — sized [kAvailabilityDayCount × kAvailabilitySlotCount].
  final List<List<bool>> availability;

  /// Called when a cell is tapped. Required when [readOnly] is false.
  final void Function(int dayIndex, int slotIndex)? onToggle;

  /// When true the grid is display-only (no tap). Defaults to false.
  final bool readOnly;

  const AvailabilityGrid({
    super.key,
    required this.availability,
    this.onToggle,
    this.readOnly = false,
  }) : assert(readOnly || onToggle != null,
            'onToggle is required when readOnly is false');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(blurRadius: 8, color: Colors.black.withValues(alpha: 0.06))
        ],
      ),
      child: Column(
        children: [
          // ── Day header row ──────────────────────────────────
          Row(children: [
            const SizedBox(width: 40), // aligns with time labels
            ...List.generate(kAvailabilityDayCount, (d) => Expanded(
              child: Text(kAvailabilityDayLabels[d],
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMuted),
                  textAlign: TextAlign.center),
            )),
          ]),
          const SizedBox(height: 6),

          // ── Slot rows ───────────────────────────────────────
          ...List.generate(kAvailabilitySlotCount, (s) => Padding(
            padding: EdgeInsets.only(
                bottom: s < kAvailabilitySlotCount - 1 ? 4.0 : 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Time label
                SizedBox(
                  width: 40,
                  child: Text(kAvailabilitySlotLabels[s],
                      style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textHint)),
                ),
                // Day cells
                ...List.generate(kAvailabilityDayCount, (d) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: readOnly
                        ? _readOnlyCell(availability[d][s])
                        : AvailabilityCell(
                            isSelected: availability[d][s],
                            onTap: () => onToggle!(d, s),
                          ),
                  ),
                )),
              ],
            ),
          )),

          const SizedBox(height: 12),

          // ── Legend ──────────────────────────────────────────
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _dot(AppColors.scheduleFreeBg),
            const SizedBox(width: 5),
            const Text('Unavailable',
                style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
            const SizedBox(width: 18),
            _dot(kAvailabilityTeal),
            const SizedBox(width: 5),
            const Text('Available to Study',
                style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
          ]),
        ],
      ),
    );
  }

  Widget _readOnlyCell(bool selected) => Container(
    height: 28,
    decoration: BoxDecoration(
      color: selected ? kAvailabilityTeal : AppColors.scheduleFreeBg,
      borderRadius: BorderRadius.circular(5),
    ),
  );

  Widget _dot(Color color) => Container(
    width: 12, height: 12,
    decoration:
        BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
  );
}

