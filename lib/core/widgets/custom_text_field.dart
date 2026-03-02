import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final IconData? prefixIcon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextCapitalization textCapitalization;

  const CustomTextField({
    super.key,
    this.label,
    this.hintText,
    this.prefixIcon,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          textCapitalization: textCapitalization,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: Colors.grey, size: 20)
                : null,
            filled: true,
            fillColor: AppColors.primarySurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

