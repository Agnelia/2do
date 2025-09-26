import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_health_reminders/providers/theme_provider.dart';
import 'package:todo_health_reminders/utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appearance',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildThemeSelection(context),
            const SizedBox(height: 32),
            Text(
              'General',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildGeneralSettings(context),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSelection(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.palette,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Theme',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose your preferred color theme',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 16),
                ...AppThemeType.values.map((theme) => _buildThemeOption(
                  context,
                  theme,
                  themeProvider,
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    AppThemeType theme,
    ThemeProvider themeProvider,
  ) {
    final isSelected = themeProvider.currentTheme == theme;
    final primaryColor = ThemeConfig.getPrimaryColor(theme);
    final secondaryColor = ThemeConfig.getSecondaryColor(theme);

    String themeName;
    String themeDescription;
    IconData themeIcon;

    switch (theme) {
      case AppThemeType.teal:
        themeName = 'Ocean Teal';
        themeDescription = 'Cool and calming teal theme';
        themeIcon = Icons.water;
        break;
      case AppThemeType.sunnyDay:
        themeName = 'Sunny Day';
        themeDescription = 'Bright and energetic orange & yellow theme';
        themeIcon = Icons.wb_sunny;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => themeProvider.setTheme(theme),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
            border: Border.all(
              color: isSelected
                  ? primaryColor
                  : Theme.of(context).colorScheme.outline.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
            color: isSelected
                ? primaryColor.withOpacity(0.1)
                : Colors.transparent,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  themeIcon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      themeName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? primaryColor : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      themeDescription,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: primaryColor,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGeneralSettings(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            subtitle: const Text('Manage notification preferences'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Navigate to notification settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notification settings coming soon!')),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('Data Backup'),
            subtitle: const Text('Backup and restore your data'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Navigate to backup settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Backup settings coming soon!')),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            subtitle: const Text('Get help and contact support'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Navigate to help
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help & Support coming soon!')),
              );
            },
          ),
        ],
      ),
    );
  }
}