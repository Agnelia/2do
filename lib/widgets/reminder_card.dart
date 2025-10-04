import 'package:flutter/material.dart';
import 'package:todo_health_reminders/models/reminder.dart';
import 'package:provider/provider.dart';
import 'package:todo_health_reminders/providers/reminder_provider.dart';
import 'package:todo_health_reminders/screens/stand_up_timer_screen.dart';

class ReminderCard extends StatelessWidget {
  final Reminder reminder;

  const ReminderCard({
    super.key,
    required this.reminder,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: reminder.isOverdue ? 4 : 2,
      color: reminder.isOverdue 
          ? Theme.of(context).colorScheme.errorContainer.withOpacity(0.3)
          : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showReminderDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildCategoryIcon(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reminder.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: reminder.isOverdue 
                                ? Theme.of(context).colorScheme.error
                                : null,
                          ),
                        ),
                        if (reminder.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            reminder.description,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        if (reminder.notes != null && reminder.notes!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            reminder.notes!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[500],
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  _buildPriorityIndicator(),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    reminder.formattedTimes,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.repeat,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    reminder.frequencyDescription,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  if (reminder.isOverdue)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Overdue',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (reminder.tags.isNotEmpty) ...[
                    Expanded(
                      child: Wrap(
                        spacing: 4,
                        children: reminder.tags.take(3).map((tag) => Chip(
                          label: Text(
                            tag,
                            style: const TextStyle(fontSize: 10),
                          ),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        )).toList(),
                      ),
                    ),
                  ] else
                    const Spacer(),
                  _buildActionButtons(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon() {
    IconData icon;
    Color color;

    switch (reminder.category.toLowerCase()) {
      case 'medication':
        icon = Icons.medication;
        color = Colors.red;
        break;
      case 'exercise':
        icon = Icons.fitness_center;
        color = Colors.orange;
        break;
      case 'water':
        icon = Icons.water_drop;
        color = Colors.blue;
        break;
      case 'sleep':
        icon = Icons.bedtime;
        color = Colors.purple;
        break;
      case 'nutrition':
        icon = Icons.restaurant;
        color = Colors.green;
        break;
      case 'mental health':
        icon = Icons.psychology;
        color = Colors.teal;
        break;
      default:
        icon = Icons.health_and_safety;
        color = Colors.grey;
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: color.withOpacity(0.2),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }

  Widget _buildPriorityIndicator() {
    Color color;
    switch (reminder.priority) {
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
      width: 4,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => _snoozeReminder(context),
          icon: const Icon(Icons.snooze),
          iconSize: 20,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          tooltip: 'Snooze',
        ),
        IconButton(
          onPressed: () => _completeReminder(context),
          icon: const Icon(Icons.check_circle),
          iconSize: 20,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          tooltip: 'Complete',
        ),
      ],
    );
  }

  void _showReminderDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildCategoryIcon(),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          reminder.title,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (reminder.description.isNotEmpty) ...[
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(reminder.description),
                    const SizedBox(height: 16),
                  ],
                  _buildDetailRow('Category', reminder.category),
                  _buildDetailRow('Time', reminder.formattedTime),
                  _buildDetailRow('Frequency', reminder.frequencyDescription),
                  _buildDetailRow('Priority', reminder.priority.name.toUpperCase()),
                  _buildDetailRow('Completed', '${reminder.completionCount} times'),
                  if (reminder.lastCompleted != null)
                    _buildDetailRow('Last Completed', 
                        '${reminder.lastCompleted!.day}/${reminder.lastCompleted!.month}/${reminder.lastCompleted!.year}'),
                  if (reminder.notes != null && reminder.notes!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Notes',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(reminder.notes!),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _snoozeReminder(context);
                          },
                          icon: const Icon(Icons.snooze),
                          label: const Text('Snooze'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _completeReminder(context);
                          },
                          icon: const Icon(Icons.check),
                          label: const Text('Complete'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _completeReminder(BuildContext context) {
    // Check if this is a stand-up challenge
    final isStandUpChallenge = reminder.tags.contains('standup');
    
    if (isStandUpChallenge) {
      // Open the timer screen for stand-up challenges
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StandUpTimerScreen(reminder: reminder),
        ),
      ).then((completed) {
        if (completed == true) {
          // Mark as completed after timer finishes
          final reminderProvider = context.read<ReminderProvider>();
          reminderProvider.completeReminder(reminder.id);
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${reminder.title} completed!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      });
    } else {
      // Regular reminder completion
      final reminderProvider = context.read<ReminderProvider>();
      reminderProvider.completeReminder(reminder.id);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${reminder.title} completed!'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              // Implement undo functionality if needed
            },
          ),
        ),
      );
    }
  }

  void _snoozeReminder(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Snooze for:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('15 minutes'),
              onTap: () {
                Navigator.pop(context);
                _performSnooze(context, const Duration(minutes: 15));
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('30 minutes'),
              onTap: () {
                Navigator.pop(context);
                _performSnooze(context, const Duration(minutes: 30));
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('1 hour'),
              onTap: () {
                Navigator.pop(context);
                _performSnooze(context, const Duration(hours: 1));
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Tomorrow'),
              onTap: () {
                Navigator.pop(context);
                _performSnooze(context, const Duration(days: 1));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _performSnooze(BuildContext context, Duration duration) {
    final reminderProvider = context.read<ReminderProvider>();
    reminderProvider.snoozeReminder(reminder.id, duration);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${reminder.title} snoozed for ${_formatDuration(duration)}'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} day${duration.inDays > 1 ? 's' : ''}';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hour${duration.inHours > 1 ? 's' : ''}';
    } else {
      return '${duration.inMinutes} minute${duration.inMinutes > 1 ? 's' : ''}';
    }
  }
}