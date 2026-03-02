import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/study_group_model.dart';
import '../services/firebase/group_service.dart';
import 'auth_provider.dart';

final groupServiceProvider = Provider<GroupService>((_) => GroupService());

class GroupsNotifier extends Notifier<List<StudyGroupModel>> {
  late final GroupService _groupService;

  @override
  List<StudyGroupModel> build() {
    _groupService = ref.read(groupServiceProvider);
    // Auto-load when auth state changes
    ref.listen(authProvider, (_, user) {
      if (user != null) {
        loadGroups(user.userId);
      } else {
        state = [];
      }
    });
    return [];
  }

  Future<void> loadGroups(String userId) async {
    try {
      state = await _groupService.getUserGroups(userId);
    } catch (_) {
      state = [];
    }
  }

  Future<void> createGroup({
    required String name,
    required String course,
    required String location,
  }) async {
    final group = await _groupService.createGroup(
      name: name,
      course: course,
      location: location,
    );
    state = [...state, group];
  }

  Future<void> joinGroup(String groupId) async {
    final group = await _groupService.joinGroup(groupId);
    state = [...state, group];
  }
}

final groupsProvider = NotifierProvider<GroupsNotifier, List<StudyGroupModel>>(
  GroupsNotifier.new,
);
