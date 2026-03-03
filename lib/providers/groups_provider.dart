import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/study_group_model.dart';
import '../models/user_model.dart';
import '../services/firebase/group_service.dart';
import 'auth_provider.dart';

final groupServiceProvider = Provider<GroupService>((_) => GroupService());

class GroupsNotifier extends Notifier<List<StudyGroupModel>> {
  GroupService get _groupService => ref.read(groupServiceProvider);

  @override
  List<StudyGroupModel> build() {
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
    String description = '',
    int maxMembers = 6,
  }) async {
    final group = await _groupService.createGroup(
      name:        name,
      course:      course,
      location:    location,
      description: description,
      maxMembers:  maxMembers,
    );
    state = [...state, group];
  }

  Future<void> joinGroup(String groupId) async {
    final group = await _groupService.joinGroup(groupId);
    state = [...state, group];
  }

  /// Add a specific user to a group (used by admin or notification accept).
  Future<void> joinGroupForUser(String groupId, String userId) async {
    final group = await _groupService.joinGroupForUser(groupId, userId);
    state = state.map((g) => g.groupId == groupId ? group : g).toList();
  }

  Future<void> leaveGroup(String groupId) async {
    await _groupService.leaveGroup(groupId);
    state = state.where((g) => g.groupId != groupId).toList();
  }

  Future<void> removeMember(String groupId, String memberId) async {
    await _groupService.removeMember(groupId, memberId);
    // Refresh the specific group
    state = state.map((g) {
      if (g.groupId == groupId) {
        return g.copyWith(
          memberIds: g.memberIds.where((id) => id != memberId).toList(),
        );
      }
      return g;
    }).toList();
  }

  Future<void> makeAdmin(String groupId, String memberId) async {
    final updated = await _groupService.makeAdmin(groupId, memberId);
    state = state.map((g) => g.groupId == groupId ? updated : g).toList();
  }

  Future<void> updateGroup({
    required String groupId,
    String? name,
    String? course,
    String? description,
    String? location,
    int? maxMembers,
  }) async {
    final updated = await _groupService.updateGroup(
      groupId: groupId,
      name: name,
      course: course,
      description: description,
      location: location,
      maxMembers: maxMembers,
    );
    state = state.map((g) => g.groupId == groupId ? updated : g).toList();
  }

  Future<void> deleteGroup(String groupId) async {
    await _groupService.deleteGroup(groupId);
    state = state.where((g) => g.groupId != groupId).toList();
  }
}

final groupsProvider = NotifierProvider<GroupsNotifier, List<StudyGroupModel>>(
  GroupsNotifier.new,
);

// ── Resolve a single userId → UserModel ─────────────────────────────────────

final memberUserProvider =
    FutureProvider.family<UserModel?, String>((ref, userId) async {
  final authService = ref.read(authServiceProvider);
  return authService.fetchUserById(userId);
});

