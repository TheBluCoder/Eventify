import '../../app/app_constants.dart';

/// Centralized date and time formatting utilities
/// Used across the application for consistent date/time display
class DateTimeFormatter {
  /// Format date and time with day name (e.g., "Mon, Jan 15, 2024 at 3:00 PM")
  static String formatFullDateTime(DateTime dateTime) {
    final dayName = AppConstants.dayNames[dateTime.weekday - 1];
    final month = AppConstants.monthNames[dateTime.month - 1];
    final day = dateTime.day;
    final year = dateTime.year;
    final time = formatTime(dateTime);

    return '$dayName, $month $day, $year at $time';
  }

  /// Format time only with AM/PM (e.g., "3:00 PM")
  static String formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  /// Format date only (e.g., "Jan 15, 2024")
  static String formatDateOnly(DateTime dateTime) {
    final month = AppConstants.monthNames[dateTime.month - 1];
    return '$month ${dateTime.day}, ${dateTime.year}';
  }

  /// Format short date and time (e.g., "Jan 15 at 3:00 PM")
  static String formatShortDateTime(DateTime dateTime) {
    final month = AppConstants.monthNames[dateTime.month - 1];
    final day = dateTime.day;
    final time = formatTime(dateTime);

    return '$month $day at $time';
  }

  /// Format recurring days (e.g., "Mon, Wed, Fri" or "Every day")
  /// Days are represented as integers: 1=Monday, 7=Sunday
  static String formatRecurringDays(List<int> days) {
    if (days.isEmpty) return 'No days selected';
    if (days.length == 7) return 'Every day';

    final sortedDays = List<int>.from(days)..sort();
    final dayNamesFormatted = sortedDays.map((day) => AppConstants.dayNames[day - 1]);

    return dayNamesFormatted.join(', ');
  }

  /// Format time range (e.g., "3:00 PM - 5:00 PM")
  static String formatTimeRange(DateTime startTime, DateTime endTime) {
    return '${formatTime(startTime)} - ${formatTime(endTime)}';
  }

  /// Format date range (e.g., "Jan 15 - Jan 20, 2024")
  static String formatDateRange(DateTime startDate, DateTime endDate) {
    if (startDate.year == endDate.year && startDate.month == endDate.month) {
      final month = AppConstants.monthNames[startDate.month - 1];
      return '$month ${startDate.day} - ${endDate.day}, ${startDate.year}';
    } else if (startDate.year == endDate.year) {
      final startMonth = AppConstants.monthNames[startDate.month - 1];
      final endMonth = AppConstants.monthNames[endDate.month - 1];
      return '$startMonth ${startDate.day} - $endMonth ${endDate.day}, ${startDate.year}';
    } else {
      final startMonth = AppConstants.monthNames[startDate.month - 1];
      final endMonth = AppConstants.monthNames[endDate.month - 1];
      return '$startMonth ${startDate.day}, ${startDate.year} - $endMonth ${endDate.day}, ${endDate.year}';
    }
  }

  /// Format relative time (e.g., "2 hours ago", "3 days ago")
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }
}
