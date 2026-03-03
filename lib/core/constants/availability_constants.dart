import 'package:flutter/material.dart';

/// Single source of truth for all availability day/slot data.
/// Import this wherever the schedule grid is used — do NOT re-declare
/// these values locally in any screen or widget.

// ── Colour ────────────────────────────────────────────────────────────────
/// Teal used for "available" cells across the whole app.
const Color kAvailabilityTeal = Color(0xFF0D9488);

// ── Days ──────────────────────────────────────────────────────────────────
/// Firestore keys (lowercase full names).
const List<String> kAvailabilityDays = [
  'monday', 'tuesday', 'wednesday', 'thursday',
  'friday', 'saturday', 'sunday',
];

/// Short display labels shown above grid columns.
const List<String> kAvailabilityDayLabels = [
  'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
];

// ── Slots — extended 8AM → 12AM (midnight) ───────────────────────────────
/// Firestore / storage keys (24-hour HH:mm strings).
const List<String> kAvailabilitySlots = [
  '08:00', '10:00', '12:00', '14:00',
  '16:00', '18:00', '20:00', '22:00', '00:00',
];

/// Human-readable labels shown beside grid rows.
const List<String> kAvailabilitySlotLabels = [
  '8AM', '10AM', '12PM', '2PM',
  '4PM', '6PM', '8PM', '10PM', '12AM',
];

// ── Derived lengths ───────────────────────────────────────────────────────
const int kAvailabilityDayCount  = 7;   // always 7
const int kAvailabilitySlotCount = 9;   // extended from 6 → 9

// ── Helpers ───────────────────────────────────────────────────────────────

/// Convert a raw [Map<String, List<String>>] from Firestore/UserModel into a
/// [dayCount × slotCount] bool grid using the canonical constants.
List<List<bool>> availabilityMapToGrid(Map<String, List<String>> map) {
  return List.generate(kAvailabilityDayCount, (d) =>
      List.generate(kAvailabilitySlotCount, (s) =>
          (map[kAvailabilityDays[d]] ?? []).contains(kAvailabilitySlots[s])));
}

/// Convert a bool grid back to the [Map<String, List<String>>] format
/// stored in Firestore.  Days with no selected slots are omitted.
Map<String, List<String>> availabilityGridToMap(List<List<bool>> grid) {
  final result = <String, List<String>>{};
  for (int d = 0; d < kAvailabilityDayCount; d++) {
    final selected = <String>[];
    for (int s = 0; s < kAvailabilitySlotCount; s++) {
      if (grid[d][s]) selected.add(kAvailabilitySlots[s]);
    }
    if (selected.isNotEmpty) result[kAvailabilityDays[d]] = selected;
  }
  return result;
}

