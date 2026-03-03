import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/discussion_model.dart';
import '../../../providers/auth_provider.dart';
import '../models/reply_model.dart';
import '../services/discussion_service.dart';

final discussionServiceProvider =
    Provider<DiscussionService>((_) => DiscussionService());

// ── Discussions for a specific group ────────────────────────────────────────

final discussionsProvider = FutureProvider.family
    .autoDispose<List<DiscussionModel>, String>((ref, groupId) async {
  final service = ref.read(discussionServiceProvider);
  return service.getDiscussions(groupId);
});

/// Creates a discussion and then invalidates the discussions provider.
Future<void> createDiscussion(
  WidgetRef ref, {
  required String groupId,
  required String topic,
  required String message,
}) async {
  final user = ref.read(authProvider);
  if (user == null) return;
  final service = ref.read(discussionServiceProvider);
  await service.createDiscussion(
    groupId:    groupId,
    topic:      topic,
    message:    message,
    authorName: user.name,
  );
  ref.invalidate(discussionsProvider(groupId));
}

// ── Replies for a specific discussion ───────────────────────────────────────

/// Argument is "${groupId}|${discussionId}"
final repliesProvider = FutureProvider.family
    .autoDispose<List<ReplyModel>, String>((ref, key) async {
  final parts = key.split('|');
  final groupId = parts[0];
  final discussionId = parts[1];
  final service = ref.read(discussionServiceProvider);
  return service.getReplies(groupId, discussionId);
});

/// Toggles like on a discussion and invalidates the discussions provider.
Future<void> toggleDiscussionLike(
  WidgetRef ref, {
  required String groupId,
  required String discussionId,
}) async {
  final service = ref.read(discussionServiceProvider);
  await service.toggleLike(groupId, discussionId);
  ref.invalidate(discussionsProvider(groupId));
}

/// Adds a reply and then invalidates both the replies and discussions providers.
Future<void> addReply(
  WidgetRef ref, {
  required String groupId,
  required String discussionId,
  required String message,
}) async {
  final user = ref.read(authProvider);
  if (user == null) return;
  final service = ref.read(discussionServiceProvider);
  await service.addReply(
    groupId:      groupId,
    discussionId: discussionId,
    message:      message,
    authorName:   user.name,
  );
  ref.invalidate(repliesProvider('$groupId|$discussionId'));
  ref.invalidate(discussionsProvider(groupId));
}
