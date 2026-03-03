import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/auth_provider.dart';
import 'group_form_field.dart';
import 'group_max_members_field.dart';

/// The white card holding all Create Group form fields.
/// Uses [ConsumerWidget] to read the current user's courses for the dropdown.
class CreateGroupForm extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController courseController;
  final TextEditingController locationController;
  final TextEditingController descriptionController;
  final int maxMembers;
  final ValueChanged<int> onMaxMembersChanged;

  const CreateGroupForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.courseController,
    required this.locationController,
    required this.descriptionController,
    required this.maxMembers,
    required this.onMaxMembersChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    // Extract course names from the user's courses list
    final courseNames = (user?.courses ?? [])
        .map((c) => c['name'] as String? ?? '')
        .where((n) => n.isNotEmpty)
        .toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              blurRadius: 16,
              color: Colors.black.withValues(alpha: 0.06)),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GroupFormField(
              label: 'Group Name',
              hintText: 'e.g. Database Study Team',
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Group name is required' : null,
            ),
            const SizedBox(height: 16),
            // ── Course dropdown ───────────────────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Course',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 6),
                courseNames.isEmpty
                    // Fallback to plain text field if user has no courses
                    ? GroupFormField(
                        label: '',
                        hintText: 'e.g. IEN1101 Engineering Mathematics',
                        controller: courseController,
                        textCapitalization: TextCapitalization.words,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Course is required'
                            : null,
                      )
                    : DropdownButtonFormField<String>(
                        initialValue: courseController.text.isNotEmpty &&
                                courseNames.contains(courseController.text)
                            ? courseController.text
                            : null,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: AppColors.border)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: AppColors.border)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: AppColors.primary, width: 1.5)),
                          filled: true,
                          fillColor: AppColors.surface,
                        ),
                        hint: const Text('Select your course',
                            style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textHint)),
                        isExpanded: true,
                        items: courseNames
                            .map((name) => DropdownMenuItem(
                                  value: name,
                                  child: Text(name,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 14)),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) courseController.text = val;
                        },
                        validator: (val) => (val == null || val.isEmpty)
                            ? 'Course is required'
                            : null,
                      ),
              ],
            ),
            const SizedBox(height: 16),
            GroupFormField(
              label: 'Location',
              hintText: 'e.g. Library Room 3 / Online',
              controller: locationController,
              textCapitalization: TextCapitalization.sentences,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Location is required' : null,
            ),
            const SizedBox(height: 16),
            GroupFormField(
              label: 'Description (optional)',
              hintText: 'What will your group focus on?',
              controller: descriptionController,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            GroupMaxMembersField(
              value: maxMembers,
              onChanged: onMaxMembersChanged,
            ),
          ],
        ),
      ),
    );
  }
}

