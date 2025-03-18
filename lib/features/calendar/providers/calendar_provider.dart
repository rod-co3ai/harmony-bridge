import 'package:flutter/material.dart';
import '../../../shared/models/event_model.dart';
import '../../../shared/models/child_model.dart';

/// Provider for calendar-related state and operations
class CalendarProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  DateTime _selectedDate = DateTime.now();
  List<EventModel> _events = [];
  List<ChildModel> _children = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime get selectedDate => _selectedDate;
  List<EventModel> get events => _events;
  List<ChildModel> get children => _children;

  // Get events for a specific date
  List<EventModel> getEventsForDate(DateTime date) {
    return _events.where((event) {
      final eventDate = event.startTime;
      return eventDate.year == date.year &&
          eventDate.month == date.month &&
          eventDate.day == date.day;
    }).toList();
  }

  // Get events for a specific month
  List<EventModel> getEventsForMonth(DateTime month) {
    return _events.where((event) {
      final eventDate = event.startTime;
      return eventDate.year == month.year && eventDate.month == month.month;
    }).toList();
  }

  // Get events for a specific child
  List<EventModel> getEventsForChild(String childId) {
    return _events
        .where((event) => event.childrenIds?.contains(childId) ?? false)
        .toList();
  }

  /// Set selected date
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  /// Load events
  Future<void> loadEvents({DateTime? startDate, DateTime? endDate}) async {
    _setLoading(true);
    _clearError();

    try {
      // Default date range is current month if not specified
      final now = DateTime.now();
      startDate ??= DateTime(now.year, now.month, 1);
      endDate ??= DateTime(now.year, now.month + 1, 0);

      // TODO: Implement actual data fetching from Supabase
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      // Mock data - will be replaced with actual implementation
      _events = _getMockEvents();
      _children = _getMockChildren();

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load events: ${e.toString()}');
      _setLoading(false);
    }
  }

  /// Create a new event
  Future<bool> createEvent(EventModel event) async {
    _setLoading(true);
    _clearError();

    try {
      // TODO: Implement actual event creation with Supabase
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      // Add to local list for now
      _events.add(event);

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to create event: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Update an existing event
  Future<bool> updateEvent(EventModel updatedEvent) async {
    _setLoading(true);
    _clearError();

    try {
      // TODO: Implement actual event update with Supabase
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      // Update in local list for now
      final index = _events.indexWhere((e) => e.id == updatedEvent.id);
      if (index != -1) {
        _events[index] = updatedEvent;
      } else {
        throw Exception('Event not found');
      }

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update event: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Delete an event
  Future<bool> deleteEvent(String eventId) async {
    _setLoading(true);
    _clearError();

    try {
      // TODO: Implement actual event deletion with Supabase
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      // Remove from local list for now
      _events.removeWhere((e) => e.id == eventId);

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete event: ${e.toString()}');
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
  List<EventModel> _getMockEvents() {
    final now = DateTime.now();
    return [
      EventModel(
        id: 'event-1',
        title: 'School Pickup',
        description: 'Pick up Emma from school',
        startTime: DateTime(now.year, now.month, now.day + 1, 15, 0),
        endTime: DateTime(now.year, now.month, now.day + 1, 15, 30),
        location: 'Springfield Elementary School',
        childrenIds: ['child-1'],
        isAllDay: false,
        reminders: [
          Reminder(minutesBefore: 30, method: ReminderMethod.notification),
        ],
        type: EventType.pickup,
        creatorId: 'user-123',
        participantIds: ['user-123', 'user-456'],
        createdAt: now.subtract(const Duration(days: 14)),
        updatedAt: now.subtract(const Duration(days: 7)),
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
        creatorId: 'user-456',
        participantIds: ['user-123', 'user-456'],
        createdAt: now.subtract(const Duration(days: 21)),
        updatedAt: now.subtract(const Duration(days: 14)),
      ),
      EventModel(
        id: 'event-3',
        title: 'Family Dinner',
        description: 'Weekly family dinner with both parents',
        startTime: DateTime(now.year, now.month, now.day + 3, 18, 0),
        endTime: DateTime(now.year, now.month, now.day + 3, 20, 0),
        location: 'Family Restaurant',
        childrenIds: ['child-1', 'child-2'],
        isAllDay: false,
        recurrence: EventRecurrence(type: RecurrenceType.weekly, interval: 1),
        reminders: [
          Reminder(minutesBefore: 120, method: ReminderMethod.notification),
        ],
        type: EventType.general,
        creatorId: 'user-123',
        participantIds: ['user-123', 'user-456'],
        createdAt: now.subtract(const Duration(days: 28)),
        updatedAt: now.subtract(const Duration(days: 21)),
      ),
      EventModel(
        id: 'event-4',
        title: 'Parent-Teacher Conference',
        description: 'Discuss Emma\'s progress',
        startTime: DateTime(now.year, now.month, now.day + 8, 16, 0),
        endTime: DateTime(now.year, now.month, now.day + 8, 16, 30),
        location: 'Springfield Elementary School',
        childrenIds: ['child-1'],
        isAllDay: false,
        recurrence: null,
        reminders: [
          Reminder(minutesBefore: 1440, method: ReminderMethod.notification),
          Reminder(minutesBefore: 60, method: ReminderMethod.notification),
        ],
        type: EventType.meeting,
        creatorId: 'user-123',
        participantIds: ['user-123'],
        createdAt: now.subtract(const Duration(days: 35)),
        updatedAt: now.subtract(const Duration(days: 28)),
      ),
      EventModel(
        id: 'event-5',
        title: 'Swimming Lessons',
        description: 'Weekly swimming class for Noah',
        startTime: DateTime(now.year, now.month, now.day + 3, 17, 0),
        endTime: DateTime(now.year, now.month, now.day + 3, 18, 0),
        location: 'Community Pool',
        childrenIds: ['child-2'],
        isAllDay: false,
        recurrence: EventRecurrence(
          type: RecurrenceType.weekly,
          interval: 1,
          until: DateTime(now.year, now.month + 3, now.day),
        ),
        reminders: [
          Reminder(minutesBefore: 60, method: ReminderMethod.notification),
        ],
        type: EventType.activity,
        creatorId: 'user-456',
        participantIds: ['user-123', 'user-456'],
        createdAt: now.subtract(const Duration(days: 42)),
        updatedAt: now.subtract(const Duration(days: 35)),
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
        createdAt: now.subtract(const Duration(days: 365)),
        updatedAt: now.subtract(const Duration(days: 30)),
      ),
      ChildModel(
        id: 'child-2',
        name: 'Noah Wilson',
        dateOfBirth: DateTime(2018, 9, 3),
        profileImageUrl: null,
        notes: 'Allergic to peanuts, enjoys dinosaurs',
        parentIds: ['user-123', 'user-456'],
        createdAt: now.subtract(const Duration(days: 365)),
        updatedAt: now.subtract(const Duration(days: 30)),
      ),
    ];
  }
}
