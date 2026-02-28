import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PastSession {
  final String date;
  final String time;
  final String location;
  final bool attended;

  const PastSession({
    required this.date,
    required this.time,
    required this.location,
    required this.attended,
  });
}

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

  // Session fields
  final String upcomingDate;
  final String upcomingTimeRange;
  final String upcomingLocation;
  final String upcomingLocationDetail;
  final int upcomingAttendees;
  final int upcomingTotal;
  final List<PastSession> pastSessions;

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
    required this.upcomingDate,
    required this.upcomingTimeRange,
    required this.upcomingLocation,
    required this.upcomingLocationDetail,
    required this.upcomingAttendees,
    required this.upcomingTotal,
    required this.pastSessions,
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
    upcomingDate: 'Tomorrow, Mar 2',
    upcomingTimeRange: '10:00 AM - 12:00 PM',
    upcomingLocation: 'Computer Lab B',
    upcomingLocationDetail: '2nd Floor, Building 1',
    upcomingAttendees: 3,
    upcomingTotal: 4,
    pastSessions: [
      PastSession(date: 'Monday, Feb 24', time: '10:00 AM', location: 'Computer Lab B', attended: true),
      PastSession(date: 'Monday, Feb 17', time: '10:00 AM', location: 'Computer Lab B', attended: true),
      PastSession(date: 'Monday, Feb 10', time: '10:00 AM', location: 'Online', attended: false),
    ],
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
    upcomingDate: 'Wednesday, Mar 4',
    upcomingTimeRange: '2:00 PM - 4:00 PM',
    upcomingLocation: 'Library 2nd Floor',
    upcomingLocationDetail: 'Study Room A',
    upcomingAttendees: 2,
    upcomingTotal: 3,
    pastSessions: [
      PastSession(date: 'Wednesday, Feb 26', time: '2:00 PM', location: 'Library 2F', attended: true),
      PastSession(date: 'Wednesday, Feb 19', time: '2:00 PM', location: 'Library 2F', attended: false),
    ],
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
    upcomingDate: 'Friday, Mar 6',
    upcomingTimeRange: '1:00 PM - 3:00 PM',
    upcomingLocation: 'Library 3rd Floor',
    upcomingLocationDetail: 'Study Room B',
    upcomingAttendees: 4,
    upcomingTotal: 5,
    pastSessions: [
      PastSession(date: 'Friday, Feb 28', time: '1:00 PM', location: 'Library 3F', attended: true),
      PastSession(date: 'Friday, Feb 21', time: '1:00 PM', location: 'Library 3F', attended: true),
      PastSession(date: 'Friday, Feb 14', time: '1:00 PM', location: 'Online', attended: false),
    ],
  ),
];
