import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as flutter show TimeOfDay;
import 'package:provider/provider.dart';
import 'package:todo_health_reminders/models/reminder.dart' as model;
import 'package:todo_health_reminders/providers/reminder_provider.dart';
import 'package:todo_health_reminders/widgets/responsive_layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddReminderScreen extends StatefulWidget {
  final model.Reminder? reminderToEdit;

  const AddReminderScreen({
    super.key,
    this.reminderToEdit,
  });

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedCategory = 'Medication';
  model.ReminderFrequency _selectedFrequency = model.ReminderFrequency.daily;
  model.ReminderPriority _selectedPriority = model.ReminderPriority.medium;
  flutter.TimeOfDay _selectedTime = const flutter.TimeOfDay(hour: 9, minute: 0);
  List<flutter.TimeOfDay> _selectedTimes = [];
  List<int> _selectedWeekdays = [];
  int? _customInterval;
  List<String> _tags = [];
  final _tagController = TextEditingController();

  final List<String> _categories = [
    'Medication',
    'Exercise',
    'Water',
    'Sleep',
    'Nutrition',
    'Mental Health',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.reminderToEdit != null) {
      _loadReminderData();
    }
  }

  void _loadReminderData() {
    final reminder = widget.reminderToEdit!;
    _titleController.text = reminder.title;
    _descriptionController.text = reminder.description;
    _notesController.text = reminder.notes ?? '';
    _selectedCategory = reminder.category;
  _selectedFrequency = reminder.frequency;
  _selectedPriority = reminder.priority;
  _selectedTime = reminder.time.toFlutterTimeOfDay();
    _customInterval = reminder.customInterval;
    _tags = List.from(reminder.tags);
    
    // Load new fields
    if (reminder.times != null) {
      _selectedTimes = reminder.times!.map((t) => t.toFlutterTimeOfDay()).toList();
    }
    if (reminder.selectedWeekdays != null) {
      _selectedWeekdays = List.from(reminder.selectedWeekdays!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.reminderToEdit != null;
    final l10n = AppLocalizations.of(context)!;
    
    return ResponsiveLayout(
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? l10n.editReminder : l10n.addReminder),
          actions: [
            TextButton(
              onPressed: _saveReminder,
              child: Text(
                isEditing ? l10n.update : l10n.save,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBasicInfoSection(),
                const SizedBox(height: 24),
                _buildScheduleSection(),
                const SizedBox(height: 24),
                _buildCategorySection(),
                const SizedBox(height: 24),
                _buildTagsSection(),
                const SizedBox(height: 24),
                _buildNotesSection(),
                const SizedBox(height: 32),
                if (!isEditing) _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter reminder title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter description (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<model.ReminderPriority>(
              value: _selectedPriority,
              decoration: InputDecoration(
                labelText: l10n.priority,
                border: const OutlineInputBorder(),
              ),
              items: model.ReminderPriority.values.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Row(
                    children: [
                      _buildPriorityIcon(priority),
                      const SizedBox(width: 8),
                      Text(priority.name.toUpperCase()),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPriority = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleSection() {
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.schedule,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text('${l10n.time}: ${_selectedTime.format(context)}'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _selectTime,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<model.ReminderFrequency>(
              value: _selectedFrequency,
              decoration: InputDecoration(
                labelText: l10n.frequency,
                border: const OutlineInputBorder(),
              ),
              items: model.ReminderFrequency.values.map((frequency) {
                return DropdownMenuItem(
                  value: frequency,
                  child: Text(_getFrequencyLabel(frequency, l10n)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFrequency = value!;
                  // Reset related fields when frequency changes
                  if (_selectedFrequency != model.ReminderFrequency.daily) {
                    _selectedWeekdays.clear();
                    _selectedTimes.clear();
                  }
                });
              },
            ),
            // Show weekday selection for daily frequency
            if (_selectedFrequency == model.ReminderFrequency.daily) ...[
              const SizedBox(height: 16),
              Text(
                l10n.selectDays,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              _buildWeekdaySelection(l10n),
              const SizedBox(height: 16),
              Text(
                l10n.times,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              _buildTimesList(l10n),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _addTime,
                icon: const Icon(Icons.add),
                label: Text(l10n.addTime),
              ),
            ],
            if (_selectedFrequency == model.ReminderFrequency.custom) ...[
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _customInterval?.toString(),
                decoration: InputDecoration(
                  labelText: l10n.everyXDays,
                  hintText: l10n.enterNumberOfDays,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (_selectedFrequency == model.ReminderFrequency.custom) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the interval';
                    }
                    final interval = int.tryParse(value);
                    if (interval == null || interval < 1) {
                      return 'Please enter a valid number';
                    }
                  }
                  return null;
                },
                onChanged: (value) {
                  _customInterval = int.tryParse(value);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.category,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((category) {
                final isSelected = _selectedCategory == category;
                return FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tags',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _tagController,
                    decoration: const InputDecoration(
                      hintText: 'Add a tag',
                      border: OutlineInputBorder(),
                    ),
                    // onSubmitted: _addTag, // Removed invalid parameter
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _addTag(_tagController.text),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            if (_tags.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    onDeleted: () => _removeTag(tag),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notes',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                hintText: 'Add any additional notes...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    final l10n = AppLocalizations.of(context)!;
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveReminder,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(l10n.saveReminder),
      ),
    );
  }

  Widget _buildPriorityIcon(model.ReminderPriority priority) {
    Color color;
    switch (priority) {
      case model.ReminderPriority.urgent:
        color = Colors.red;
        break;
      case model.ReminderPriority.high:
        color = Colors.orange;
        break;
      case model.ReminderPriority.medium:
        color = Colors.yellow;
        break;
      case model.ReminderPriority.low:
        color = Colors.green;
        break;
    }

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  String _getFrequencyLabel(model.ReminderFrequency frequency, AppLocalizations l10n) {
    switch (frequency) {
      case model.ReminderFrequency.daily:
        return l10n.daily;
      case model.ReminderFrequency.weekly:
        return l10n.weekly;
      case model.ReminderFrequency.monthly:
        return l10n.monthly;
      case model.ReminderFrequency.custom:
        return l10n.custom;
    }
  }

  Widget _buildWeekdaySelection(AppLocalizations l10n) {
    final dayNames = [
      l10n.monday,
      l10n.tuesday,
      l10n.wednesday,
      l10n.thursday,
      l10n.friday,
      l10n.saturday,
      l10n.sunday,
    ];
    
    return Wrap(
      spacing: 8,
      children: List.generate(7, (index) {
        final dayNumber = index + 1;
        final isSelected = _selectedWeekdays.contains(dayNumber);
        
        return FilterChip(
          label: Text(dayNames[index]),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedWeekdays.add(dayNumber);
              } else {
                _selectedWeekdays.remove(dayNumber);
              }
              _selectedWeekdays.sort();
            });
          },
        );
      }),
    );
  }

  Widget _buildTimesList(AppLocalizations l10n) {
    return Column(
      children: _selectedTimes.map((time) {
        return Card(
          child: ListTile(
            leading: const Icon(Icons.access_time),
            title: Text(time.format(context)),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _selectedTimes.remove(time);
                });
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _addTime() async {
    final flutter.TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const flutter.TimeOfDay(hour: 12, minute: 0),
    );
    if (picked != null) {
      setState(() {
        _selectedTimes.add(picked);
        _selectedTimes.sort((a, b) {
          final aMinutes = a.hour * 60 + a.minute;
          final bMinutes = b.hour * 60 + b.minute;
          return aMinutes.compareTo(bMinutes);
        });
      });
    }
  }

  Future<void> _selectTime() async {
  final flutter.TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _addTag(String tag) {
    if (tag.trim().isNotEmpty && !_tags.contains(tag.trim())) {
      setState(() {
        _tags.add(tag.trim());
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _saveReminder() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final nextDueDate = DateTime(
        now.year,
        now.month,
        now.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final reminder = model.Reminder(
        id: widget.reminderToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        frequency: _selectedFrequency,
        time: model.R_TimeOfDay.fromFlutterTimeOfDay(_selectedTime),
        times: _selectedTimes.isNotEmpty 
            ? _selectedTimes.map((t) => model.R_TimeOfDay.fromFlutterTimeOfDay(t)).toList()
            : null,
        selectedWeekdays: _selectedWeekdays.isNotEmpty ? _selectedWeekdays : null,
        nextDueDate: nextDueDate.isBefore(now) 
            ? nextDueDate.add(const Duration(days: 1)) 
            : nextDueDate,
        createdAt: widget.reminderToEdit?.createdAt ?? now,
        tags: _tags,
        priority: _selectedPriority,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        customInterval: _customInterval,
        isActive: widget.reminderToEdit?.isActive ?? true,
        completionCount: widget.reminderToEdit?.completionCount ?? 0,
        lastCompleted: widget.reminderToEdit?.lastCompleted,
      );

      final reminderProvider = context.read<ReminderProvider>();
      
      if (widget.reminderToEdit != null) {
        reminderProvider.updateReminder(reminder);
      } else {
        reminderProvider.addReminder(reminder);
      }

      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.reminderToEdit != null 
              ? 'Reminder updated successfully' 
              : 'Reminder added successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    _tagController.dispose();
    super.dispose();
  }
}