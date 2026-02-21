import 'package:flutter/material.dart';

class MemberAvatarStack extends StatelessWidget {
  final List<String> initials;
  final int extraCount;

  const MemberAvatarStack({
    super.key,
    required this.initials,
    this.extraCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final totalItems = initials.length + (extraCount > 0 ? 1 : 0);
    final width = totalItems * 16.0 + 12;

    return SizedBox(
      width: width,
      height: 28,
      child: Stack(
        children: [
          ...initials.asMap().entries.map((entry) {
            return Positioned(
              left: entry.key * 16.0,
              child: CircleAvatar(
                radius: 14,
                backgroundColor: const Color(0xFFE2E8F0),
                child: Text(
                  entry.value,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            );
          }),
          if (extraCount > 0)
            Positioned(
              left: initials.length * 16.0,
              child: CircleAvatar(
                radius: 14,
                backgroundColor: const Color(0xFFCBD5E1),
                child: Text(
                  '+$extraCount',
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

