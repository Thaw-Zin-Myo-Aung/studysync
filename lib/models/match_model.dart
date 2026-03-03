import 'package:flutter/foundation.dart';

@immutable
class MatchModel {
  final String userId;
  final String name;
  final String major;
  final int year;
  final int matchScore;
  final int reliabilityScore;
  final double scheduleScore;
  final double courseScore;
  final double goalScore;
  final double styleScore;
  final String scheduleOverlap;
  final String courseOverlap;
  final String goalSimilarity;

  const MatchModel({
    required this.userId,
    required this.name,
    required this.major,
    required this.year,
    required this.matchScore,
    required this.reliabilityScore,
    required this.scheduleScore,
    required this.courseScore,
    required this.goalScore,
    required this.styleScore,
    required this.scheduleOverlap,
    required this.courseOverlap,
    required this.goalSimilarity,
  });

  MatchModel copyWith({
    String? userId,
    String? name,
    String? major,
    int? year,
    int? matchScore,
    int? reliabilityScore,
    double? scheduleScore,
    double? courseScore,
    double? goalScore,
    double? styleScore,
    String? scheduleOverlap,
    String? courseOverlap,
    String? goalSimilarity,
  }) =>
      MatchModel(
        userId:           userId           ?? this.userId,
        name:             name             ?? this.name,
        major:            major            ?? this.major,
        year:             year             ?? this.year,
        matchScore:       matchScore       ?? this.matchScore,
        reliabilityScore: reliabilityScore ?? this.reliabilityScore,
        scheduleScore:    scheduleScore    ?? this.scheduleScore,
        courseScore:       courseScore      ?? this.courseScore,
        goalScore:        goalScore        ?? this.goalScore,
        styleScore:       styleScore       ?? this.styleScore,
        scheduleOverlap:  scheduleOverlap  ?? this.scheduleOverlap,
        courseOverlap:    courseOverlap     ?? this.courseOverlap,
        goalSimilarity:   goalSimilarity   ?? this.goalSimilarity,
      );

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      userId:           json['userId']           as String? ?? '',
      name:             json['name']             as String? ?? '',
      major:            json['major']            as String? ?? '',
      year:             json['year']             as int?    ?? 0,
      matchScore:       json['matchScore']       as int?    ?? 0,
      reliabilityScore: json['reliabilityScore'] as int?    ?? 0,
      scheduleScore:    (json['scheduleScore']   as num?)?.toDouble() ?? 0,
      courseScore:      (json['courseScore']      as num?)?.toDouble() ?? 0,
      goalScore:        (json['goalScore']       as num?)?.toDouble() ?? 0,
      styleScore:       (json['styleScore']      as num?)?.toDouble() ?? 0,
      scheduleOverlap:  json['scheduleOverlap']  as String? ?? '',
      courseOverlap:    json['courseOverlap']     as String? ?? '',
      goalSimilarity:   json['goalSimilarity']   as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'userId':           userId,
        'name':             name,
        'major':            major,
        'year':             year,
        'matchScore':       matchScore,
        'reliabilityScore': reliabilityScore,
        'scheduleScore':    scheduleScore,
        'courseScore':      courseScore,
        'goalScore':        goalScore,
        'styleScore':       styleScore,
        'scheduleOverlap':  scheduleOverlap,
        'courseOverlap':    courseOverlap,
        'goalSimilarity':   goalSimilarity,
      };
}

