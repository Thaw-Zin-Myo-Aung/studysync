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
        Text(label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 13),
            filled: true,
            fillColor: AppColors.primarySurface,
            border: InputBorder.none,
            enabledBorder: border,
            focusedBorder: border,
            // Shrink the prefix icon box so it doesn't eat horizontal space
            prefixIconConstraints:
                const BoxConstraints(minWidth: 40, minHeight: 40),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(prefixIcon, color: Colors.grey, size: 18),
            ),
            // Reduce internal horizontal padding to give text more room
            contentPadding: const EdgeInsets.symmetric(
                vertical: 14, horizontal: 4),
            suffixIcon: suffix,
            isDense: true,
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(LucideIcons.triangleAlert, size: 13, color: AppColors.error),
              const SizedBox(width: 4),
              Flexible(
                child: Text(errorText!,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.error)),
              ),
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
      label: widget.label,
      hintText: widget.hintText,
      prefixIcon: widget.prefixIcon,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _obscured,
      errorText: widget.errorText,
      hasError: widget.hasError,
    )._buildColumn(
      _obscured,
      IconButton(
        icon: Icon(
          _obscured
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: Colors.grey,
          size: 18,
        ),
        onPressed: () => setState(() => _obscured = !_obscured),
      ),
    );
  }
}
