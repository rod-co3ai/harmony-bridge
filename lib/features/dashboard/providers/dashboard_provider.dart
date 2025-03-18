import 'package:flutter/material.dart';
import '../../../shared/models/child_model.dart';
import '../../../shared/models/event_model.dart';
import '../../../shared/models/message_model.dart';

/// Provider for dashboard-related state and operations
class DashboardProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  // Dashboard data
  List<ChildModel> _children = [];
  List<EventModel> _upcomingEvents = [];
  List<MessageModel> _recentMessages = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<ChildModel> get children => _children;
  List<EventModel> get upcomingEvents => _upcomingEvents;
  List<MessageModel> get recentMessages => _recentMessages;

  /// Load dashboard data
  Future<void> loadDashboardData() async {
    _setLoading(true);
    _clearError();

    try {
      // TODO: Implement actual data fetching from Supabase
      await Future.delayed(
        const Duration(seconds: 2),
      ); // Simulate network delay

      // Mock data - will be replaced with actual implementation
      _children = _getMockChildren();
      _upcomingEvents = _getMockEvents();
      _recentMessages = _getMockMessages();

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load dashboard data: ${e.toString()}');
      _setLoading(false);
    }
  }

  /// Refresh dashboard data
  Future<void> refreshDashboardData() async {
    await loadDashboardData();
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

  List<EventModel> _getMockEvents() {
    final now = DateTime.now();
    return [
      EventModel(
        id: 'event-1',
        title: 'School Pickup',
        description: 'Pick up Emma from school',
        startTime: DateTime(now.year, now.month, now.day + 1, 15, 0),
        endTime: DateTime(now.year, now.month, now.day + 1, 15, 30),
        location: 'Lincoln Elementary School',
        childrenIds: ['child-1'],
        isAllDay: false,
        recurrence: null,
        reminders: [
          Reminder(minutesBefore: 30, method: ReminderMethod.notification),
        ],
        type: EventType.pickup,
        creatorId: 'user-123',
        participantIds: ['user-123', 'user-456'],
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now,
      ),
      EventModel(
        id: 'event-2',
        title: 'Doctor Appointment',
        description: 'Annual checkup for Noah',
        startTime: DateTime(now.year, now.month, now.day + 2, 10, 0),
        endTime: DateTime(now.year, now.month, now.day + 2, 11, 0),
        location: 'Pediatric Center',
        childrenIds: ['child-2'],
        isAllDay: false,
        recurrence: null,
        reminders: [
          Reminder(minutesBefore: 60, method: ReminderMethod.notification),
          Reminder(minutesBefore: 1440, method: ReminderMethod.notification),
        ],
        type: EventType.medical,
        creatorId: 'user-123',
        participantIds: ['user-123', 'user-456'],
        createdAt: now.subtract(const Duration(days: 14)),
        updatedAt: now.subtract(const Duration(days: 7)),
      ),
      EventModel(
        id: 'event-3',
        title: 'Weekend Visit',
        description: 'Children staying with dad',
        startTime: DateTime(now.year, now.month, now.day + 3, 18, 0),
        endTime: DateTime(now.year, now.month, now.day + 5, 18, 0),
        location: 'Dad\'s House',
        childrenIds: ['child-1', 'child-2'],
        isAllDay: true,
        recurrence: null,
        reminders: [
          Reminder(minutesBefore: 1440, method: ReminderMethod.notification),
        ],
        type: EventType.vacation,
        creatorId: 'user-456',
        participantIds: ['user-123', 'user-456'],
        createdAt: now.subtract(const Duration(days: 21)),
        updatedAt: now.subtract(const Duration(days: 14)),
      ),
    ];
  }

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
    ];
  }
}
