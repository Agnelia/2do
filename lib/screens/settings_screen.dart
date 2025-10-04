import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_health_reminders/providers/theme_provider.dart';
import 'package:todo_health_reminders/providers/locale_provider.dart';
import 'package:todo_health_reminders/providers/work_hours_provider.dart';
import 'package:todo_health_reminders/utils/constants.dart';
import 'package:todo_health_reminders/l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.appearance,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildThemeSelection(context),
            const SizedBox(height: 32),
            Text(
              l10n.general,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildLanguageSelection(context),
            const SizedBox(height: 16),
            _buildWorkHoursSettings(context),
            const SizedBox(height: 16),
            _buildGeneralSettings(context),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSelection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
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
                      l10n.theme,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.chooseTheme,
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
    final l10n = AppLocalizations.of(context)!;
    final isSelected = themeProvider.currentTheme == theme;
    final primaryColor = ThemeConfig.getPrimaryColor(theme);
    final secondaryColor = ThemeConfig.getSecondaryColor(theme);

    String themeName;
    String themeDescription;
    IconData themeIcon;

    switch (theme) {
      case AppThemeType.teal:
        themeName = l10n.oceanTeal;
        themeDescription = l10n.oceanTealDesc;
        themeIcon = Icons.water;
        break;
      case AppThemeType.sunnyDay:
        themeName = l10n.sunnyDay;
        themeDescription = l10n.sunnyDayDesc;
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

  Widget _buildLanguageSelection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.language,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.language,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.chooseLanguage,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 16),
                ...LocaleProvider.supportedLocales.map((locale) => _buildLanguageOption(
                  context,
                  locale,
                  localeProvider,
                )),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    Locale locale,
    LocaleProvider localeProvider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final isSelected = localeProvider.currentLocale == locale;
    final primaryColor = Theme.of(context).colorScheme.primary;

    String languageName;
    String languageNameNative;
    IconData languageIcon;

    switch (locale.languageCode) {
      case 'en':
        languageName = l10n.english;
        languageNameNative = 'English';
        languageIcon = Icons.language;
        break;
      case 'sv':
        languageName = l10n.swedish;
        languageNameNative = 'Svenska';
        languageIcon = Icons.language;
        break;
      default:
        languageName = locale.languageCode;
        languageNameNative = locale.languageCode;
        languageIcon = Icons.language;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => localeProvider.setLocale(locale),
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
                  color: primaryColor,
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
                  languageIcon,
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
                      languageName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? primaryColor : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      languageNameNative,
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
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(l10n.notifications),
            subtitle: Text(l10n.notificationsDesc),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Navigate to notification settings
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.notificationSettingsComingSoon)),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.backup),
            title: Text(l10n.dataBackup),
            subtitle: Text(l10n.dataBackupDesc),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Navigate to backup settings
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.backupSettingsComingSoon)),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.help),
            title: Text(l10n.helpSupport),
            subtitle: Text(l10n.helpSupportDesc),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Navigate to help
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.helpSupportComingSoon)),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWorkHoursSettings(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Consumer<WorkHoursProvider>(
      builder: (context, workHoursProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.workHoursSettings,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.setDefaultWorkHours,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.schedule),
                  title: Text(l10n.startTime),
                  trailing: Text(
                    workHoursProvider.startTime.format(context),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: workHoursProvider.startTime,
                    );
                    if (time != null) {
                      workHoursProvider.setWorkHours(
                        time,
                        workHoursProvider.endTime,
                      );
                    }
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.schedule),
                  title: Text(l10n.endTime),
                  trailing: Text(
                    workHoursProvider.endTime.format(context),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: workHoursProvider.endTime,
                    );
                    if (time != null) {
                      workHoursProvider.setWorkHours(
                        workHoursProvider.startTime,
                        time,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}