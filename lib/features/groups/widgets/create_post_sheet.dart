import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../discussions/providers/discussion_provider.dart';

/// Shows a bottom sheet for creating a new discussion post.
void showCreatePostSheet(
  BuildContext context,
  WidgetRef ref, {
  required String groupId,
}) {
  final topicCtrl = TextEditingController();
  final msgCtrl   = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetCtx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(sheetCtx).viewInsets.bottom),
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
              // Drag handle
              Center(
                child: Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text('New Discussion',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: topicCtrl,
                decoration: InputDecoration(
                  hintText: 'Topic',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: msgCtrl,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'What do you want to discuss?',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    if (topicCtrl.text.trim().isEmpty ||
                        msgCtrl.text.trim().isEmpty) return;
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Post',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

