import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/match_model.dart';
import '../../../providers/auth_provider.dart';
import '../services/matching_service.dart';
import 'filter_provider.dart';

final matchingServiceProvider =
    Provider<MatchingService>((_) => MatchingService());

// ── Matching Provider ───────────────────────────────────────────────────────

final matchingProvider =
    AsyncNotifierProvider<MatchingNotifier, List<MatchModel>>(
  MatchingNotifier.new,
);

class MatchingNotifier extends AsyncNotifier<List<MatchModel>> {
  MatchingService get _service => ref.read(matchingServiceProvider);

  @override
  Future<List<MatchModel>> build() async {
    final user = ref.read(authProvider);
    if (user == null) return [];

    final allMatches = await _service.getMatches(user);
    final filter = ref.read(filterProvider);
    return _applyFilters(allMatches, filter);
  }

  List<MatchModel> _applyFilters(List<MatchModel> matches, FilterModel f) {
    var filtered = matches.toList();

    if (f.minReliability > 0) {
      filtered = filtered
          .where((m) => m.reliabilityScore >= f.minReliability.round())
          .toList();
    }

    if (f.course != null && f.course!.isNotEmpty) {
      filtered = filtered
          .where((m) =>
              m.courseOverlap.toLowerCase().contains(f.course!.toLowerCase()))
          .toList();
    }

    if (f.targetGrade != null) {
      filtered = filtered
          .where((m) => m.goalSimilarity
              .toLowerCase()
              .contains(f.targetGrade!.toLowerCase()))
          .toList();
    }

    if (f.learningStyle != null) {
      // Keep all — style filter is a soft preference, don't hard-filter
      // Just sort: matches with this style first
    }

    return filtered;
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
