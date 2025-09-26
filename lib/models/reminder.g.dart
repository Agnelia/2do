// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reminder _$ReminderFromJson(Map<String, dynamic> json) => Reminder(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      frequency: $enumDecode(_$ReminderFrequencyEnumMap, json['frequency']),
      time: TimeOfDay.fromJson(json['time'] as Map<String, dynamic>),
      nextDueDate: DateTime.parse(json['nextDueDate'] as String),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastCompleted: json['lastCompleted'] == null
          ? null
          : DateTime.parse(json['lastCompleted'] as String),
      completionCount: json['completionCount'] as int? ?? 0,
      weekday: json['weekday'] as int?,
      dayOfMonth: json['dayOfMonth'] as int?,
      customInterval: json['customInterval'] as int?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      priority:
          $enumDecodeNullable(_$ReminderPriorityEnumMap, json['priority']) ??
              ReminderPriority.medium,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$ReminderToJson(Reminder instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'frequency': _$ReminderFrequencyEnumMap[instance.frequency]!,
      'time': instance.time.toJson(),
      'nextDueDate': instance.nextDueDate.toIso8601String(),
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastCompleted': instance.lastCompleted?.toIso8601String(),
      'completionCount': instance.completionCount,
      'weekday': instance.weekday,
      'dayOfMonth': instance.dayOfMonth,
      'customInterval': instance.customInterval,
      'tags': instance.tags,
      'priority': _$ReminderPriorityEnumMap[instance.priority]!,
      'notes': instance.notes,
    };

const _$ReminderFrequencyEnumMap = {
  ReminderFrequency.daily: 'daily',
  ReminderFrequency.weekly: 'weekly',
  ReminderFrequency.monthly: 'monthly',
  ReminderFrequency.custom: 'custom',
};

const _$ReminderPriorityEnumMap = {
  ReminderPriority.low: 'low',
  ReminderPriority.medium: 'medium',
  ReminderPriority.high: 'high',
  ReminderPriority.urgent: 'urgent',
};

TimeOfDay _$TimeOfDayFromJson(Map<String, dynamic> json) => TimeOfDay(
      hour: json['hour'] as int,
      minute: json['minute'] as int,
    );

Map<String, dynamic> _$TimeOfDayToJson(TimeOfDay instance) => <String, dynamic>{
      'hour': instance.hour,
      'minute': instance.minute,
    };