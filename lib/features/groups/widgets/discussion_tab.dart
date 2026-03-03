import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/discussion_post_card.dart';
import '../../../models/discussion_model.dart';
import '../../discussions/providers/discussion_provider.dart';

class DiscussionTab extends ConsumerWidget {
  final String groupId;
  const DiscussionTab({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discussionsAsync = ref.watch(discussionsProvider(groupId));

    return Stack(
      children: [
        discussionsAsync.when(
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
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.messageCircle, size: 48, color: AppColors.textHint),
                    const SizedBox(height: 12),
                    const Text('No discussions yet',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    const Text('Start a conversation with your group!',
                        style: TextStyle(fontSize: 13, color: AppColors.textHint)),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async => ref.invalidate(discussionsProvider(groupId)),
              child: ListView.separated(
                padding: const EdgeInsets.only(top: 16, bottom: 80),
                itemCount: discussions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final d = discussions[i];
                  return GestureDetector(
                    onTap: () => _showThreadSheet(context, ref, d),
                    child: DiscussionPostCard(
                      authorName: d.authorName,
                      timeAgo: _formatTimestamp(d.timestamp),
                      postTitle: d.topic,
                      postBody: d.message,
                      replyCount: d.replyCount,
                    ),
                  );
                },
              ),
            );
          },
        ),
        Positioned(
          bottom: 16,
          right: 0,
          child: GestureDetector(
            onTap: () => _showCreatePostDialog(context, ref),
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              child: const Icon(LucideIcons.plus, color: Colors.white, size: 28),
            ),
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(String timestamp) {
    if (timestamp.isEmpty) return 'Just now';
    try {
      final dt = DateTime.parse(timestamp);
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${dt.month}/${dt.day}';
    } catch (_) {
      return timestamp;
    }
  }

  void _showCreatePostDialog(BuildContext context, WidgetRef ref) {
    final topicCtrl = TextEditingController();
    final msgCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetCtx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const Text('New Discussion', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(
                  controller: topicCtrl,
                  decoration: InputDecoration(
                    hintText: 'Topic',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: msgCtrl,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'What do you want to discuss?',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (topicCtrl.text.trim().isEmpty || msgCtrl.text.trim().isEmpty) return;
                      Navigator.pop(sheetCtx);
                      await createDiscussion(
                        ref,
                        groupId: groupId,
                        topic:   topicCtrl.text.trim(),
                        message: msgCtrl.text.trim(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Post', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showThreadSheet(BuildContext context, WidgetRef ref, DiscussionModel discussion) {
    final replyCtrl = TextEditingController();
    final key = '${discussion.groupId}|${discussion.discussionId}';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 12),
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              // Original post
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(discussion.topic, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(discussion.authorName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
                        const SizedBox(width: 8),
                        Text(_formatTimestamp(discussion.timestamp), style: const TextStyle(fontSize: 12, color: AppColors.textHint)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(discussion.message, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                    const Divider(height: 24),
                    Text('${discussion.replyCount} Replies', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              // Replies list
              Expanded(
                child: Consumer(
                  builder: (context, ref, _) {
                    final repliesAsync = ref.watch(repliesProvider(key));
                    return repliesAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => const Center(child: Text('Error loading replies')),
                      data: (replies) {
                        if (replies.isEmpty) {
                          return const Center(child: Text('No replies yet', style: TextStyle(color: AppColors.textHint)));
                        }
                        return ListView.separated(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: replies.length,
                          separatorBuilder: (_, __) => const Divider(height: 16),
                          itemBuilder: (_, i) {
                            final r = replies[i];
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
                                        child: Text(r.authorName.isNotEmpty ? r.authorName[0].toUpperCase() : '?',
                                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(r.authorName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                      const SizedBox(width: 8),
                                      Text(_formatTimestamp(r.timestamp), style: const TextStyle(fontSize: 11, color: AppColors.textHint)),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 36),
                                    child: Text(r.message, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              // Reply input
              Container(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8 + MediaQuery.of(context).viewInsets.bottom),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: replyCtrl,
                        decoration: InputDecoration(
                          hintText: 'Write a reply...',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide(color: AppColors.border)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
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
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                        child: const Icon(LucideIcons.send, color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
