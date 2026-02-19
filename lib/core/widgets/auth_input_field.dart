import 'package:flutter/material.dart';

class AuthInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final bool showToggle;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const AuthInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.showToggle = false,
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    if (showToggle) {
      return _ToggleableAuthInput(
        label: label, hintText: hintText, prefixIcon: prefixIcon,
        controller: controller, keyboardType: keyboardType,
      );
    }
    return _buildColumn(obscureText, null);
  }

  Widget _buildColumn(bool obscure, Widget? suffix) {
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
            fillColor: const Color(0xFFF0F4FF),
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            prefixIcon: Icon(prefixIcon, color: Colors.grey),
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}

class _ToggleableAuthInput extends StatefulWidget {
  final String label, hintText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const _ToggleableAuthInput({
    required this.label, required this.hintText, required this.prefixIcon,
    required this.controller, required this.keyboardType,
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
    )._buildColumn(_obscured, IconButton(
      icon: Icon(_obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey),
      onPressed: () => setState(() => _obscured = !_obscured),
    ));
  }
}

