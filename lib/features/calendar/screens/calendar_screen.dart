import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/event_model.dart';
import '../../../shared/widgets/app_bottom_nav.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../providers/calendar_provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _currentNavIndex = 1;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  
  @override
  void initState() {
    super.initState();
    // Load events when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CalendarProvider>(context, listen: false).loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final calendarProvider = Provider.of<CalendarProvider>(context);
    final selectedEvents = calendarProvider.getEventsForDate(_selectedDay);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
        ],
      ),
      body: calendarProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Calendar
                _buildCalendar(calendarProvider),
                
                // Events list
                Expanded(
                  child: _buildEventsList(selectedEvents),
                ),
              ],
            ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentNavIndex,
        onTap: _handleNavigation,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEventDialog(context);
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
  
  Widget _buildCalendar(CalendarProvider calendarProvider) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
        // Load events for the new month
        calendarProvider.loadEvents(
          startDate: DateTime(focusedDay.year, focusedDay.month, 1),
          endDate: DateTime(focusedDay.year, focusedDay.month + 1, 0),
        );
      },
      eventLoader: (day) {
        return calendarProvider.getEventsForDate(day);
      },
      calendarStyle: CalendarStyle(
        markersMaxCount: 3,
        markerDecoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: AppColors.primary.withAlpha(70),
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: HeaderStyle(
        formatButtonDecoration: BoxDecoration(
          color: AppColors.primary.withAlpha(70),
          borderRadius: BorderRadius.circular(16),
        ),
        formatButtonTextStyle: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildEventsList(List<EventModel> events) {
    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: AppColors.textSecondary.withAlpha(100),
            ),
            const SizedBox(height: 16),
            Text(
              'No events for this day',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              onPressed: () {
                _showAddEventDialog(context);
              },
              text: 'Add Event',
              icon: Icons.add,
              type: AppButtonType.outlined,
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return _buildEventCard(event);
      },
    );
  }
  
  Widget _buildEventCard(EventModel event) {
    final formattedTime = event.isAllDay 
        ? 'All day' 
        : '${_formatTime(event.startTime)} - ${_formatTime(event.endTime)}';
    
    return AppCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Row(
          children: [
            Expanded(
              child: Text(
                event.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getEventColor(event).withAlpha(30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                formattedTime,
                style: TextStyle(
                  fontSize: 12,
                  color: _getEventColor(event),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.description != null && event.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  event.description!,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            if (event.location != null && event.location!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.location!,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (event.childrenIds != null && event.childrenIds!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Wrap(
                  spacing: 8,
                  children: event.childrenIds?.map((childId) {
                    // TODO: Get child name from provider
                    return Chip(
                      label: Text(
                        childId == 'child-1' ? 'Emma' : 'Noah',
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      backgroundColor: AppColors.background,
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList() ?? [],
                ),
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 'edit') {
              // TODO: Implement edit event
            } else if (value == 'delete') {
              _showDeleteConfirmation(context, event);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 18),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 18, color: AppColors.error),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: AppColors.error)),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          // TODO: Navigate to event details
        },
      ),
    );
  }
  
  void _handleNavigation(int index) {
    if (index == _currentNavIndex) return;
    
    setState(() {
      _currentNavIndex = index;
    });
    
    switch (index) {
      case 0: // Dashboard
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
      case 1: // Calendar - already here
        break;
      case 2: // Messages
        Navigator.pushReplacementNamed(context, '/messaging');
        break;
      case 3: // Profile
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }
  
  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Events'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TODO: Implement filters
              const Text('Filter options will be implemented here'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Apply filters
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }
  
  void _showAddEventDialog(BuildContext context) {
    // TODO: Implement add event dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Event'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Event creation form will be implemented here'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Create event
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
  
  void _showDeleteConfirmation(BuildContext context, EventModel event) {
    final calendarProvider = Provider.of<CalendarProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Event'),
          content: Text('Are you sure you want to delete "${event.title}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await calendarProvider.deleteEvent(event.id);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }
  
  // Helper methods
  String _formatTime(DateTime time) {
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
  
  Color _getEventColor(EventModel event) {
    if (event.title.toLowerCase().contains('doctor') || 
        event.title.toLowerCase().contains('appointment') ||
        event.title.toLowerCase().contains('medical')) {
      return Colors.red;
    } else if (event.title.toLowerCase().contains('school') || 
               event.title.toLowerCase().contains('class') ||
               event.title.toLowerCase().contains('teacher')) {
      return Colors.blue;
    } else if (event.title.toLowerCase().contains('pickup') || 
               event.title.toLowerCase().contains('drop') ||
               event.title.toLowerCase().contains('transport')) {
      return Colors.orange;
    } else if (event.title.toLowerCase().contains('visit') || 
               event.title.toLowerCase().contains('stay') ||
               event.title.toLowerCase().contains('weekend')) {
      return Colors.purple;
    } else {
      return AppColors.primary;
    }
  }
}
