import 'package:flutter/foundation.dart';

@immutable
class StudyGroupModel {
  final String groupId;
  final String name;
  final String course;
  final String adminId;
  final List<String> memberIds;
  final String nextSessionDate;
  final String location;
  final bool isActive;

  const StudyGroupModel({
    required this.groupId,
    required this.name,
    required this.course,
    required this.adminId,
    required this.memberIds,
    required this.nextSessionDate,
    required this.location,
    required this.isActive,
  });

  StudyGroupModel copyWith({
    String? groupId,
    String? name,
    String? course,
    String? adminId,
    List<String>? memberIds,
    String? nextSessionDate,
    String? location,
    bool? isActive,
  }) {
    return StudyGroupModel(
      groupId:         groupId         ?? this.groupId,
      name:            name            ?? this.name,
      course:          course          ?? this.course,
      adminId:         adminId         ?? this.adminId,
      memberIds:       memberIds       ?? this.memberIds,
      nextSessionDate: nextSessionDate ?? this.nextSessionDate,
      location:        location        ?? this.location,
      isActive:        isActive        ?? this.isActive,
    );
  }

  factory StudyGroupModel.fromJson(Map<String, dynamic> json) {
    return StudyGroupModel(
      groupId:         json['groupId']         as String,
      name:            json['name']            as String,
      course:          json['course']          as String,
      adminId:         json['adminId']         as String,
      memberIds:       List<String>.from(json['memberIds'] as List),
      nextSessionDate: json['nextSessionDate'] as String,
      location:        json['location']        as String,
      isActive:        json['isActive']        as bool,
    );
  }

  Map<String, dynamic> toJson() => {
    'groupId':         groupId,
    'name':            name,
    'course':          course,
    'adminId':         adminId,
    'memberIds':       memberIds,
    'nextSessionDate': nextSessionDate,
    'location':        location,
    'isActive':        isActive,
  };
}

