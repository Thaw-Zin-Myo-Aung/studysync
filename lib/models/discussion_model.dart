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

  const DiscussionModel({
    required this.discussionId,
    required this.groupId,
    required this.authorId,
    required this.authorName,
    required this.topic,
    required this.message,
    required this.timestamp,
    required this.replyCount,
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
      );

  factory DiscussionModel.fromJson(Map<String, dynamic> json) {
    return DiscussionModel(
      discussionId: json['discussionId'] as String? ?? '',
      groupId:      json['groupId']      as String? ?? '',
      authorId:     json['authorId']     as String? ?? '',
      authorName:   json['authorName']   as String? ?? '',
      topic:        json['topic']        as String? ?? '',
      message:      json['message']      as String? ?? '',
      timestamp:    json['timestamp']?.toString()   ?? '',
      replyCount:   json['replyCount']   as int?    ?? 0,
    );
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
      };
}

