import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkHoursProvider with ChangeNotifier {
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);
  bool _isLoaded = false;

  TimeOfDay get startTime => _startTime;
  TimeOfDay get endTime => _endTime;

  WorkHoursProvider() {
    _loadWorkHours();
  }

  Future<void> _loadWorkHours() async {
    if (_isLoaded) return;
    
    final prefs = await SharedPreferences.getInstance();
    final startHour = prefs.getInt('work_hours_start_hour') ?? 9;
    final startMinute = prefs.getInt('work_hours_start_minute') ?? 0;
    final endHour = prefs.getInt('work_hours_end_hour') ?? 17;
    final endMinute = prefs.getInt('work_hours_end_minute') ?? 0;

    _startTime = TimeOfDay(hour: startHour, minute: startMinute);
    _endTime = TimeOfDay(hour: endHour, minute: endMinute);
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> setWorkHours(TimeOfDay start, TimeOfDay end) async {
    _startTime = start;
    _endTime = end;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('work_hours_start_hour', start.hour);
    await prefs.setInt('work_hours_start_minute', start.minute);
    await prefs.setInt('work_hours_end_hour', end.hour);
    await prefs.setInt('work_hours_end_minute', end.minute);

    notifyListeners();
  }

  // Calculate evenly spaced times during work hours
  List<TimeOfDay> calculateReminderTimes(int count) {
    if (count <= 0) return [];
    
    final startMinutes = _startTime.hour * 60 + _startTime.minute;
    final endMinutes = _endTime.hour * 60 + _endTime.minute;
    final totalMinutes = endMinutes - startMinutes;
    
    if (totalMinutes <= 0 || count == 1) {
      // If only one reminder or invalid range, return middle of work day
      final midMinutes = startMinutes + (totalMinutes ~/ 2);
      return [TimeOfDay(hour: midMinutes ~/ 60, minute: midMinutes % 60)];
    }
    
    final interval = totalMinutes / count;
    final times = <TimeOfDay>[];
    
    for (int i = 0; i < count; i++) {
      final minutes = (startMinutes + (interval * (i + 0.5))).round();
      times.add(TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60));
    }
    
    return times;
  }
}
