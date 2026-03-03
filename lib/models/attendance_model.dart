import 'package:flutter/foundation.dart';

@immutable
class AttendanceModel {
  final String userId;
  final bool attended;
  final String markedAt;

  const AttendanceModel({
    required this.userId,
    required this.attended,
    required this.markedAt,
  });

  AttendanceModel copyWith({
    String? userId,
    bool? attended,
    String? markedAt,
  }) =>
      AttendanceModel(
        userId:   userId   ?? this.userId,
        attended: attended ?? this.attended,
        markedAt: markedAt ?? this.markedAt,
      );

  factory AttendanceModel.fromJson(Map<String, dynamic> json, {String? docId}) {
    return AttendanceModel(
      userId:   docId ?? json['userId'] as String? ?? '',
      attended: json['attended'] as bool? ?? false,
      markedAt: json['markedAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'userId':   userId,
        'attended': attended,
        'markedAt': markedAt,
      };
}

