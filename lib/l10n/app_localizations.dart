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
  String get addReminder;

  /// Edit reminder page title
  String get editReminder;

  /// Save button label
  String get save;

  /// Update button label
  String get update;

  /// Schedule section header
  String get schedule;

  /// Time field label
  String get time;

  /// Frequency field label
  String get frequency;

  /// Priority field label
  String get priority;

  /// Category field label
  String get category;

  /// Daily frequency option
  String get daily;

  /// Weekly frequency option
  String get weekly;

  /// Monthly frequency option
  String get monthly;

  /// Custom frequency option
  String get custom;

  /// Select days label for weekday selection
  String get selectDays;

  /// Monday day name
  String get monday;

  /// Tuesday day name
  String get tuesday;

  /// Wednesday day name
  String get wednesday;

  /// Thursday day name
  String get thursday;

  /// Friday day name
  String get friday;

  /// Saturday day name
  String get saturday;

  /// Sunday day name
  String get sunday;

  /// Multiple times label
  String get times;

  /// Add time button label
  String get addTime;

  /// Save reminder button label
  String get saveReminder;

  /// Custom interval label
  String get everyXDays;

  /// Custom interval hint text
  String get enterNumberOfDays;
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
