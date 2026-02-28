import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class GroupsHeader extends StatelessWidget {
  final int groupCount;

  const GroupsHeader({
    super.key,
    required this.groupCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: RichText(
        text: const TextSpan(
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: 'My ',
              style: TextStyle(color: Colors.black87),
            ),
            TextSpan(
              text: 'Groups',
              style: TextStyle(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
