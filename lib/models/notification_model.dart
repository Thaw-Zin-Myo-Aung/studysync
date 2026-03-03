import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
class NotificationModel {
  final String notifId;
  final String userId;       // recipient
  final String type;         // 'session_reminder' | 'group_invite' |
                             // 'discussion_post' | 'attendance_reminder' |
                             // 'match_request'
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic> data; // extra payload e.g. groupId, senderId

  const NotificationModel({
    required this.notifId,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    required this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notifId:   json['notifId']   as String,
      userId:    json['userId']    as String,
      type:      json['type']      as String,
      title:     json['title']     as String,
      body:      json['body']      as String,
      isRead:    json['isRead']    as bool? ?? false,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      data:      Map<String, dynamic>.from(json['data'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'notifId':   notifId,
    'userId':    userId,
    'type':      type,
    'title':     title,
    'body':      body,
    'isRead':    isRead,
    'createdAt': Timestamp.fromDate(createdAt),
    'data':      data,
  };

  NotificationModel copyWith({bool? isRead}) => NotificationModel(
    notifId:   notifId,
    userId:    userId,
    type:      type,
    title:     title,
    body:      body,
    isRead:    isRead ?? this.isRead,
    createdAt: createdAt,
    data:      data,
  );
}

