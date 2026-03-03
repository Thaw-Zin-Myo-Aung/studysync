import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'group_form_field.dart';
import 'group_max_members_field.dart';

/// The white card holding all Create Group form fields.
/// Stateless — all state lives in [CreateGroupScreen].
class CreateGroupForm extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
            GroupFormField(
              label: 'Course',
              hintText: 'e.g. IEN1101 Engineering Mathematics',
              controller: courseController,
              textCapitalization: TextCapitalization.words,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Course is required' : null,
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

