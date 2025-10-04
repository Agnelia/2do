import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_health_reminders/providers/work_hours_provider.dart';

void main() {
  group('WorkHoursProvider Tests', () {
    test('Default work hours should be 9:00 to 17:00', () async {
      final provider = WorkHoursProvider();
      
      // Wait for initial load
      await Future.delayed(const Duration(milliseconds: 100));
      
      expect(provider.startTime.hour, 9);
      expect(provider.startTime.minute, 0);
      expect(provider.endTime.hour, 17);
      expect(provider.endTime.minute, 0);
    });

    test('Should calculate correct reminder times for single reminder', () {
      final provider = WorkHoursProvider();
      
      final times = provider.calculateReminderTimes(1);
      
      expect(times.length, 1);
      // Should be at midpoint of work day (13:00)
      expect(times[0].hour, 13);
    });

    test('Should calculate correct reminder times for multiple reminders', () {
      final provider = WorkHoursProvider();
      
      final times = provider.calculateReminderTimes(3);
      
      expect(times.length, 3);
      // Times should be evenly distributed
      expect(times[0].hour, greaterThanOrEqualTo(9));
      expect(times[2].hour, lessThanOrEqualTo(17));
    });

    test('Should handle zero or negative count', () {
      final provider = WorkHoursProvider();
      
      expect(provider.calculateReminderTimes(0), isEmpty);
      expect(provider.calculateReminderTimes(-1), isEmpty);
    });

    test('Should update work hours correctly', () async {
      final provider = WorkHoursProvider();
      
      const newStart = TimeOfDay(hour: 8, minute: 30);
      const newEnd = TimeOfDay(hour: 16, minute: 30);
      
      await provider.setWorkHours(newStart, newEnd);
      
      expect(provider.startTime, newStart);
      expect(provider.endTime, newEnd);
    });
  });
}
