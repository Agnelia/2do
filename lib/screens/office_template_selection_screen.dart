import 'package:flutter/material.dart';
import 'package:todo_health_reminders/l10n/app_localizations.dart';
import 'package:todo_health_reminders/screens/stand_up_config_screen.dart';
import 'package:todo_health_reminders/widgets/responsive_layout.dart';

class OfficeTemplateSelectionScreen extends StatelessWidget {
  const OfficeTemplateSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ResponsiveLayout(
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.selectTemplate),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              _buildTemplateCard(
                context,
                title: l10n.walk,
                description: 'Take a walk during your work day',
                icon: Icons.directions_walk,
                color: Colors.green,
                onTap: () {
                  // For now, walk template is not implemented
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Walk template coming soon!'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildTemplateCard(
                context,
                title: l10n.standUpChallenge,
                description: 'Stand up regularly during work hours',
                icon: Icons.accessibility_new,
                color: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StandUpConfigScreen(),
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

  Widget _buildTemplateCard(
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
