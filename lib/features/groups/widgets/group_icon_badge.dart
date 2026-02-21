import 'package:flutter/material.dart';

class GroupIconBadge extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const GroupIconBadge({
    super.key,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: iconColor, size: 26),
    );
  }
}

