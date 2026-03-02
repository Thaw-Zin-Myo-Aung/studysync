import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/study_group_model.dart';

class GroupsNotifier extends Notifier<List<StudyGroupModel>> {
  @override
  List<StudyGroupModel> build() => [];

  void setGroups(List<StudyGroupModel> groups) => state = groups;

  void addGroup(StudyGroupModel group) => state = [...state, group];
}

final groupsProvider = NotifierProvider<GroupsNotifier, List<StudyGroupModel>>(
  GroupsNotifier.new,
);
