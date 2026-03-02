import 'package:flutter/foundation.dart';

@immutable
class SessionModel {
  final String sessionId;
  final String groupId;
  final String date;
  final String time;
  final String location;
  final String status; // scheduled / completed / cancelled
  final String createdAt;

  const SessionModel({
    required this.sessionId,
    required this.groupId,
    required this.date,
    required this.time,
    required this.location,
    required this.status,
    required this.createdAt,
  });

  SessionModel copyWith({
    String? sessionId,
    String? groupId,
    String? date,
    String? time,
    String? location,
    String? status,
    String? createdAt,
  }) => SessionModel(
    sessionId: sessionId ?? this.sessionId,
    groupId:   groupId   ?? this.groupId,
    date:      date      ?? this.date,
    time:      time      ?? this.time,
    location:  location  ?? this.location,
    status:    status    ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );

  factory SessionModel.fromJson(Map<String, dynamic> json) => SessionModel(
    sessionId: json['sessionId'] as String,
    groupId:   json['groupId']   as String,
    date:      json['date']      as String,
    time:      json['time']      as String,
    location:  json['location']  as String,
    status:    json['status']    as String,
    createdAt: json['createdAt']?.toString() ?? '',
  );

  Map<String, dynamic> toJson() => {
    'sessionId': sessionId,
    'groupId':   groupId,
    'date':      date,
    'time':      time,
    'location':  location,
    'status':    status,
    'createdAt': createdAt,
  };
}

