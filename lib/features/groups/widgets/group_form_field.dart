import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Shared labelled text field used inside the Create Group form.
/// Supports single-line and multiline variants.
class GroupFormField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final String? Function(String?)? validator;

  const GroupFormField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.sentences,
    this.maxLines = 1,
    this.validator,
  });

  static final _border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide.none,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle:
                const TextStyle(fontSize: 14, color: AppColors.textHint),
            filled: true,
            fillColor: AppColors.primarySurface,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: _border,
            enabledBorder: _border,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: AppColors.error, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: AppColors.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

