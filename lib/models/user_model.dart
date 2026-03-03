import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final String userId;
  final String studentId;
  final String name;
  final String email;
  final String major;
  final int year;
  final int reliabilityScore;
  final int sessionsAttended;
  final int sessionsScheduled;
  final List<String> groupIds;
  final List<Map<String, dynamic>> courses;
  final Map<String, List<String>> availability;
  final List<String> learningStyles;
  final bool onboardingComplete;
  final Map<String, dynamic> settings;

  const UserModel({
    required this.userId,
    required this.studentId,
    required this.name,
    required this.email,
    required this.major,
    required this.year,
    required this.reliabilityScore,
    required this.sessionsAttended,
    required this.sessionsScheduled,
    required this.groupIds,
    required this.courses,
    required this.availability,
    required this.learningStyles,
    required this.onboardingComplete,
    this.settings = const {},
  });

  UserModel copyWith({
    String? userId,
    String? studentId,
    String? name,
    String? email,
    String? major,
    int? year,
    int? reliabilityScore,
    int? sessionsAttended,
    int? sessionsScheduled,
    List<String>? groupIds,
    List<Map<String, dynamic>>? courses,
    Map<String, List<String>>? availability,
    List<String>? learningStyles,
    bool? onboardingComplete,
    Map<String, dynamic>? settings,
  }) {
    return UserModel(
      userId:             userId            ?? this.userId,
      studentId:          studentId         ?? this.studentId,
      name:               name              ?? this.name,
      email:              email             ?? this.email,
      major:              major             ?? this.major,
      year:               year              ?? this.year,
      reliabilityScore:   reliabilityScore  ?? this.reliabilityScore,
      sessionsAttended:   sessionsAttended  ?? this.sessionsAttended,
      sessionsScheduled:  sessionsScheduled ?? this.sessionsScheduled,
      groupIds:           groupIds          ?? this.groupIds,
      courses:            courses           ?? this.courses,
      availability:       availability      ?? this.availability,
      learningStyles:     learningStyles    ?? this.learningStyles,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      settings:           settings          ?? this.settings,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId:            json['userId']     as String,
      studentId:         json['studentId']  as String? ??
                             (json['email'] as String).split('@')[0],
      name:              json['name']       as String,
      email:             json['email']      as String,
      major:             json['major']      as String,
      year:              json['year']       as int,
      reliabilityScore:  json['reliabilityScore']  as int,
      sessionsAttended:  json['sessionsAttended']  as int,
      sessionsScheduled: json['sessionsScheduled'] as int,
      groupIds:          List<String>.from(json['groupIds'] as List? ?? []),
      courses:           List<Map<String, dynamic>>.from(
                             json['courses'] as List? ?? []),
      availability:      (json['availability'] as Map<String, dynamic>?)
                             ?.map((k, v) => MapEntry(k, List<String>.from(v as List)))
                             ?? {},
      learningStyles:    List<String>.from(json['learningStyles'] as List? ?? []),
      onboardingComplete: json['onboardingComplete'] as bool? ?? false,
      settings:          Map<String, dynamic>.from(json['settings'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'userId':             userId,
    'studentId':          studentId,
    'name':               name,
    'email':              email,
    'major':              major,
    'year':               year,
    'reliabilityScore':   reliabilityScore,
    'sessionsAttended':   sessionsAttended,
    'sessionsScheduled':  sessionsScheduled,
    'groupIds':           groupIds,
    'courses':            courses,
    'availability':       availability,
    'learningStyles':     learningStyles,
    'onboardingComplete': onboardingComplete,
    'settings':           settings,
  };
}
