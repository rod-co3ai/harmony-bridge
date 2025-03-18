import 'package:uuid/uuid.dart';

/// Message model representing a message in the co-parenting app
class MessageModel {
  final String id;
  final String senderId;
  final String? receiverId;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final MessageStatus status;
  final List<String>? attachments;
  final String? parentMessageId;
  final Map<String, dynamic>? metadata;
  final bool isAiGenerated;
  final SentimentAnalysis? sentimentAnalysis;

  /// Returns true if the message has been read
  bool get isRead => status == MessageStatus.read;

  MessageModel({
    String? id,
    required this.senderId,
    this.receiverId,
    required this.content,
    DateTime? timestamp,
    this.type = MessageType.text,
    this.status = MessageStatus.sent,
    this.attachments,
    this.parentMessageId,
    this.metadata,
    this.isAiGenerated = false,
    this.sentimentAnalysis,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      type: MessageType.values.firstWhere(
        (type) => type.toString() == 'MessageType.${json['type']}',
        orElse: () => MessageType.text,
      ),
      status: MessageStatus.values.firstWhere(
        (status) => status.toString() == 'MessageStatus.${json['status']}',
        orElse: () => MessageStatus.sent,
      ),
      attachments: json['attachments'] != null
          ? List<String>.from(json['attachments'])
          : null,
      parentMessageId: json['parent_message_id'],
      metadata: json['metadata'],
      isAiGenerated: json['is_ai_generated'] ?? false,
      sentimentAnalysis: json['sentiment_analysis'] != null
          ? SentimentAnalysis.fromJson(json['sentiment_analysis'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'attachments': attachments,
      'parent_message_id': parentMessageId,
      'metadata': metadata,
      'is_ai_generated': isAiGenerated,
      'sentiment_analysis': sentimentAnalysis?.toJson(),
    };
  }

  MessageModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? content,
    DateTime? timestamp,
    MessageType? type,
    MessageStatus? status,
    List<String>? attachments,
    String? parentMessageId,
    Map<String, dynamic>? metadata,
    bool? isAiGenerated,
    SentimentAnalysis? sentimentAnalysis,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      status: status ?? this.status,
      attachments: attachments ?? this.attachments,
      parentMessageId: parentMessageId ?? this.parentMessageId,
      metadata: metadata ?? this.metadata,
      isAiGenerated: isAiGenerated ?? this.isAiGenerated,
      sentimentAnalysis: sentimentAnalysis ?? this.sentimentAnalysis,
    );
  }
}

/// Enum representing the type of message
enum MessageType {
  text,
  image,
  document,
  audio,
  video,
  location,
  contact,
  event,
  task,
  reminder,
  aiSuggestion,
}

/// Enum representing the status of a message
enum MessageStatus { sending, sent, delivered, read, failed }

/// Class representing sentiment analysis of a message
class SentimentAnalysis {
  final double score; // -1.0 (very negative) to 1.0 (very positive)
  final String sentiment; // 'positive', 'negative', 'neutral'
  final Map<String, double>? emotions; // e.g., {'anger': 0.2, 'joy': 0.7}
  final List<String>? keywords;
  final String? summary;

  SentimentAnalysis({
    required this.score,
    required this.sentiment,
    this.emotions,
    this.keywords,
    this.summary,
  });

  factory SentimentAnalysis.fromJson(Map<String, dynamic> json) {
    return SentimentAnalysis(
      score: json['score'].toDouble(),
      sentiment: json['sentiment'],
      emotions: json['emotions'] != null
          ? Map<String, double>.from(json['emotions'])
          : null,
      keywords:
          json['keywords'] != null ? List<String>.from(json['keywords']) : null,
      summary: json['summary'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'sentiment': sentiment,
      'emotions': emotions,
      'keywords': keywords,
      'summary': summary,
    };
  }
}
