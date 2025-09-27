import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class DateUtils {
  /// Format a DateTime to a readable date string with locale support
  static String formatDate(DateTime date, [Locale? locale]) {
    final format = DateFormat.yMMMd(locale?.languageCode ?? 'en');
    return format.format(date);
  }

  /// Format a DateTime to a readable time string with locale support  
  static String formatTime(DateTime date, [Locale? locale]) {
    final format = DateFormat.jm(locale?.languageCode ?? 'en');
    return format.format(date);
  }

  /// Format a DateTime to a short date string with locale support
  static String formatShortDate(DateTime date, [Locale? locale]) {
    final format = DateFormat.MMMd(locale?.languageCode ?? 'en');
    return format.format(date);
  }

  /// Get a human-readable relative time string with locale support
  static String getRelativeTime(DateTime date, [Locale? locale]) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return _getLocalizedRelativeTime('yesterday', locale);
      } else if (difference.inDays < 7) {
        return _getLocalizedRelativeTime('daysAgo', locale, difference.inDays);
      } else if (difference.inDays < 30) {
        final weeks = (difference.inDays / 7).floor();
        return weeks == 1 
            ? _getLocalizedRelativeTime('weekAgo', locale) 
            : _getLocalizedRelativeTime('weeksAgo', locale, weeks);
      } else if (difference.inDays < 365) {
        final months = (difference.inDays / 30).floor();
        return months == 1 
            ? _getLocalizedRelativeTime('monthAgo', locale)
            : _getLocalizedRelativeTime('monthsAgo', locale, months);
      } else {
        final years = (difference.inDays / 365).floor();
        return years == 1 
            ? _getLocalizedRelativeTime('yearAgo', locale)
            : _getLocalizedRelativeTime('yearsAgo', locale, years);
      }
    } else if (difference.inHours > 0) {
      return difference.inHours == 1 
          ? _getLocalizedRelativeTime('hourAgo', locale)
          : _getLocalizedRelativeTime('hoursAgo', locale, difference.inHours);
    } else if (difference.inMinutes > 0) {
      return difference.inMinutes == 1 
          ? _getLocalizedRelativeTime('minuteAgo', locale)
          : _getLocalizedRelativeTime('minutesAgo', locale, difference.inMinutes);
    } else {
      return _getLocalizedRelativeTime('justNow', locale);
    }
  }

  /// Helper method to get localized relative time strings
  static String _getLocalizedRelativeTime(String key, Locale? locale, [int? value]) {
    if (locale?.languageCode == 'sv') {
      switch (key) {
        case 'yesterday': return 'Igår';
        case 'justNow': return 'Nyss';
        case 'minuteAgo': return '1 minut sedan';
        case 'minutesAgo': return '$value minuter sedan';
        case 'hourAgo': return '1 timme sedan';
        case 'hoursAgo': return '$value timmar sedan';
        case 'daysAgo': return '$value dagar sedan';
        case 'weekAgo': return '1 vecka sedan';
        case 'weeksAgo': return '$value veckor sedan';
        case 'monthAgo': return '1 månad sedan';
        case 'monthsAgo': return '$value månader sedan';
        case 'yearAgo': return '1 år sedan';
        case 'yearsAgo': return '$value år sedan';
        default: return key;
      }
    }
    
    // Default English
    switch (key) {
      case 'yesterday': return 'Yesterday';
      case 'justNow': return 'Just now';
      case 'minuteAgo': return '1 minute ago';
      case 'minutesAgo': return '$value minutes ago';
      case 'hourAgo': return '1 hour ago';
      case 'hoursAgo': return '$value hours ago';
      case 'daysAgo': return '$value days ago';
      case 'weekAgo': return '1 week ago';
      case 'weeksAgo': return '$value weeks ago';
      case 'monthAgo': return '1 month ago';
      case 'monthsAgo': return '$value months ago';
      case 'yearAgo': return '1 year ago';
      case 'yearsAgo': return '$value years ago';
      default: return key;
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