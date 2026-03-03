import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Labelled dropdown for selecting an integer value from a fixed list.
class GroupMaxMembersField extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  static const _options = [2, 3, 4, 5, 6, 8, 10];

  static final _border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide.none,
  );

  const GroupMaxMembersField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Max Members',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          initialValue: value,
          onChanged: (v) { if (v != null) onChanged(v); },
          items: _options
              .map((n) => DropdownMenuItem(
                    value: n,
                    child: Text('$n members',
                        style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary)),
                  ))
              .toList(),
          dropdownColor: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          decoration: InputDecoration(
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
          ),
        ),
      ],
    );
  }
}


