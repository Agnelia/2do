import 'package:flutter/foundation.dart';
import 'package:todo_health_reminders/models/reminder.dart';
import 'package:todo_health_reminders/services/storage_service.dart';

class StatisticsProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<Reminder> _reminders = [];
  
  // Cache for statistics to avoid recalculation
  int? _cachedCompletedToday;
  int? _cachedTotalToday;
  int? _cachedOverdueToday;
  DateTime? _lastCacheUpdate;

  int get completedToday {
    _updateCacheIfNeeded();
    return _cachedCompletedToday ?? 0;
  }

  int get totalToday {
    _updateCacheIfNeeded();
    return _cachedTotalToday ?? 0;
  }

  int get overdueToday {
    _updateCacheIfNeeded();
    return _cachedOverdueToday ?? 0;
  }

  int get weeklyStreak {
    return _calculateWeeklyStreak();
  }

  int get healthScore {
    return _calculateHealthScore();
  }

  int get totalCompleted {
    return _reminders.fold(0, (sum, reminder) => sum + reminder.completionCount);
  }

  double get successRate {
    final totalReminders = _reminders.length;
    if (totalReminders == 0) return 0.0;
    
    final activeReminders = _reminders.where((r) => r.isActive).length;
    return (activeReminders / totalReminders) * 100;
  }

  int get bestStreak {
    return _calculateBestStreak();
  }

  double get dailyProgress {
    if (totalToday == 0) return 1.0;
    return completedToday / totalToday;
  }

  Map<String, int> get categoryBreakdown {
    final breakdown = <String, int>{};
    for (final reminder in _reminders) {
      breakdown[reminder.category] = (breakdown[reminder.category] ?? 0) + reminder.completionCount;
    }
    return breakdown;
  }

  void updateReminders(List<Reminder> reminders) {
    _reminders = reminders;
    _invalidateCache();
    notifyListeners();
  }

  void _updateCacheIfNeeded() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (_lastCacheUpdate == null || 
        _lastCacheUpdate!.isBefore(today) || 
        _cachedCompletedToday == null) {
      _calculateTodayStats();
      _lastCacheUpdate = now;
    }
  }

  void _calculateTodayStats() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    // Completed today
    _cachedCompletedToday = _reminders
        .where((reminder) => 
            reminder.lastCompleted != null &&
            reminder.lastCompleted!.isAfter(today) &&
            reminder.lastCompleted!.isBefore(tomorrow))
        .length;

    // Total scheduled for today
    _cachedTotalToday = _reminders
        .where((reminder) => 
            reminder.isActive &&
            reminder.nextDueDate.isAfter(today.subtract(const Duration(hours: 1))) &&
            reminder.nextDueDate.isBefore(tomorrow))
        .length;

    // Overdue today
    _cachedOverdueToday = _reminders
        .where((reminder) => 
            reminder.isActive &&
            reminder.nextDueDate.isBefore(now) &&
            (reminder.lastCompleted == null || 
             reminder.lastCompleted!.isBefore(today)))
        .length;
  }

  void _invalidateCache() {
    _cachedCompletedToday = null;
    _cachedTotalToday = null;
    _cachedOverdueToday = null;
    _lastCacheUpdate = null;
  }

  int _calculateWeeklyStreak() {
    final now = DateTime.now();
    int streak = 0;
    
    for (int i = 0; i < 7; i++) {
      final day = now.subtract(Duration(days: i));
      final dayStart = DateTime(day.year, day.month, day.day);
      final dayEnd = dayStart.add(const Duration(days: 1));
      
      final hadReminders = _reminders.any((reminder) => 
          reminder.nextDueDate.isAfter(dayStart) &&
          reminder.nextDueDate.isBefore(dayEnd) &&
          reminder.isActive);
      
      if (!hadReminders) continue;
      
      final completedOnDay = _reminders.any((reminder) => 
          reminder.lastCompleted != null &&
          reminder.lastCompleted!.isAfter(dayStart) &&
          reminder.lastCompleted!.isBefore(dayEnd));
      
      if (completedOnDay) {
        streak++;
      } else {
        break;
      }
    }
    
    return streak;
  }

  int _calculateHealthScore() {
    if (_reminders.isEmpty) return 100;
    
    final now = DateTime.now();
    final last30Days = now.subtract(const Duration(days: 30));
    
    final recentReminders = _reminders.where((reminder) => 
        reminder.createdAt.isAfter(last30Days)).toList();
    
    if (recentReminders.isEmpty) return 100;
    
    final totalExpected = recentReminders.length * 30; // Assume daily for simplicity
    final totalCompleted = recentReminders.fold(0, 
        (sum, reminder) => sum + reminder.completionCount);
    
    final score = (totalCompleted / totalExpected * 100).clamp(0, 100);
    return score.round();
  }

  int _calculateBestStreak() {
    if (_reminders.isEmpty) return 0;
    
    int bestStreak = 0;
    int currentStreak = 0;
    
    // Sort all completion dates
    final allCompletions = <DateTime>[];
    for (final reminder in _reminders) {
      if (reminder.lastCompleted != null) {
        allCompletions.add(reminder.lastCompleted!);
      }
    }
    
    allCompletions.sort();
    
    for (int i = 0; i < allCompletions.length; i++) {
      if (i == 0) {
        currentStreak = 1;
      } else {
        final prevDay = DateTime(
          allCompletions[i - 1].year,
          allCompletions[i - 1].month,
          allCompletions[i - 1].day,
        );
        final currentDay = DateTime(
          allCompletions[i].year,
          allCompletions[i].month,
          allCompletions[i].day,
        );
        
        if (currentDay.difference(prevDay).inDays == 1) {
          currentStreak++;
        } else {
          currentStreak = 1;
        }
      }
      
      bestStreak = currentStreak > bestStreak ? currentStreak : bestStreak;
    }
    
    return bestStreak;
  }

  List<ChartData> getChartData(String period) {
    final now = DateTime.now();
    final data = <ChartData>[];
    
    switch (period) {
      case 'Week':
        for (int i = 6; i >= 0; i--) {
          final day = now.subtract(Duration(days: i));
          final dayStart = DateTime(day.year, day.month, day.day);
          final dayEnd = dayStart.add(const Duration(days: 1));
          
          final completed = _reminders
              .where((reminder) => 
                  reminder.lastCompleted != null &&
                  reminder.lastCompleted!.isAfter(dayStart) &&
                  reminder.lastCompleted!.isBefore(dayEnd))
              .length;
          
          data.add(ChartData(
            label: _getDayLabel(day),
            value: completed.toDouble(),
            date: day,
          ));
        }
        break;
        
      case 'Month':
        for (int i = 29; i >= 0; i--) {
          final day = now.subtract(Duration(days: i));
          final dayStart = DateTime(day.year, day.month, day.day);
          final dayEnd = dayStart.add(const Duration(days: 1));
          
          final completed = _reminders
              .where((reminder) => 
                  reminder.lastCompleted != null &&
                  reminder.lastCompleted!.isAfter(dayStart) &&
                  reminder.lastCompleted!.isBefore(dayEnd))
              .length;
          
          data.add(ChartData(
            label: '${day.day}',
            value: completed.toDouble(),
            date: day,
          ));
        }
        break;
        
      case 'Year':
        for (int i = 11; i >= 0; i--) {
          final month = DateTime(now.year, now.month - i, 1);
          final monthEnd = DateTime(month.year, month.month + 1, 1);
          
          final completed = _reminders
              .where((reminder) => 
                  reminder.lastCompleted != null &&
                  reminder.lastCompleted!.isAfter(month) &&
                  reminder.lastCompleted!.isBefore(monthEnd))
              .length;
          
          data.add(ChartData(
            label: _getMonthLabel(month),
            value: completed.toDouble(),
            date: month,
          ));
        }
        break;
    }
    
    return data;
  }

  double getCategoryPercentage(String category) {
    final total = categoryBreakdown.values.fold(0, (sum, value) => sum + value);
    if (total == 0) return 0.0;
    
    final categoryValue = categoryBreakdown[category] ?? 0;
    return (categoryValue / total) * 100;
  }

  String _getDayLabel(DateTime date) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[date.weekday % 7];
  }

  String _getMonthLabel(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[date.month - 1];
  }
}

class ChartData {
  final String label;
  final double value;
  final DateTime date;

  ChartData({
    required this.label,
    required this.value,
    required this.date,
  });
}