import 'package:flutter/material.dart';
import '../../../core/widgets/discussion_post_card.dart';

class DiscussionTab extends StatelessWidget {
  const DiscussionTab({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = [
      {
        'author': 'Kay Suwannarat',
        'time': '2 hours ago',
        'title': 'Chapter 5 Review - Calculus',
        'body': 'Does anyone understand the chain rule application in the '
            'final problem set? I keep getting different answers.',
        'replies': 3,
      },
      {
        'author': 'Som',
        'time': 'Yesterday',
        'title': 'Midterm Date Change',
        'body': 'Prof said the exam is moved to next Friday because of the '
            'holiday. Make sure to update your calendars!',
        'replies': 8,
      },
    ];

    return Stack(
      children: [
        ListView.separated(
          padding: const EdgeInsets.only(top: 16, bottom: 80),
          itemCount: posts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) => DiscussionPostCard(
            authorName: posts[i]['author'] as String,
            timeAgo: posts[i]['time'] as String,
            postTitle: posts[i]['title'] as String,
            postBody: posts[i]['body'] as String,
            replyCount: posts[i]['replies'] as int,
          ),
        ),
        Positioned(
          bottom: 16,
          right: 0,
          child: GestureDetector(
            onTap: () => print('New post'),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D9488), Color(0xFF14B8A6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
        ),
      ],
    );
  }
}

