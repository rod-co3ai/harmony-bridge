import 'package:uuid/uuid.dart';

/// Event model representing a calendar event in the co-parenting app
class EventModel {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final EventType type;
  final EventRecurrence? recurrence;
  final String creatorId;
  final List<String> participantIds;
  final List<String>? childrenIds;
  final String? location;
  final Map<String, dynamic>? metadata;
  final bool isAllDay;
  final List<Reminder>? reminders;
  final DateTime createdAt;
  final DateTime updatedAt;

  EventModel({
    String? id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    required this.type,
    this.recurrence,
    required this.creatorId,
    required this.participantIds,
    this.childrenIds,
    this.location,
    this.metadata,
    this.isAllDay = false,
    this.reminders,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      type: EventType.values.firstWhere(
        (type) => type.toString() == 'EventType.${json['type']}',
        orElse: () => EventType.general,
      ),
      recurrence:
          json['recurrence'] != null
              ? EventRecurrence.fromJson(json['recurrence'])
              : null,
      creatorId: json['creator_id'],
      participantIds: List<String>.from(json['participant_ids'] ?? []),
      childrenIds:
          json['children_ids'] != null
              ? List<String>.from(json['children_ids'])
              : null,
      location: json['location'],
      metadata: json['metadata'],
      isAllDay: json['is_all_day'] ?? false,
      reminders:
          json['reminders'] != null
              ? (json['reminders'] as List)
                  .map((reminder) => Reminder.fromJson(reminder))
                  .toList()
              : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'type': type.toString().split('.').last,
      'recurrence': recurrence?.toJson(),
      'creator_id': creatorId,
      'participant_ids': participantIds,
      'children_ids': childrenIds,
      'location': location,
      'metadata': metadata,
      'is_all_day': isAllDay,
      'reminders': reminders?.map((reminder) => reminder.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    EventType? type,
    EventRecurrence? recurrence,
    String? creatorId,
    List<String>? participantIds,
    List<String>? childrenIds,
    String? location,
    Map<String, dynamic>? metadata,
    bool? isAllDay,
    List<Reminder>? reminders,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      type: type ?? this.type,
      recurrence: recurrence ?? this.recurrence,
      creatorId: creatorId ?? this.creatorId,
      participantIds: participantIds ?? this.participantIds,
      childrenIds: childrenIds ?? this.childrenIds,
      location: location ?? this.location,
      metadata: metadata ?? this.metadata,
      isAllDay: isAllDay ?? this.isAllDay,
      reminders: reminders ?? this.reminders,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Enum representing the type of event
enum EventType {
  general,
  pickup,
  dropoff,
  school,
  medical,
  activity,
  birthday,
  holiday,
  vacation,
  meeting,
  other,
}

/// Class representing event recurrence
class EventRecurrence {
  final RecurrenceType type;
  final int? interval;
  final List<int>? daysOfWeek; // 1 = Monday, 7 = Sunday
  final int? dayOfMonth;
  final int? monthOfYear;
  final DateTime? until;
  final int? count;

  EventRecurrence({
    required this.type,
    this.interval = 1,
    this.daysOfWeek,
    this.dayOfMonth,
    this.monthOfYear,
    this.until,
    this.count,
  });

  factory EventRecurrence.fromJson(Map<String, dynamic> json) {
    return EventRecurrence(
      type: RecurrenceType.values.firstWhere(
        (type) => type.toString() == 'RecurrenceType.${json['type']}',
        orElse: () => RecurrenceType.none,
      ),
      interval: json['interval'],
      daysOfWeek:
          json['days_of_week'] != null
              ? List<int>.from(json['days_of_week'])
              : null,
      dayOfMonth: json['day_of_month'],
      monthOfYear: json['month_of_year'],
      until: json['until'] != null ? DateTime.parse(json['until']) : null,
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'interval': interval,
      'days_of_week': daysOfWeek,
      'day_of_month': dayOfMonth,
      'month_of_year': monthOfYear,
      'until': until?.toIso8601String(),
      'count': count,
    };
  }
}

/// Enum representing the type of recurrence
enum RecurrenceType { none, daily, weekly, monthly, yearly }

/// Class representing a reminder for an event
class Reminder {
  final int minutesBefore;
  final ReminderMethod method;

  Reminder({required this.minutesBefore, required this.method});

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      minutesBefore: json['minutes_before'],
      method: ReminderMethod.values.firstWhere(
        (method) => method.toString() == 'ReminderMethod.${json['method']}',
        orElse: () => ReminderMethod.notification,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minutes_before': minutesBefore,
      'method': method.toString().split('.').last,
    };
  }
}

/// Enum representing the method of reminder
enum ReminderMethod { notification, email, sms }
