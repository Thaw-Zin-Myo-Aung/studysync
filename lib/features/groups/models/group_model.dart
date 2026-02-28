import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class GroupModel {
  final String id;
  final String name;
  final String subject;
  final String nextSession;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final List<String> memberInitials;
  final int extraMemberCount;
  final bool hasUnread;

  const GroupModel({
    required this.id,
    required this.name,
    required this.subject,
    required this.nextSession,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.memberInitials,
    required this.extraMemberCount,
    required this.hasUnread,
  });
}

const List<GroupModel> mockGroups = [
  GroupModel(
    id: 'finals-web',
    name: 'Finals Prep - Web',
    subject: 'Web Development',
    nextSession: 'Tomorrow, 10:00 AM',
    icon: LucideIcons.code,
    iconBgColor: Color(0xFFF3E8FF),
    iconColor: Color(0xFF9333EA),
    memberInitials: ['A', 'B', 'C'],
    extraMemberCount: 1,
    hasUnread: true,
  ),
  GroupModel(
    id: 'calculus-review',
    name: 'Calculus Review',
    subject: 'Calculus I',
    nextSession: 'Wed, 2:00 PM',
    icon: LucideIcons.calculator,
    iconBgColor: Color(0xFFFFF7ED),
    iconColor: Color(0xFFF97316),
    memberInitials: ['A', 'B', 'C'],
    extraMemberCount: 0,
    hasUnread: false,
  ),
  GroupModel(
    id: 'history-study',
    name: 'History Study',
    subject: 'World History',
    nextSession: 'Friday, 1:00 PM',
    icon: LucideIcons.bookOpen,
    iconBgColor: Color(0xFFF0FDF4),
    iconColor: Color(0xFF16A34A),
    memberInitials: ['A', 'B', 'C'],
    extraMemberCount: 2,
    hasUnread: true,
  ),
];

