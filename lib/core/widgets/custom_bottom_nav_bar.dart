import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {'activeIcon': LucideIcons.house,   'inactiveIcon': LucideIcons.house,   'label': 'Home'},
      {'activeIcon': LucideIcons.compass, 'inactiveIcon': LucideIcons.compass, 'label': 'Discover'},
      {'activeIcon': LucideIcons.users,   'inactiveIcon': LucideIcons.users,   'label': 'Groups'},
      {'activeIcon': LucideIcons.user,    'inactiveIcon': LucideIcons.user,    'label': 'Profile'},
    ];

    return Container(
      height: 64,
      color: AppColors.primary,
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(items.length, (index) {
            final isActive = index == currentIndex;
            final iconColor = isActive
                ? Colors.white
                : Colors.white.withValues(alpha: 0.55);
            final labelColor = isActive
                ? Colors.white
                : Colors.white.withValues(alpha: 0.55);
            final iconSize = isActive ? 22.0 : 20.0;

            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(index),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        items[index]['activeIcon'] as IconData,
                        size: iconSize,
                        color: iconColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      items[index]['label'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                        color: labelColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
