import 'package:flutter/foundation.dart';

/// Breakdown of the four weighted sub-scores used by the matching algorithm.
/// schedule (40%) + courses (30%) + goals (20%) + style (10%) = total
@immutable
class CompatibilityScoreModel {
  final double scheduleScore; // 0.0 – 1.0
  final double courseScore;   // 0.0 – 1.0
  final double goalScore;    // 0.0 – 1.0
  final double styleScore;   // 0.0 – 1.0

  const CompatibilityScoreModel({
    required this.scheduleScore,
    required this.courseScore,
    required this.goalScore,
    required this.styleScore,
  });

  /// Weighted total as a percentage (0–100).
  int get totalScore =>
      ((scheduleScore * 0.4 +
            courseScore * 0.3 +
            goalScore * 0.2 +
            styleScore * 0.1) *
          100)
      .round()
      .clamp(0, 100);

  factory CompatibilityScoreModel.fromJson(Map<String, dynamic> json) {
    return CompatibilityScoreModel(
      scheduleScore: (json['scheduleScore'] as num?)?.toDouble() ?? 0,
      courseScore:   (json['courseScore']   as num?)?.toDouble() ?? 0,
      goalScore:    (json['goalScore']    as num?)?.toDouble() ?? 0,
      styleScore:   (json['styleScore']   as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'scheduleScore': scheduleScore,
        'courseScore':   courseScore,
        'goalScore':    goalScore,
        'styleScore':   styleScore,
      };
}

