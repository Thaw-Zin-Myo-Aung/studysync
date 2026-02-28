import 'package:flutter/material.dart';

class MatchReasonRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String boldText;

  const MatchReasonRow({super.key, required this.icon, required this.label, this.boldText = ''});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade400),
        const SizedBox(width: 10),
        Expanded(
          child: boldText.isEmpty
              ? Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade700))
              : Text.rich(
                  TextSpan(
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                    children: [
                      TextSpan(text: label),
                      TextSpan(text: boldText, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

