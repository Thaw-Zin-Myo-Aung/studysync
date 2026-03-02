import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/app_colors.dart';

class AuthInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final bool showToggle;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? errorText;
  final bool hasError;

  const AuthInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.showToggle = false,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    if (showToggle) {
      return _ToggleableAuthInput(
        label: label, hintText: hintText, prefixIcon: prefixIcon,
        controller: controller, keyboardType: keyboardType,
        errorText: errorText, hasError: hasError,
      );
    }
    return _buildColumn(obscureText, null);
  }

  Widget _buildColumn(bool obscure, Widget? suffix) {
    final border = hasError
        ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.error, width: 1.5))
        : OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: AppColors.primarySurface,
            border: InputBorder.none,
            enabledBorder: border,
            focusedBorder: border,
            prefixIcon: Icon(prefixIcon, color: Colors.grey),
            suffixIcon: suffix,
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(LucideIcons.triangleAlert, size: 13, color: AppColors.error),
              const SizedBox(width: 4),
              Text(errorText!, style: const TextStyle(fontSize: 12, color: AppColors.error)),
            ],
          ),
        ],
      ],
    );
  }
}

class _ToggleableAuthInput extends StatefulWidget {
  final String label, hintText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? errorText;
  final bool hasError;

  const _ToggleableAuthInput({
    required this.label, required this.hintText, required this.prefixIcon,
    required this.controller, required this.keyboardType,
    this.errorText, this.hasError = false,
  });

  @override
  State<_ToggleableAuthInput> createState() => _ToggleableAuthInputState();
}

class _ToggleableAuthInputState extends State<_ToggleableAuthInput> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    return AuthInputField(
      label: widget.label, hintText: widget.hintText, prefixIcon: widget.prefixIcon,
      controller: widget.controller, keyboardType: widget.keyboardType, obscureText: _obscured,
      errorText: widget.errorText, hasError: widget.hasError,
    )._buildColumn(_obscured, IconButton(
      icon: Icon(_obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey),
      onPressed: () => setState(() => _obscured = !_obscured),
    ));
  }
}
