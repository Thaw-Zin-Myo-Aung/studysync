import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/groups_provider.dart';

/// Shows a bottom sheet listing every user who liked a discussion.
void showLikersSheet(
  BuildContext context,
  WidgetRef ref, {
  required List<String> likedBy,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Row(
            children: [
              const Icon(LucideIcons.heart,
                  size: 16, color: Color(0xFFEF4444)),
              const SizedBox(width: 8),
              Text(
                '${likedBy.length} ${likedBy.length == 1 ? 'Like' : 'Likes'}',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: likedBy.length,
              itemBuilder: (_, i) {
                final uid = likedBy[i];
                return Consumer(
                  builder: (ctx, ref, _) {
                    final userAsync = ref.watch(memberUserProvider(uid));
                    final name =
                        userAsync.whenOrNull(data: (u) => u?.name) ?? uid;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: const Color(0xFFEFF6FF),
                            child: Text(
                              name.isNotEmpty
                                  ? name[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(name,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87)),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

