import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/match_model.dart';
import '../../../providers/auth_provider.dart';
import '../services/matching_service.dart';

final matchingServiceProvider =
    Provider<MatchingService>((_) => MatchingService());

// ── Matching Provider ───────────────────────────────────────────────────────

final matchingProvider =
    AsyncNotifierProvider<MatchingNotifier, List<MatchModel>>(
  MatchingNotifier.new,
);

class MatchingNotifier extends AsyncNotifier<List<MatchModel>> {
  late final MatchingService _service;

  @override
  Future<List<MatchModel>> build() async {
    _service = ref.read(matchingServiceProvider);
    final user = ref.read(authProvider);
    if (user == null) return [];
    return _service.getMatches(user);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> sendRequest(String receiverId) async {
    final user = ref.read(authProvider);
    if (user == null) return;
    await _service.sendMatchRequest(
      senderId:   user.userId,
      receiverId: receiverId,
    );
  }
}

