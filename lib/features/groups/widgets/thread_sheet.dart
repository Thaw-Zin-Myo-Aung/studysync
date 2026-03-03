import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../models/discussion_model.dart';
import '../../discussions/providers/discussion_provider.dart';
import 'likers_sheet.dart';

/// Full-screen thread bottom sheet: shows original post, action bar,
/// replies list, and reply input — all in one draggable sheet.
void showThreadSheet(
  BuildContext context,
  WidgetRef ref, {
  required DiscussionModel discussion,
  required String currentUid,
}) {
  final replyCtrl = TextEditingController();
  final key = '${discussion.groupId}|${discussion.discussionId}';

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetCtx) => Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(sheetCtx).viewInsets.bottom),
      child: DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // ── Drag handle ─────────────────────────────────────────────
              Center(
                child: Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 12),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),

              // ── Original post + action bar ───────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Consumer(
                  builder: (ctx, ref, _) {
                    final discussionsAsync =
                        ref.watch(discussionsProvider(discussion.groupId));
                    final live = discussionsAsync.whenOrNull(
                          data: (list) => list.firstWhere(
                            (d) => d.discussionId == discussion.discussionId,
                            orElse: () => discussion,
                          ),
                        ) ??
                        discussion;
                    final isLiked = live.likedBy.contains(currentUid);

                    return _ThreadHeader(
                      discussion: live,
                      isLiked: isLiked,
                      onLike: () => toggleDiscussionLike(
                        ref,
                        groupId: discussion.groupId,
                        discussionId: discussion.discussionId,
                      ),
                      onShowLikers: live.likeCount > 0
                          ? () => showLikersSheet(context, ref,
                              likedBy: live.likedBy)
                          : null,
                    );
                  },
                ),
              ),

              // ── Replies list ─────────────────────────────────────────────
              Expanded(
                child: Consumer(
                  builder: (context, ref, _) {
                    final repliesAsync = ref.watch(repliesProvider(key));
                    return repliesAsync.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => const Center(
                          child: Text('Error loading replies')),
                      data: (replies) {
                        if (replies.isEmpty) {
                          return const Center(
                            child: Text('No replies yet',
                                style:
                                    TextStyle(color: AppColors.textHint)),
                          );
                        }
                        return ListView.separated(
                          controller: scrollController,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: replies.length,
                          separatorBuilder: (_, __) =>
                              const Divider(height: 16),
                          itemBuilder: (_, i) =>
                              _ReplyTile(reply: replies[i]),
                        );
                      },
                    );
                  },
                ),
              ),

              // ── Reply input ──────────────────────────────────────────────
              SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(color: AppColors.border)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: replyCtrl,
                          decoration: InputDecoration(
                            hintText: 'Write a reply...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide:
                                  BorderSide(color: AppColors.border),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Consumer(
                        builder: (ctx, ref, _) => GestureDetector(
                          onTap: () async {
                            if (replyCtrl.text.trim().isEmpty) return;
                            final text = replyCtrl.text.trim();
                            replyCtrl.clear();
                            await addReply(
                              ref,
                              groupId: discussion.groupId,
                              discussionId: discussion.discussionId,
                              message: text,
                            );
                          },
                          child: Container(
                            width: 40, height: 40,
                            decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle),
                            child: const Icon(LucideIcons.send,
                                color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// ── Thread header with post content + X-style action bar ──────────────────────

class _ThreadHeader extends StatelessWidget {
  final DiscussionModel discussion;
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback? onShowLikers;

  const _ThreadHeader({
    required this.discussion,
    required this.isLiked,
    required this.onLike,
    this.onShowLikers,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(discussion.topic,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Row(
          children: [
            Text(discussion.authorName,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary)),
            const SizedBox(width: 8),
            Text(formatTimestamp(discussion.timestamp),
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textHint)),
          ],
        ),
        const SizedBox(height: 8),
        Text(discussion.message,
            style: const TextStyle(
                fontSize: 14, color: AppColors.textSecondary)),
        const Divider(height: 24),
        // Action bar
        Row(
          children: [
            // Heart
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onLike,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 4, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.heart,
                        size: 20,
                        color: isLiked
                            ? const Color(0xFFEF4444)
                            : AppColors.textHint),
                    const SizedBox(width: 5),
                    Text('${discussion.likeCount}',
                        style: TextStyle(
                            fontSize: 13,
                            color: isLiked
                                ? const Color(0xFFEF4444)
                                : AppColors.textHint)),
                  ],
                ),
              ),
            ),
            if (discussion.likeCount > 0) ...[
              const SizedBox(width: 4),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onShowLikers,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4, vertical: 8),
                  child: Text('See likes',
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade400,
                          decoration: TextDecoration.underline)),
                ),
              ),
            ],
            const SizedBox(width: 16),
            // Reply count
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.messageCircle,
                    size: 18, color: AppColors.textHint),
                const SizedBox(width: 5),
                Text('${discussion.replyCount} Replies',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ── Single reply row ───────────────────────────────────────────────────────────

class _ReplyTile extends StatelessWidget {
  final dynamic reply; // ReplyModel

  const _ReplyTile({required this.reply});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.backgroundBlue,
                child: Text(
                  reply.authorName.isNotEmpty
                      ? reply.authorName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(width: 8),
              Text(reply.authorName,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              Text(formatTimestamp(reply.timestamp),
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textHint)),
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: Text(reply.message,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}

