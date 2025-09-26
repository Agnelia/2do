import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_health_reminders/models/reminder.dart';
import 'package:todo_health_reminders/providers/reminder_provider.dart';
import 'package:todo_health_reminders/widgets/responsive_layout.dart';

class AddReminderScreen extends StatefulWidget {
  final Reminder? reminderToEdit;

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
  ReminderFrequency _selectedFrequency = ReminderFrequency.daily;
  ReminderPriority _selectedPriority = ReminderPriority.medium;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
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
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.reminderToEdit != null;
    
    return ResponsiveLayout(
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? 'Edit Reminder' : 'Add Reminder'),
          actions: [
            TextButton(
              onPressed: _saveReminder,
              child: Text(
                isEditing ? 'Update' : 'Save',
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
            DropdownButtonFormField<ReminderPriority>(
              value: _selectedPriority,
              decoration: const InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
              ),
              items: ReminderPriority.values.map((priority) {
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Schedule',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text('Time: ${_selectedTime.format(context)}'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _selectTime,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<ReminderFrequency>(
              value: _selectedFrequency,
              decoration: const InputDecoration(
                labelText: 'Frequency',
                border: OutlineInputBorder(),
              ),
              items: ReminderFrequency.values.map((frequency) {
                return DropdownMenuItem(
                  value: frequency,
                  child: Text(_getFrequencyLabel(frequency)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFrequency = value!;
                });
              },
            ),
            if (_selectedFrequency == ReminderFrequency.custom) ...[
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _customInterval?.toString(),
                decoration: const InputDecoration(
                  labelText: 'Every X days',
                  hintText: 'Enter number of days',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (_selectedFrequency == ReminderFrequency.custom) {
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category',
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
                    onSubmitted: _addTag,
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
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveReminder,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text('Save Reminder'),
      ),
    );
  }

  Widget _buildPriorityIcon(ReminderPriority priority) {
    Color color;
    switch (priority) {
      case ReminderPriority.urgent:
        color = Colors.red;
        break;
      case ReminderPriority.high:
        color = Colors.orange;
        break;
      case ReminderPriority.medium:
        color = Colors.yellow;
        break;
      case ReminderPriority.low:
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

  String _getFrequencyLabel(ReminderFrequency frequency) {
    switch (frequency) {
      case ReminderFrequency.daily:
        return 'Daily';
      case ReminderFrequency.weekly:
        return 'Weekly';
      case ReminderFrequency.monthly:
        return 'Monthly';
      case ReminderFrequency.custom:
        return 'Custom';
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
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

      final reminder = Reminder(
        id: widget.reminderToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        frequency: _selectedFrequency,
        time: TimeOfDay.fromFlutterTimeOfDay(_selectedTime),
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