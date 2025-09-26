import 'package:intl/intl.dart';

class DateUtils {
  static final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  static final DateFormat _timeFormat = DateFormat('hh:mm a');
  static final DateFormat _shortFormat = DateFormat('MMM dd');

  /// Format a DateTime to a readable date string
  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  /// Format a DateTime to a readable time string
  static String formatTime(DateTime date) {
    return _timeFormat.format(date);
  }

  /// Format a DateTime to a short date string
  static String formatShortDate(DateTime date) {
    return _shortFormat.format(date);
  }

  /// Get a human-readable relative time string
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return months == 1 ? '1 month ago' : '$months months ago';
      } else {
        final years = (difference.inDays / 365).floor();
        return years == 1 ? '1 year ago' : '$years years ago';
      }
    } else if (difference.inHours > 0) {
      return difference.inHours == 1 ? '1 hour ago' : '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return difference.inMinutes == 1 ? '1 minute ago' : '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  /// Get a human-readable time until a future date
  static String getTimeUntil(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'Tomorrow';
      } else if (difference.inDays < 7) {
        return 'In ${difference.inDays} days';
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return weeks == 1 ? 'In 1 week' : 'In $weeks weeks';
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return months == 1 ? 'In 1 month' : 'In $months months';
      } else {
        final years = (difference.inDays / 365).floor();
        return years == 1 ? 'In 1 year' : 'In $years years';
      }
    } else if (difference.inHours > 0) {
      return difference.inHours == 1 ? 'In 1 hour' : 'In ${difference.inHours} hours';
    } else if (difference.inMinutes > 0) {
      return difference.inMinutes == 1 ? 'In 1 minute' : 'In ${difference.inMinutes} minutes';
    } else if (difference.inSeconds > 0) {
      return 'In ${difference.inSeconds} seconds';
    } else {
      return 'Now';
    }
  }

  /// Check if a date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  /// Check if a date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && 
           date.month == yesterday.month && 
           date.day == yesterday.day;
  }

  /// Check if a date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year && 
           date.month == tomorrow.month && 
           date.day == tomorrow.day;
  }

  /// Get the start of the day for a given date
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get the end of the day for a given date
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Get the start of the week for a given date (Monday)
  static DateTime startOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return startOfDay(date.subtract(Duration(days: daysFromMonday)));
  }

  /// Get the end of the week for a given date (Sunday)
  static DateTime endOfWeek(DateTime date) {
    final daysUntilSunday = 7 - date.weekday;
    return endOfDay(date.add(Duration(days: daysUntilSunday)));
  }

  /// Get the start of the month for a given date
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Get the end of the month for a given date
  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
  }

  /// Get a list of dates between two dates
  static List<DateTime> getDaysBetween(DateTime startDate, DateTime endDate) {
    final days = <DateTime>[];
    DateTime current = startOfDay(startDate);
    final end = startOfDay(endDate);

    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      days.add(current);
      current = current.add(const Duration(days: 1));
    }

    return days;
  }

  /// Get the number of days in a month
  static int getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  /// Check if a year is a leap year
  static bool isLeapYear(int year) {
    return (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
  }
}