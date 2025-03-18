/// Conversation model representing a chat between two users
class ConversationModel {
  final String id;
  final String participantId;
  final String participantName;
  final String? participantImageUrl;
  final String lastMessageText;
  final String lastMessageSenderId;
  final DateTime lastMessageTime;
  final bool lastMessageHasAttachment;
  final int unreadCount;
  final bool? isOnline;

  ConversationModel({
    required this.id,
    required this.participantId,
    required this.participantName,
    this.participantImageUrl,
    required this.lastMessageText,
    required this.lastMessageSenderId,
    required this.lastMessageTime,
    this.lastMessageHasAttachment = false,
    this.unreadCount = 0,
    this.isOnline,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'],
      participantId: json['participant_id'],
      participantName: json['participant_name'],
      participantImageUrl: json['participant_image_url'],
      lastMessageText: json['last_message_text'],
      lastMessageSenderId: json['last_message_sender_id'],
      lastMessageTime: DateTime.parse(json['last_message_time']),
      lastMessageHasAttachment: json['last_message_has_attachment'] ?? false,
      unreadCount: json['unread_count'] ?? 0,
      isOnline: json['is_online'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participant_id': participantId,
      'participant_name': participantName,
      'participant_image_url': participantImageUrl,
      'last_message_text': lastMessageText,
      'last_message_sender_id': lastMessageSenderId,
      'last_message_time': lastMessageTime.toIso8601String(),
      'last_message_has_attachment': lastMessageHasAttachment,
      'unread_count': unreadCount,
      'is_online': isOnline,
    };
  }

  ConversationModel copyWith({
    String? id,
    String? participantId,
    String? participantName,
    String? participantImageUrl,
    String? lastMessageText,
    String? lastMessageSenderId,
    DateTime? lastMessageTime,
    bool? lastMessageHasAttachment,
    int? unreadCount,
    bool? isOnline,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      participantId: participantId ?? this.participantId,
      participantName: participantName ?? this.participantName,
      participantImageUrl: participantImageUrl ?? this.participantImageUrl,
      lastMessageText: lastMessageText ?? this.lastMessageText,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastMessageHasAttachment: lastMessageHasAttachment ?? this.lastMessageHasAttachment,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
