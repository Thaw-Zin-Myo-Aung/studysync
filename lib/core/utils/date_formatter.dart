import 'package:intl/intl.dart';

/// Formats an ISO-8601 timestamp string into a human-friendly label.
/// Examples:
///   < 1 min  → "Just now"
///   < 1 hr   → "5m ago"
///   today    → "2:30 PM"
///   this yr  → "2:30 PM · Mon, Mar 4"
///   older    → "2:30 PM · Mar 4, 2024"
String formatTimestamp(String timestamp) {
  if (timestamp.isEmpty) return 'Just now';
  try {
    final dt  = DateTime.parse(timestamp).toLocal();
    final now = DateTime.now();
    final diff = now.difference(dt);

    final timeStr = DateFormat('h:mm a').format(dt);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24 && dt.day == now.day) return timeStr;

    final dayStr = dt.year == now.year
        ? DateFormat('EEE, MMM d').format(dt)
        : DateFormat('MMM d, yyyy').format(dt);
    return '$timeStr · $dayStr';
  } catch (_) {
    return timestamp;
  }
}

