import 'package:flutter/material.dart';
import '../../../shared/models/message_model.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/models/child_model.dart';
import '../../../shared/models/conversation_model.dart';

/// Provider for messaging-related state and operations
class MessagingProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<MessageModel> _messages = [];
  List<UserModel> _contacts = [];
  List<ChildModel> _children = [];
  String? _currentConversationId;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<MessageModel> get messages => _messages;
  List<UserModel> get contacts => _contacts;
  List<ChildModel> get children => _children;
  String? get currentConversationId => _currentConversationId;

  // Virtual conversations based on unique senders/receivers
  List<ConversationModel> get conversations {
    final Map<String, Map<String, dynamic>> conversationsMap = {};

    // Group messages by conversation participants
    for (final message in _messages) {
      final otherUserId = message.senderId == UserModel.currentUserId
          ? message.receiverId
          : message.senderId;

      if (otherUserId == null) continue;

      if (!conversationsMap.containsKey(otherUserId)) {
        // Create new conversation entry
        conversationsMap[otherUserId] = {
          'participantId': otherUserId,
          'lastMessage': message,
          'unreadCount':
              message.senderId != UserModel.currentUserId && !message.isRead
                  ? 1
                  : 0,
        };
      } else {
        // Update existing conversation
        final existingConversation = conversationsMap[otherUserId]!;
        final lastMessage = existingConversation['lastMessage'] as MessageModel;

        // Update last message if this one is newer
        if (message.timestamp.isAfter(lastMessage.timestamp)) {
          existingConversation['lastMessage'] = message;
        }

        // Count unread messages
        if (message.senderId != UserModel.currentUserId && !message.isRead) {
          existingConversation['unreadCount'] =
              (existingConversation['unreadCount'] as int) + 1;
        }
      }
    }

    // Convert to list and sort by last message timestamp
    final mapList = conversationsMap.values.toList()
      ..sort((a, b) {
        final aTime = (a['lastMessage'] as MessageModel).timestamp;
        final bTime = (b['lastMessage'] as MessageModel).timestamp;
        return bTime.compareTo(aTime); // Sort by most recent first
      });

    // Convert Map<String, dynamic> to ConversationModel
    return mapList.map((map) {
      final lastMessage = map['lastMessage'] as MessageModel;
      final participant = getParticipant(map['participantId'] as String);

      return ConversationModel(
        id: '${UserModel.currentUserId}_${map['participantId']}',
        participantId: map['participantId'] as String,
        participantName: participant?.name ?? 'Unknown User',
        participantImageUrl: participant?.imageUrl,
        lastMessageText: lastMessage.content,
        lastMessageSenderId: lastMessage.senderId,
        lastMessageTime: lastMessage.timestamp,
        lastMessageHasAttachment: lastMessage.attachments != null &&
            lastMessage.attachments!.isNotEmpty,
        unreadCount: map['unreadCount'] as int,
        isOnline: participant?.isOnline,
      );
    }).toList();
  }

  /// Get a participant by ID
  UserModel? getParticipant(String participantId) {
    return _contacts.firstWhere(
      (contact) => contact.id == participantId,
      orElse: () => UserModel(
        id: participantId,
        name: 'Unknown User',
        email: 'unknown@example.com',
        phoneNumber: '',
        role: UserRole.parent,
        createdAt: DateTime.now(),
      ),
    );
  }

  /// Load conversations from the data source
  Future<void> loadConversations() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Implement actual data fetching from Supabase
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      // For now, we're using the existing messages
      // In a real implementation, this would fetch conversations from the backend

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Refresh conversations data
  Future<void> refreshConversations() async {
    return loadConversations();
  }

  // Get messages for a specific conversation
  List<MessageModel> getMessagesForConversation(
    String userId,
    String contactId,
  ) {
    return _messages
        .where(
          (message) =>
              (message.senderId == userId && message.receiverId == contactId) ||
              (message.senderId == contactId && message.receiverId == userId),
        )
        .toList()
      ..sort(
        (a, b) => b.timestamp.compareTo(a.timestamp),
      ); // Sort by timestamp descending
  }

  // Get messages related to a specific child
  List<MessageModel> getMessagesForChild(String childId) {
    return _messages
        .where(
          (message) =>
              message.metadata != null &&
              message.metadata!['childrenIds'] != null &&
              (message.metadata!['childrenIds'] as List<dynamic>).contains(
                childId,
              ),
        )
        .toList()
      ..sort(
        (a, b) => b.timestamp.compareTo(a.timestamp),
      ); // Sort by timestamp descending
  }

  /// Set current conversation
  void setCurrentConversation(String conversationId) {
    _currentConversationId = conversationId;
    notifyListeners();
  }

  /// Load messages
  Future<void> loadMessages(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      // TODO: Implement actual data fetching from Supabase
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      // Mock data - will be replaced with actual implementation
      _messages = _getMockMessages();
      _contacts = _getMockContacts();
      _children = _getMockChildren();

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load messages: ${e.toString()}');
      _setLoading(false);
    }
  }

  /// Send a new message
  Future<bool> sendMessage(MessageModel message) async {
    _setLoading(true);
    _clearError();

    try {
      // TODO: Implement actual message sending with Supabase
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      // Add to local list for now
      _messages.add(message);

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to send message: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Mark messages as read
  Future<bool> markMessagesAsRead(String conversationId, String userId) async {
    _setLoading(true);
    _clearError();

    try {
      // TODO: Implement actual message status update with Supabase
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate network delay

      // Update in local list for now
      for (int i = 0; i < _messages.length; i++) {
        if (_messages[i].receiverId == userId &&
            _messages[i].status != MessageStatus.read) {
          _messages[i] = _messages[i].copyWith(status: MessageStatus.read);
        }
      }

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to mark messages as read: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Delete a message
  Future<bool> deleteMessage(String messageId) async {
    _setLoading(true);
    _clearError();

    try {
      // TODO: Implement actual message deletion with Supabase
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      // Remove from local list for now
      _messages.removeWhere((m) => m.id == messageId);

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete message: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  // Mock data generators
  List<MessageModel> _getMockMessages() {
    final now = DateTime.now();
    return [
      MessageModel(
        id: 'msg-1',
        senderId: 'user-456',
        receiverId: 'user-123',
        content:
            'Emma forgot her science textbook at my place. I\'ll drop it off tomorrow.',
        timestamp: now.subtract(const Duration(hours: 2)),
        status: MessageStatus.read,
        type: MessageType.text,
        attachments: [],
        metadata: {
          'childrenIds': ['child-1'],
        },
      ),
      MessageModel(
        id: 'msg-2',
        senderId: 'user-123',
        receiverId: 'user-456',
        content:
            'Thanks for letting me know. I\'ll remind her to check her backpack next time.',
        timestamp: now.subtract(const Duration(hours: 1, minutes: 45)),
        status: MessageStatus.read,
        type: MessageType.text,
        attachments: [],
        metadata: {
          'childrenIds': ['child-1'],
        },
      ),
      MessageModel(
        id: 'msg-3',
        senderId: 'user-456',
        receiverId: 'user-123',
        content:
            'Noah\'s soccer practice has been moved to 4pm on Thursdays starting next week.',
        timestamp: now.subtract(const Duration(minutes: 30)),
        status: MessageStatus.delivered,
        type: MessageType.text,
        attachments: [],
        metadata: {
          'childrenIds': ['child-2'],
        },
      ),
      MessageModel(
        id: 'msg-4',
        senderId: 'user-123',
        receiverId: 'user-456',
        content:
            'I\'ve attached Noah\'s updated medication schedule from the doctor.',
        timestamp: now.subtract(const Duration(days: 2, hours: 5)),
        status: MessageStatus.read,
        type: MessageType.text,
        attachments: ['medication_schedule.pdf'],
        metadata: {
          'childrenIds': ['child-2'],
        },
      ),
      MessageModel(
        id: 'msg-5',
        senderId: 'user-456',
        receiverId: 'user-123',
        content:
            'Emma did great at her recital yesterday! Here are some photos.',
        timestamp: now.subtract(const Duration(days: 1, hours: 12)),
        status: MessageStatus.read,
        type: MessageType.text,
        attachments: ['recital_photo_1.jpg', 'recital_photo_2.jpg'],
        metadata: {
          'childrenIds': ['child-1'],
        },
      ),
    ];
  }

  List<UserModel> _getMockContacts() {
    final now = DateTime.now();
    return [
      UserModel(
        id: 'user-456',
        name: 'Alex Wilson',
        email: 'co-parent@example.com',
        profileImageUrl: null,
        phoneNumber: '(555) 123-4567',
        createdAt: now.subtract(const Duration(days: 365)),
        updatedAt: now,
      ),
    ];
  }

  List<ChildModel> _getMockChildren() {
    final now = DateTime.now();
    return [
      ChildModel(
        id: 'child-1',
        name: 'Emma Wilson',
        dateOfBirth: DateTime(2015, 5, 12),
        profileImageUrl: null,
        notes: 'Loves drawing and swimming',
        parentIds: ['user-123', 'user-456'],
        createdAt: now,
        updatedAt: now,
      ),
      ChildModel(
        id: 'child-2',
        name: 'Noah Wilson',
        dateOfBirth: DateTime(2018, 9, 3),
        profileImageUrl: null,
        notes: 'Allergic to peanuts, enjoys dinosaurs',
        parentIds: ['user-123', 'user-456'],
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }
}
