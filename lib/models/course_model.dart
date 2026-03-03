import 'package:flutter/foundation.dart';

@immutable
class CourseModel {
  final String name;
  final String academicGoal; // A, B+, B, C, Pass

  const CourseModel({
    required this.name,
    required this.academicGoal,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      name:         json['name']         as String? ?? '',
      academicGoal: json['academicGoal'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name':         name,
        'academicGoal': academicGoal,
      };
}

