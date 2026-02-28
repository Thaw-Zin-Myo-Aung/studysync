import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DiscussionPostCard extends StatelessWidget {
  final String authorName;
  final String timeAgo;
  final String postTitle;
  final String postBody;
  final int replyCount;

  const DiscussionPostCard({
    super.key,
    required this.authorName,
    required this.timeAgo,
    required this.postTitle,
    required this.postBody,
    required this.replyCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        border: Border.fromBorderSide(BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFFE2E8F0),
                child: Icon(LucideIcons.user, color: Color(0xFF94A3B8), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(authorName,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                    Text(timeAgo,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                  ],
                ),
              ),
              const Icon(LucideIcons.ellipsis, color: Color(0xFFCBD5E1), size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(postTitle,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 8),
          Text(
            postBody,
            style: const TextStyle(fontSize: 14, color: Color(0xFF475569)),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const _ActionItem(LucideIcons.heart, 'Like'),
              const SizedBox(width: 20),
              _ActionItem(LucideIcons.messageCircle, '$replyCount Replies'),
              const SizedBox(width: 20),
              const _ActionItem(LucideIcons.share2, ''),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionItem(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF94A3B8)),
        if (label.isNotEmpty) ...[
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
        ],
      ],
    );
  }
}
