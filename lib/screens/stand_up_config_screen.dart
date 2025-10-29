import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_health_reminders/l10n/app_localizations.dart';
import 'package:todo_health_reminders/models/reminder.dart' as model;
import 'package:todo_health_reminders/providers/reminder_provider.dart';
import 'package:todo_health_reminders/providers/work_hours_provider.dart';
import 'package:todo_health_reminders/providers/admin_provider.dart';
import 'package:todo_health_reminders/widgets/responsive_layout.dart';

class StandUpConfigScreen extends StatefulWidget {
  const StandUpConfigScreen({super.key});

  @override
  State<StandUpConfigScreen> createState() => _StandUpConfigScreenState();
}

class _StandUpConfigScreenState extends State<StandUpConfigScreen> {
  int _durationMinutes = 15;
  int _repetitionsPerDay = 3;
  TimeOfDay? _customStartTime;
  TimeOfDay? _customEndTime;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final workHoursProvider = context.watch<WorkHoursProvider>();
    final adminProvider = context.watch<AdminProvider>();

    final startTime = _customStartTime ?? workHoursProvider.startTime;
    final endTime = _customEndTime ?? workHoursProvider.endTime;

    return ResponsiveLayout(
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.configureStandUp),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.duration,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      if (adminProvider.isAdminMode) ...[
                        TextField(
                          decoration: InputDecoration(
                            labelText: l10n.customTime,
                            hintText: l10n.enterMinutes,
                            suffixText: l10n.minutes,
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            final parsed = int.tryParse(value);
                            if (parsed != null && parsed > 0) {
                              setState(() {
                                _durationMinutes = parsed;
                              });
                            }
                          },
                          controller: TextEditingController(text: _durationMinutes.toString()),
                        ),
                      ] else ...[
                        Row(
                          children: [
                            Expanded(
                              child: Slider(
                                value: _durationMinutes.toDouble(),
                                min: 5,
                                max: 60,
                                divisions: 11,
                                label: '$_durationMinutes ${l10n.minutes}',
                                onChanged: (value) {
                                  setState(() {
                                    _durationMinutes = value.toInt();
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 80,
                              child: Text(
                                '$_durationMinutes ${l10n.minutes}',
                                style: Theme.of(context).textTheme.titleMedium,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.repetitions,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: _repetitionsPerDay.toDouble(),
                              min: 1,
                              max: 10,
                              divisions: 9,
                              label: '$_repetitionsPerDay ${l10n.timesPerDay}',
                              onChanged: (value) {
                                setState(() {
                                  _repetitionsPerDay = value.toInt();
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: Text(
                              '$_repetitionsPerDay ${l10n.timesPerDay}',
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.workHours,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.access_time),
                        title: Text(l10n.startTime),
                        trailing: Text(
                          startTime.format(context),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: startTime,
                          );
                          if (time != null) {
                            setState(() {
                              _customStartTime = time;
                            });
                          }
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.access_time),
                        title: Text(l10n.endTime),
                        trailing: Text(
                          endTime.format(context),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: endTime,
                          );
                          if (time != null) {
                            setState(() {
                              _customEndTime = time;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Preview',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You will be reminded $_repetitionsPerDay times during your work day:',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      ...() {
                        // Calculate preview times with custom times if set
                        final previewStartTime = _customStartTime ?? workHoursProvider.startTime;
                        final previewEndTime = _customEndTime ?? workHoursProvider.endTime;
                        final startMinutes = previewStartTime.hour * 60 + previewStartTime.minute;
                        final endMinutes = previewEndTime.hour * 60 + previewEndTime.minute;
                        final totalMinutes = endMinutes - startMinutes;
                        
                        List<TimeOfDay> previewTimes = [];
                        if (totalMinutes > 0 && _repetitionsPerDay > 0) {
                          if (_repetitionsPerDay == 1) {
                            final midMinutes = startMinutes + (totalMinutes ~/ 2);
                            previewTimes.add(TimeOfDay(hour: midMinutes ~/ 60, minute: midMinutes % 60));
                          } else {
                            final interval = totalMinutes / _repetitionsPerDay;
                            for (int i = 0; i < _repetitionsPerDay; i++) {
                              final minutes = (startMinutes + (interval * (i + 0.5))).round();
                              previewTimes.add(TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60));
                            }
                          }
                        }
                        
                        return previewTimes.map((time) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              const Icon(Icons.alarm, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                time.format(context),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        )).toList();
                      }(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _saveStandUpChallenge(context, workHoursProvider),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: Text(
                  l10n.save,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveStandUpChallenge(
    BuildContext context,
    WorkHoursProvider workHoursProvider,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    final startTime = _customStartTime ?? workHoursProvider.startTime;
    final endTime = _customEndTime ?? workHoursProvider.endTime;

    // Update work hours if custom times were set
    if (_customStartTime != null && _customEndTime != null) {
      await workHoursProvider.setWorkHours(_customStartTime!, _customEndTime!);
    }

    // Calculate reminder times using the selected times
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;
    final totalMinutes = endMinutes - startMinutes;
    
    List<TimeOfDay> reminderTimes = [];
    if (totalMinutes > 0 && _repetitionsPerDay > 0) {
      if (_repetitionsPerDay == 1) {
        final midMinutes = startMinutes + (totalMinutes ~/ 2);
        reminderTimes.add(TimeOfDay(hour: midMinutes ~/ 60, minute: midMinutes % 60));
      } else {
        final interval = totalMinutes / _repetitionsPerDay;
        for (int i = 0; i < _repetitionsPerDay; i++) {
          final minutes = (startMinutes + (interval * (i + 0.5))).round();
          reminderTimes.add(TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60));
        }
      }
    }

    if (reminderTimes.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not calculate reminder times')),
        );
      }
      return;
    }

    // Create the reminder with the calculated times
    final now = DateTime.now();
    final firstTime = reminderTimes.first;
    var nextDueDate = DateTime(
      now.year,
      now.month,
      now.day,
      firstTime.hour,
      firstTime.minute,
    );

    // If the first time is in the past, schedule for tomorrow
    if (nextDueDate.isBefore(now)) {
      nextDueDate = nextDueDate.add(const Duration(days: 1));
    }

    final reminder = model.Reminder(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: l10n.standUpChallenge,
      description: 'Stand up for $_durationMinutes ${l10n.minutes}',
      category: 'Exercise',
      frequency: model.ReminderFrequency.daily,
      time: model.R_TimeOfDay.fromFlutterTimeOfDay(firstTime),
      times: reminderTimes
          .map((t) => model.R_TimeOfDay.fromFlutterTimeOfDay(t))
          .toList(),
      nextDueDate: nextDueDate,
      createdAt: now,
      tags: ['office', 'standup'],
      priority: model.ReminderPriority.medium,
      notes: 'Duration: $_durationMinutes minutes\nRepetitions: $_repetitionsPerDay times per day',
      customInterval: _durationMinutes, // Store duration in customInterval field
    );

    if (context.mounted) {
      final reminderProvider = context.read<ReminderProvider>();
      await reminderProvider.addReminder(reminder);

      // Navigate back to home
      if (context.mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.standUpChallenge} ${l10n.save}d!')),
        );
      }
    }
  }
}
