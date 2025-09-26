
import 'package:flutter/material.dart' as flutter show TimeOfDay;
import 'package:json_annotation/json_annotation.dart';

part 'reminder.g.dart';

@JsonSerializable()
class Reminder {
  final String id;
  final String title;
  final String description;
  final String category;
  final ReminderFrequency frequency;
  final R_TimeOfDay time;
  final DateTime nextDueDate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastCompleted;
  final int completionCount;
  final int? weekday; // For weekly reminders (1-7, Monday to Sunday)
  final int? dayOfMonth; // For monthly reminders (1-31)
  final int? customInterval; // For custom frequency in days
  final List<String> tags;
  final ReminderPriority priority;
  final String? notes;

  const Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.frequency,
    required this.time,
    required this.nextDueDate,
    this.isActive = true,
    required this.createdAt,
    this.lastCompleted,
    this.completionCount = 0,
    this.weekday,
    this.dayOfMonth,
    this.customInterval,
    this.tags = const [],
    this.priority = ReminderPriority.medium,
    this.notes,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) => _$ReminderFromJson(json);
  Map<String, dynamic> toJson() => _$ReminderToJson(this);

  Reminder copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
  ReminderFrequency? frequency,
    R_TimeOfDay? time,
    DateTime? nextDueDate,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastCompleted,
    int? completionCount,
    int? weekday,
    int? dayOfMonth,
    int? customInterval,
    List<String>? tags,
    ReminderPriority? priority,
    String? notes,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      frequency: frequency ?? this.frequency,
  time: time ?? this.time,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastCompleted: lastCompleted ?? this.lastCompleted,
      completionCount: completionCount ?? this.completionCount,
      weekday: weekday ?? this.weekday,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      customInterval: customInterval ?? this.customInterval,
      tags: tags ?? this.tags,
      priority: priority ?? this.priority,
      notes: notes ?? this.notes,
    );
  }

  bool get isOverdue {
    return nextDueDate.isBefore(DateTime.now()) && isActive;
  }

  bool get isDueToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    
    return nextDueDate.isAfter(today) && nextDueDate.isBefore(tomorrow);
  }

  String get formattedTime {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
  }

  String get frequencyDescription {
    switch (frequency) {
      case ReminderFrequency.daily:
        return 'Daily';
      case ReminderFrequency.weekly:
        return 'Weekly';
      case ReminderFrequency.monthly:
        return 'Monthly';
      case ReminderFrequency.custom:
        return customInterval != null ? 'Every $customInterval days' : 'Custom';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Reminder &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

enum ReminderFrequency {
  daily,
  weekly,
  monthly,
  custom,
}

enum ReminderPriority {
  low,
  medium,
  high,
  urgent,
}



@JsonSerializable()
class R_TimeOfDay {
  final int hour;
  final int minute;

  const R_TimeOfDay({
    required this.hour,
    required this.minute,
  });

  factory R_TimeOfDay.fromJson(Map<String, dynamic> json) => _$R_TimeOfDayFromJson(json);
  Map<String, dynamic> toJson() => _$R_TimeOfDayToJson(this);

  factory R_TimeOfDay.fromFlutterTimeOfDay(flutter.TimeOfDay timeOfDay) {
    return R_TimeOfDay(
      hour: timeOfDay.hour,
      minute: timeOfDay.minute,
    );
  }

  flutter.TimeOfDay toFlutterTimeOfDay() {
    return flutter.TimeOfDay(hour: hour, minute: minute);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is R_TimeOfDay &&
          runtimeType == other.runtimeType &&
          hour == other.hour &&
          minute == other.minute;

  @override
  int get hashCode => hour.hashCode ^ minute.hashCode;
}