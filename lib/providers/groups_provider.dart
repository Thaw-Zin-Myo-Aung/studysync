import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/study_group_model.dart';

class GroupsNotifier extends StateNotifier<List<StudyGroupModel>> {
  GroupsNotifier() : super([]);

  void setGroups(List<StudyGroupModel> groups) => state = groups;

  void addGroup(StudyGroupModel group) => state = [...state, group];
}

final groupsProvider = StateNotifierProvider<GroupsNotifier, List<StudyGroupModel>>(
  (ref) => GroupsNotifier(),
);

