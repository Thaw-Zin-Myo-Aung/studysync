import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';
import 'create_post_sheet.dart';
import 'discussion_list.dart';

class DiscussionTab extends ConsumerWidget {
  final String groupId;
  const DiscussionTab({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUid = ref.watch(authProvider)?.userId ?? '';

    return Stack(
      children: [
        DiscussionList(groupId: groupId, currentUid: currentUid),
        Positioned(
          bottom: 16,
          right: 0,
          child: GestureDetector(
            onTap: () => showCreatePostSheet(context, ref, groupId: groupId),
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              child: const Icon(LucideIcons.plus,
                  color: Colors.white, size: 28),
            ),
          ),
        ),
      ],
    );
  }
}
