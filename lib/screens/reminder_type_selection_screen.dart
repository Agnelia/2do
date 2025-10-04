import 'package:flutter/material.dart';
import 'package:todo_health_reminders/l10n/app_localizations.dart';
import 'package:todo_health_reminders/screens/add_reminder_screen.dart';
import 'package:todo_health_reminders/screens/office_template_selection_screen.dart';
import 'package:todo_health_reminders/widgets/responsive_layout.dart';

class ReminderTypeSelectionScreen extends StatelessWidget {
  const ReminderTypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ResponsiveLayout(
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.selectReminderType),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              _buildTypeCard(
                context,
                title: l10n.customReminder,
                description: 'Create a custom reminder with your own settings',
                icon: Icons.edit_calendar,
                color: Theme.of(context).colorScheme.primary,
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddReminderScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildTypeCard(
                context,
                title: l10n.officeReminder,
                description: 'Choose from office reminder templates',
                icon: Icons.business,
                color: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OfficeTemplateSelectionScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
