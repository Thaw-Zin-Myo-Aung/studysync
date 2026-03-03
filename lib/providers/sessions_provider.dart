import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/session_model.dart';
import '../services/firebase/session_service.dart';
import 'groups_provider.dart';

final sessionServiceProvider =
    Provider<SessionService>((_) => SessionService());

/// Loads all *scheduled* sessions across every group the user belongs to,
/// sorted by date ascending (soonest first).
class UpcomingSessionsNotifier extends Notifier<List<SessionModel>> {
  late final SessionService _sessionService;

  @override
  List<SessionModel> build() {
    _sessionService = ref.read(sessionServiceProvider);

    // Re-load whenever the groups list changes
    ref.listen(groupsProvider, (_, groups) {
      if (groups.isNotEmpty) {
        _loadAll(groups.map((g) => g.groupId).toList());
      } else {
        state = [];
      }
    });

    // Also load immediately if groups are already populated
    final groups = ref.read(groupsProvider);
    if (groups.isNotEmpty) {
      final ids = groups.map((g) => g.groupId).toList();
      Future(() => _loadAll(ids));
    }

    return [];
  }

  Future<void> _loadAll(List<String> groupIds) async {
    try {
      final results = await Future.wait(
        groupIds.map((id) => _sessionService.getSessions(id)),
      );
      final all = results.expand((list) => list).toList();
      // Keep only scheduled sessions, sort soonest first
      all.sort((a, b) => a.date.compareTo(b.date));
      state = all.where((s) => s.status == 'scheduled').toList();
    } catch (_) {
      state = [];
    }
  }

  Future<void> refresh() async {
    final groups = ref.read(groupsProvider);
    if (groups.isEmpty) {
      state = [];
      return;
    }
    await _loadAll(groups.map((g) => g.groupId).toList());
  }
}

final upcomingSessionsProvider =
    NotifierProvider<UpcomingSessionsNotifier, List<SessionModel>>(
  UpcomingSessionsNotifier.new,
);



