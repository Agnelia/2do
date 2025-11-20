import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sv.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('sv')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'2do Health Reminders'**
  String get appTitle;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Appearance section header
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// General section header
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// Language settings label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Language selection description
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get chooseLanguage;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Swedish language option
  ///
  /// In en, this message translates to:
  /// **'Swedish'**
  String get swedish;

  /// Theme selection label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Theme selection description
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred color theme'**
  String get chooseTheme;

  /// Ocean Teal theme name
  ///
  /// In en, this message translates to:
  /// **'Ocean Teal'**
  String get oceanTeal;

  /// Ocean Teal theme description
  ///
  /// In en, this message translates to:
  /// **'Cool and calming teal theme'**
  String get oceanTealDesc;

  /// Sunny Day theme name
  ///
  /// In en, this message translates to:
  /// **'Sunny Day'**
  String get sunnyDay;

  /// Sunny Day theme description
  ///
  /// In en, this message translates to:
  /// **'Bright and energetic orange & yellow theme'**
  String get sunnyDayDesc;

  /// Notifications settings label
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Notifications settings description
  ///
  /// In en, this message translates to:
  /// **'Manage notification preferences'**
  String get notificationsDesc;

  /// Data backup settings label
  ///
  /// In en, this message translates to:
  /// **'Data Backup'**
  String get dataBackup;

  /// Data backup settings description
  ///
  /// In en, this message translates to:
  /// **'Backup and restore your data'**
  String get dataBackupDesc;

  /// Help and support settings label
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// Help and support settings description
  ///
  /// In en, this message translates to:
  /// **'Get help and contact support'**
  String get helpSupportDesc;

  /// Notification settings placeholder message
  ///
  /// In en, this message translates to:
  /// **'Notification settings coming soon!'**
  String get notificationSettingsComingSoon;

  /// Backup settings placeholder message
  ///
  /// In en, this message translates to:
  /// **'Backup settings coming soon!'**
  String get backupSettingsComingSoon;

  /// Help and support placeholder message
  ///
  /// In en, this message translates to:
  /// **'Help & Support coming soon!'**
  String get helpSupportComingSoon;

  /// Dashboard navigation label
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Statistics navigation label
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// Profile navigation label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Add reminder page title
  ///
  /// In en, this message translates to:
  /// **'Add Reminder'**
  String get addReminder;

  /// Edit reminder page title
  ///
  /// In en, this message translates to:
  /// **'Edit Reminder'**
  String get editReminder;

  /// Save button label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Update button label
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// Schedule section header
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// Time field label
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// Frequency field label
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// Priority field label
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// Category field label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// Daily frequency option
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// Weekly frequency option
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// Monthly frequency option
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// Custom frequency option
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// Select days label for weekday selection
  ///
  /// In en, this message translates to:
  /// **'Select Days'**
  String get selectDays;

  /// Monday day name
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// Tuesday day name
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// Wednesday day name
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// Thursday day name
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// Friday day name
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// Saturday day name
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// Sunday day name
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// Multiple times label
  ///
  /// In en, this message translates to:
  /// **'Times'**
  String get times;

  /// Add time button label
  ///
  /// In en, this message translates to:
  /// **'Add Time'**
  String get addTime;

  /// Save reminder button label
  ///
  /// In en, this message translates to:
  /// **'Save Reminder'**
  String get saveReminder;

  /// Custom interval label
  ///
  /// In en, this message translates to:
  /// **'Every X days'**
  String get everyXDays;

  /// Custom interval hint text
  ///
  /// In en, this message translates to:
  /// **'Enter number of days'**
  String get enterNumberOfDays;

  /// Reminder type selection label
  ///
  /// In en, this message translates to:
  /// **'Reminder Type'**
  String get reminderType;

  /// Custom reminder type option
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get customReminder;

  /// Office reminder type option
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get officeReminder;

  /// Select reminder type title
  ///
  /// In en, this message translates to:
  /// **'Select Reminder Type'**
  String get selectReminderType;

  /// Walk template name
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get walk;

  /// Stand up challenge template name
  ///
  /// In en, this message translates to:
  /// **'Stand Up Challenge'**
  String get standUpChallenge;

  /// Duration label
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// Minutes unit
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// Number of repetitions label
  ///
  /// In en, this message translates to:
  /// **'Repetitions'**
  String get repetitions;

  /// Times per day label
  ///
  /// In en, this message translates to:
  /// **'Times per day'**
  String get timesPerDay;

  /// Work hours label
  ///
  /// In en, this message translates to:
  /// **'Work Hours'**
  String get workHours;

  /// Start time label
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// End time label
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// Timer running label
  ///
  /// In en, this message translates to:
  /// **'Timer Running'**
  String get timerRunning;

  /// Pause button label
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// Resume button label
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// Complete button label
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// Add minutes button label
  ///
  /// In en, this message translates to:
  /// **'Add Minutes'**
  String get addMinutes;

  /// Completion message
  ///
  /// In en, this message translates to:
  /// **'Great Job!'**
  String get greatJob;

  /// Completion description
  ///
  /// In en, this message translates to:
  /// **'You completed your stand-up challenge!'**
  String get youDidIt;

  /// Work hours settings label
  ///
  /// In en, this message translates to:
  /// **'Work Hours Settings'**
  String get workHoursSettings;

  /// Work hours settings description
  ///
  /// In en, this message translates to:
  /// **'Set default work hours for office reminders'**
  String get setDefaultWorkHours;

  /// Configure stand up challenge title
  ///
  /// In en, this message translates to:
  /// **'Configure Stand Up Challenge'**
  String get configureStandUp;

  /// Select template title
  ///
  /// In en, this message translates to:
  /// **'Select Template'**
  String get selectTemplate;

  /// Admin mode toggle label
  ///
  /// In en, this message translates to:
  /// **'Admin Mode'**
  String get adminMode;

  /// Admin mode toggle description
  ///
  /// In en, this message translates to:
  /// **'Enable admin mode for advanced features'**
  String get enableAdminMode;

  /// Start challenge manually button
  ///
  /// In en, this message translates to:
  /// **'Start Manually'**
  String get startManually;

  /// Manual session label
  ///
  /// In en, this message translates to:
  /// **'Manual Session'**
  String get manualSession;

  /// Message when manual session completes full time
  ///
  /// In en, this message translates to:
  /// **'Next scheduled period will be marked as complete'**
  String get nextPeriodMarked;

  /// Custom time input label for admin
  ///
  /// In en, this message translates to:
  /// **'Custom Time'**
  String get customTime;

  /// Enter custom minutes hint
  ///
  /// In en, this message translates to:
  /// **'Enter minutes'**
  String get enterMinutes;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'sv'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sv':
      return AppLocalizationsSv();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
