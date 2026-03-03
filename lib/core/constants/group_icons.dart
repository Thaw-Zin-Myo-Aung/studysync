import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Predefined group icons the admin can choose from.
/// The key is stored in Firestore as [StudyGroupModel.iconName].
class GroupIcons {
  GroupIcons._();

  static const Map<String, IconData> all = {
    'users':       LucideIcons.users,
    'book-open':   LucideIcons.bookOpen,
    'code':        LucideIcons.code,
    'calculator':  LucideIcons.calculator,
    'flask':       LucideIcons.flaskConical,
    'microscope':  LucideIcons.microscope,
    'pencil':      LucideIcons.pencil,
    'lightbulb':   LucideIcons.lightbulb,
    'brain':       LucideIcons.brain,
    'globe':       LucideIcons.globe,
    'music':       LucideIcons.music,
    'palette':     LucideIcons.palette,
    'cpu':         LucideIcons.cpu,
    'atom':        LucideIcons.atom,
    'graduation':  LucideIcons.graduationCap,
    'rocket':      LucideIcons.rocket,
    'target':      LucideIcons.target,
    'trophy':      LucideIcons.trophy,
    'star':        LucideIcons.star,
    'zap':         LucideIcons.zap,
  };

  static IconData resolve(String? key) => all[key] ?? LucideIcons.users;

  static const Map<String, Color> colors = {
    'users':       Color(0xFF2563EB),
    'book-open':   Color(0xFF7C3AED),
    'code':        Color(0xFF0891B2),
    'calculator':  Color(0xFFF97316),
    'flask':       Color(0xFF16A34A),
    'microscope':  Color(0xFF0D9488),
    'pencil':      Color(0xFFCA8A04),
    'lightbulb':   Color(0xFFEA580C),
    'brain':       Color(0xFF9333EA),
    'globe':       Color(0xFF2563EB),
    'music':       Color(0xFFDB2777),
    'palette':     Color(0xFF7C3AED),
    'cpu':         Color(0xFF0891B2),
    'atom':        Color(0xFF0D9488),
    'graduation':  Color(0xFF2563EB),
    'rocket':      Color(0xFFEA580C),
    'target':      Color(0xFFDC2626),
    'trophy':      Color(0xFFCA8A04),
    'star':        Color(0xFF9333EA),
    'zap':         Color(0xFFCA8A04),
  };

  static Color resolveColor(String? key) =>
      colors[key] ?? const Color(0xFF2563EB);
}
