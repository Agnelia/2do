import 'package:flutter/foundation.dart';
import 'package:todo_health_reminders/models/reminder.dart';
import 'package:todo_health_reminders/services/storage_service.dart';

class ReminderProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<Reminder> _reminders = [];

  List<Reminder> get reminders => _reminders;
  
  List<Reminder> get upcomingReminders {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return _reminders
        .where((reminder) => 
            reminder.nextDueDate.isAfter(today.subtract(const Duration(days: 1))) &&
            reminder.isActive)
        .toList()
      ..sort((a, b) => a.nextDueDate.compareTo(b.nextDueDate));
  }

  int get todayReminderCount {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    
    return _reminders
        .where((reminder) => 
            reminder.nextDueDate.isAfter(today) &&
            reminder.nextDueDate.isBefore(tomorrow) &&
            reminder.isActive)
        .length;
  }

  int get completedTodayCount {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return _reminders
        .where((reminder) => 
            reminder.lastCompleted != null &&
            reminder.lastCompleted!.isAfter(today) &&
            reminder.lastCompleted!.isBefore(today.add(const Duration(days: 1))))
        .length;
  }

  Future<void> loadReminders() async {
    try {
      _reminders = await _storageService.loadReminders();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading reminders: $e');
    }
  }

  Future<void> addReminder(Reminder reminder) async {
    try {
      _reminders.add(reminder);
      await _storageService.saveReminders(_reminders);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding reminder: $e');
    }
  }

  Future<void> updateReminder(Reminder updatedReminder) async {
    try {
      final index = _reminders.indexWhere((r) => r.id == updatedReminder.id);
      if (index != -1) {
        _reminders[index] = updatedReminder;
        await _storageService.saveReminders(_reminders);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating reminder: $e');
    }
  }

  Future<void> deleteReminder(String id) async {
    try {
      _reminders.removeWhere((reminder) => reminder.id == id);
      await _storageService.saveReminders(_reminders);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting reminder: $e');
    }
  }

  Future<void> completeReminder(String id) async {
    try {
      final index = _reminders.indexWhere((r) => r.id == id);
      if (index != -1) {
        final reminder = _reminders[index];
        final updatedReminder = reminder.copyWith(
          lastCompleted: DateTime.now(),
          completionCount: reminder.completionCount + 1,
        );
        
        // Calculate next due date based on frequency
        final nextDue = _calculateNextDueDate(updatedReminder);
        final finalReminder = updatedReminder.copyWith(nextDueDate: nextDue);
        
        _reminders[index] = finalReminder;
        await _storageService.saveReminders(_reminders);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error completing reminder: $e');
    }
  }

  Future<void> snoozeReminder(String id, Duration duration) async {
    try {
      final index = _reminders.indexWhere((r) => r.id == id);
      if (index != -1) {
        final reminder = _reminders[index];
        final snoozedUntil = DateTime.now().add(duration);
        final updatedReminder = reminder.copyWith(
          nextDueDate: snoozedUntil,
        );
        
        _reminders[index] = updatedReminder;
        await _storageService.saveReminders(_reminders);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error snoozing reminder: $e');
    }
  }

  Future<void> toggleReminderActive(String id) async {
    try {
      final index = _reminders.indexWhere((r) => r.id == id);
      if (index != -1) {
        final reminder = _reminders[index];
        final updatedReminder = reminder.copyWith(isActive: !reminder.isActive);
        
        _reminders[index] = updatedReminder;
        await _storageService.saveReminders(_reminders);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error toggling reminder: $e');
    }
  }

  DateTime _calculateNextDueDate(Reminder reminder) {
    final now = DateTime.now();
    
    switch (reminder.frequency) {
      case ReminderFrequency.daily:
        return DateTime(now.year, now.month, now.day + 1, 
                       reminder.time.hour, reminder.time.minute);
      case ReminderFrequency.weekly:
        final daysUntilNext = (reminder.weekday - now.weekday + 7) % 7;
        final nextWeek = daysUntilNext == 0 ? 7 : daysUntilNext;
        return DateTime(now.year, now.month, now.day + nextWeek,
                       reminder.time.hour, reminder.time.minute);
      case ReminderFrequency.monthly:
        var nextMonth = DateTime(now.year, now.month + 1, reminder.dayOfMonth);
        if (nextMonth.month != now.month + 1) {
          // Handle cases where the day doesn't exist in the next month
          nextMonth = DateTime(now.year, now.month + 2, 0); // Last day of next month
        }
        return DateTime(nextMonth.year, nextMonth.month, nextMonth.day,
                       reminder.time.hour, reminder.time.minute);
      case ReminderFrequency.custom:
        return now.add(Duration(days: reminder.customInterval ?? 1));
    }
  }

  List<Reminder> getRemindersByCategory(String category) {
    return _reminders.where((reminder) => reminder.category == category).toList();
  }

  Map<String, int> getCategoryStats() {
    final stats = <String, int>{};
    for (final reminder in _reminders) {
      stats[reminder.category] = (stats[reminder.category] ?? 0) + 1;
    }
    return stats;
  }
}