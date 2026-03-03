import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/discussion_post_card.dart';
import '../../discussions/providers/discussion_provider.dart';
import 'likers_sheet.dart';
import 'thread_sheet.dart';

/// The scrollable list of discussion posts (or empty state).
/// Extracted from DiscussionTab so the tab stays thin.
class DiscussionList extends ConsumerWidget {
  final String groupId;
  final String currentUid;

  const DiscussionList({
    super.key,
    required this.groupId,
    required this.currentUid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discussionsAsync = ref.watch(discussionsProvider(groupId));

    return discussionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Could not load discussions'),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => ref.invalidate(discussionsProvider(groupId)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (discussions) {
        if (discussions.isEmpty) {
          return const Center(child: _DiscussionEmptyState());
        }
        return RefreshIndicator(
          onRefresh: () async =>
              ref.invalidate(discussionsProvider(groupId)),
          child: ListView.separated(
            padding: const EdgeInsets.only(top: 16, bottom: 80),
            itemCount: discussions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final d = discussions[i];
              final isLiked = d.likedBy.contains(currentUid);
              return DiscussionPostCard(
                authorName: d.authorName,
                timeAgo: formatTimestamp(d.timestamp),
                postTitle: d.topic,
                postBody: d.message,
                replyCount: d.replyCount,
                likeCount: d.likeCount,
                isLiked: isLiked,
                onTap: () => showThreadSheet(
                  context, ref,
                  discussion: d,
                  currentUid: currentUid,
                ),
                onLike: () => toggleDiscussionLike(
                  ref,
                  groupId: groupId,
                  discussionId: d.discussionId,
                ),
                onShowLikers: d.likedBy.isNotEmpty
                    ? () => showLikersSheet(context, ref, likedBy: d.likedBy)
                    : null,
              );
            },
          ),
        );
      },
    );
  }
}

class _DiscussionEmptyState extends StatelessWidget {
  const _DiscussionEmptyState();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(LucideIcons.messageCircle,
            size: 48, color: AppColors.textHint),
        const SizedBox(height: 12),
        const Text('No discussions yet',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        const Text('Start a conversation with your group!',
            style:
                TextStyle(fontSize: 13, color: AppColors.textHint)),
      ],
    );
  }
}

