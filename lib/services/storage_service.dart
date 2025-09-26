import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_health_reminders/models/reminder.dart';

class StorageService {
  static const String _remindersKey = 'health_reminders';

  Future<List<Reminder>> loadReminders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_remindersKey);
      
      if (jsonString == null) {
        return _getDefaultReminders();
      }
      
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Reminder.fromJson(json)).toList();
    } catch (e) {
      // If there's an error loading, return default reminders
      return _getDefaultReminders();
    }
  }

  Future<void> saveReminders(List<Reminder> reminders) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = reminders.map((reminder) => reminder.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await prefs.setString(_remindersKey, jsonString);
    } catch (e) {
      throw Exception('Failed to save reminders: $e');
    }
  }

  Future<void> clearAllReminders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_remindersKey);
    } catch (e) {
      throw Exception('Failed to clear reminders: $e');
    }
  }

  List<Reminder> _getDefaultReminders() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return [
      Reminder(
        id: '1',
        title: 'Take Morning Vitamins',
        description: 'Take your daily multivitamin and vitamin D supplement',
        category: 'Medication',
        frequency: ReminderFrequency.daily,
        time: const TimeOfDay(hour: 8, minute: 0),
        nextDueDate: today.add(const Duration(days: 1, hours: 8)),
        createdAt: now,
        tags: ['vitamins', 'supplements', 'morning'],
        priority: ReminderPriority.high,
        notes: 'Take with breakfast for better absorption',
      ),
      Reminder(
        id: '2',
        title: 'Drink Water',
        description: 'Drink a glass of water to stay hydrated',
        category: 'Water',
        frequency: ReminderFrequency.custom,
        customInterval: 1,
        time: const TimeOfDay(hour: 10, minute: 0),
        nextDueDate: today.add(const Duration(hours: 10)),
        createdAt: now,
        tags: ['hydration', 'water'],
        priority: ReminderPriority.medium,
      ),
      Reminder(
        id: '3',
        title: 'Exercise - Morning Walk',
        description: '30-minute walk around the neighborhood',
        category: 'Exercise',
        frequency: ReminderFrequency.daily,
        time: const TimeOfDay(hour: 7, minute: 0),
        nextDueDate: today.add(const Duration(days: 1, hours: 7)),
        createdAt: now,
        tags: ['cardio', 'walking', 'morning'],
        priority: ReminderPriority.high,
        notes: 'Weather permitting, try to walk outdoors',
      ),
      Reminder(
        id: '4',
        title: 'Meditation',
        description: '10 minutes of mindfulness meditation',
        category: 'Mental Health',
        frequency: ReminderFrequency.daily,
        time: const TimeOfDay(hour: 19, minute: 0),
        nextDueDate: today.add(const Duration(hours: 19)),
        createdAt: now,
        tags: ['mindfulness', 'relaxation', 'evening'],
        priority: ReminderPriority.medium,
        notes: 'Use the Headspace app or similar',
      ),
      Reminder(
        id: '5',
        title: 'Healthy Lunch',
        description: 'Eat a balanced lunch with vegetables and protein',
        category: 'Nutrition',
        frequency: ReminderFrequency.daily,
        time: const TimeOfDay(hour: 12, minute: 30),
        nextDueDate: today.add(const Duration(hours: 12, minutes: 30)),
        createdAt: now,
        tags: ['nutrition', 'lunch', 'vegetables'],
        priority: ReminderPriority.medium,
      ),
      Reminder(
        id: '6',
        title: 'Bedtime Routine',
        description: 'Start winding down for sleep',
        category: 'Sleep',
        frequency: ReminderFrequency.daily,
        time: const TimeOfDay(hour: 22, minute: 0),
        nextDueDate: today.add(const Duration(hours: 22)),
        createdAt: now,
        tags: ['sleep', 'routine', 'bedtime'],
        priority: ReminderPriority.high,
        notes: 'No screens 1 hour before bed',
      ),
    ];
  }

  // Additional utility methods
  Future<void> exportReminders() async {
    try {
      final reminders = await loadReminders();
      final jsonString = json.encode(reminders.map((r) => r.toJson()).toList());
      // This would typically save to a file or share the data
      // For now, we'll just return the JSON string
      print('Export data: $jsonString');
    } catch (e) {
      throw Exception('Failed to export reminders: $e');
    }
  }

  Future<void> importReminders(String jsonString) async {
    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      final reminders = jsonList.map((json) => Reminder.fromJson(json)).toList();
      await saveReminders(reminders);
    } catch (e) {
      throw Exception('Failed to import reminders: $e');
    }
  }

  Future<Map<String, dynamic>> getStorageStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_remindersKey);
      
      return {
        'totalReminders': jsonString != null ? (json.decode(jsonString) as List).length : 0,
        'dataSize': jsonString?.length ?? 0,
        'lastModified': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'totalReminders': 0,
        'dataSize': 0,
        'lastModified': DateTime.now().toIso8601String(),
      };
    }
  }
}