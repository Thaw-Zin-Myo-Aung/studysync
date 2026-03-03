import 'package:flutter/foundation.dart';

@immutable
class ReplyModel {
  final String replyId;
  final String authorId;
  final String authorName;
  final String message;
  final String timestamp;

  const ReplyModel({
    required this.replyId,
    required this.authorId,
    required this.authorName,
    required this.message,
    required this.timestamp,
  });

  ReplyModel copyWith({
    String? replyId,
    String? authorId,
    String? authorName,
    String? message,
    String? timestamp,
  }) =>
      ReplyModel(
        replyId:    replyId    ?? this.replyId,
        authorId:   authorId   ?? this.authorId,
        authorName: authorName ?? this.authorName,
        message:    message    ?? this.message,
        timestamp:  timestamp  ?? this.timestamp,
      );

  factory ReplyModel.fromJson(Map<String, dynamic> json) {
    return ReplyModel(
      replyId:    json['replyId']    as String? ?? '',
      authorId:   json['authorId']   as String? ?? '',
      authorName: json['authorName'] as String? ?? '',
      message:    json['message']    as String? ?? '',
      timestamp:  json['timestamp']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'replyId':    replyId,
        'authorId':   authorId,
        'authorName': authorName,
        'message':    message,
        'timestamp':  timestamp,
      };
}

