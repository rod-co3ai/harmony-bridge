import 'package:intl/intl.dart';

/// Utility functions for date and time operations
class AppDateUtils {
  /// Format a date to a readable string (e.g., "Mar 18, 2025")
  static String formatDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }
  
  /// Format a date to show day of week and date (e.g., "Tuesday, Mar 18")
  static String formatDayAndDate(DateTime date) {
    return DateFormat('EEEE, MMM d').format(date);
  }
  
  /// Format time to 12-hour format (e.g., "3:30 PM")
  static String formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }
  
  /// Format date and time (e.g., "Mar 18, 2025 at 3:30 PM")
  static String formatDateAndTime(DateTime dateTime) {
    return DateFormat('MMM d, yyyy \'at\' h:mm a').format(dateTime);
  }
  
  /// Get relative time (e.g., "2 hours ago", "Just now", "Yesterday")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 2) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return formatDate(dateTime);
    }
  }
  
  /// Check if a date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
  
  /// Check if a date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day;
  }
  
  /// Check if a date is in the past
  static bool isPast(DateTime date) {
    final now = DateTime.now();
    return date.isBefore(DateTime(now.year, now.month, now.day));
  }
  
  /// Get the next occurrence of a specific day of week
  static DateTime getNextDayOfWeek(int dayOfWeek) {
    final now = DateTime.now();
    int daysUntilNextDay = (dayOfWeek - now.weekday) % 7;
    if (daysUntilNextDay == 0) {
      daysUntilNextDay = 7;
    }
    return now.add(Duration(days: daysUntilNextDay));
  }
}
