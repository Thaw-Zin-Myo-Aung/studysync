import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final String userId;
  final String name;
  final String email;
  final String major;
  final int year;
  final int reliabilityScore;
  final int sessionsAttended;
  final int sessionsScheduled;
  final List<String> groupIds;

  const UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.major,
    required this.year,
    required this.reliabilityScore,
    required this.sessionsAttended,
    required this.sessionsScheduled,
    required this.groupIds,
  });

  UserModel copyWith({
    String? userId,
    String? name,
    String? email,
    String? major,
    int? year,
    int? reliabilityScore,
    int? sessionsAttended,
    int? sessionsScheduled,
    List<String>? groupIds,
  }) {
    return UserModel(
      userId:            userId            ?? this.userId,
      name:              name              ?? this.name,
      email:             email             ?? this.email,
      major:             major             ?? this.major,
      year:              year              ?? this.year,
      reliabilityScore:  reliabilityScore  ?? this.reliabilityScore,
      sessionsAttended:  sessionsAttended  ?? this.sessionsAttended,
      sessionsScheduled: sessionsScheduled ?? this.sessionsScheduled,
      groupIds:          groupIds          ?? this.groupIds,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId:            json['userId']            as String,
      name:              json['name']              as String,
      email:             json['email']             as String,
      major:             json['major']             as String,
      year:              json['year']              as int,
      reliabilityScore:  json['reliabilityScore']  as int,
      sessionsAttended:  json['sessionsAttended']  as int,
      sessionsScheduled: json['sessionsScheduled'] as int,
      groupIds:          List<String>.from(json['groupIds'] as List),
    );
  }

  Map<String, dynamic> toJson() => {
    'userId':            userId,
    'name':              name,
    'email':             email,
    'major':             major,
    'year':              year,
    'reliabilityScore':  reliabilityScore,
    'sessionsAttended':  sessionsAttended,
    'sessionsScheduled': sessionsScheduled,
    'groupIds':          groupIds,
  };
}

