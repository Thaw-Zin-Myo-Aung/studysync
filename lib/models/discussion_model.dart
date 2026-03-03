import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class DiscussionModel {
  final String discussionId;
  final String groupId;
  final String authorId;
  final String authorName;
  final String topic;
  final String message;
  final String timestamp;
  final int replyCount;
  final int likeCount;
  final List<String> likedBy; // list of userIds who liked

  const DiscussionModel({
    required this.discussionId,
    required this.groupId,
    required this.authorId,
    required this.authorName,
    required this.topic,
    required this.message,
    required this.timestamp,
    required this.replyCount,
    this.likeCount = 0,
    this.likedBy = const [],
  });

  DiscussionModel copyWith({
    String? discussionId,
    String? groupId,
    String? authorId,
    String? authorName,
    String? topic,
    String? message,
    String? timestamp,
    int? replyCount,
    int? likeCount,
    List<String>? likedBy,
  }) =>
      DiscussionModel(
        discussionId: discussionId ?? this.discussionId,
        groupId:      groupId      ?? this.groupId,
        authorId:     authorId     ?? this.authorId,
        authorName:   authorName   ?? this.authorName,
        topic:        topic        ?? this.topic,
        message:      message      ?? this.message,
        timestamp:    timestamp    ?? this.timestamp,
        replyCount:   replyCount   ?? this.replyCount,
        likeCount:    likeCount    ?? this.likeCount,
        likedBy:      likedBy      ?? this.likedBy,
      );

  factory DiscussionModel.fromJson(Map<String, dynamic> json) {
    return DiscussionModel(
      discussionId: json['discussionId'] as String? ?? '',
      groupId:      json['groupId']      as String? ?? '',
      authorId:     json['authorId']     as String? ?? '',
      authorName:   json['authorName']   as String? ?? '',
      topic:        json['topic']        as String? ?? '',
      message:      json['message']      as String? ?? '',
      timestamp:    _parseTimestamp(json['timestamp']),
      replyCount:   json['replyCount']   as int?    ?? 0,
      likeCount:    json['likeCount']    as int?    ?? 0,
      likedBy:      List<String>.from(json['likedBy'] as List? ?? []),
    );
  }

  static String _parseTimestamp(dynamic value) {
    if (value == null) return '';
    if (value is Timestamp) return value.toDate().toIso8601String();
    if (value is String) return value;
    return '';
  }

  Map<String, dynamic> toJson() => {
        'discussionId': discussionId,
        'groupId':      groupId,
        'authorId':     authorId,
        'authorName':   authorName,
        'topic':        topic,
        'message':      message,
        'timestamp':    timestamp,
        'replyCount':   replyCount,
        'likeCount':    likeCount,
        'likedBy':      likedBy,
      };
}

