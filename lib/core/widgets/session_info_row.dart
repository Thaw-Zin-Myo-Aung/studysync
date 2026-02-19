import 'package:flutter/material.dart';

class SessionInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const SessionInfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade500),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

