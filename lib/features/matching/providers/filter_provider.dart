import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class FilterModel {
  final String? course;
  final double minReliability;
  final String? targetGrade;
  final String? learningStyle;

  const FilterModel({
    this.course,
    this.minReliability = 0,
    this.targetGrade,
    this.learningStyle,
  });

  FilterModel copyWith({
    String? Function()? course,
    double? minReliability,
    String? Function()? targetGrade,
    String? Function()? learningStyle,
  }) {
    return FilterModel(
      course: course != null ? course() : this.course,
      minReliability: minReliability ?? this.minReliability,
      targetGrade: targetGrade != null ? targetGrade() : this.targetGrade,
      learningStyle: learningStyle != null ? learningStyle() : this.learningStyle,
    );
  }

  bool get isActive =>
      course != null ||
      minReliability > 0 ||
      targetGrade != null ||
      learningStyle != null;

  static const empty = FilterModel();
}

class FilterNotifier extends Notifier<FilterModel> {
  @override
  FilterModel build() => FilterModel.empty;

  void update(FilterModel filter) => state = filter;
  void reset() => state = FilterModel.empty;
}

final filterProvider = NotifierProvider<FilterNotifier, FilterModel>(
  FilterNotifier.new,
);
