# Stand-Up Timer Feature Implementation

## Overview
This document describes the implementation of the stand-up timer feature as requested in issue #[number].

## Feature Requirements (Swedish Issue Translation)
The user requested the ability to add predefined tasks for different areas. When clicking the + button, instead of going directly to a reminder, there should be a choice between:
- Custom (translated to Swedish: "Anpassad")
- Office ("Kontor")

Under Office, two templates should be available:
1. Walk ("Promenad")
2. Stand Up Challenge ("Stå upp utmaning")

### Stand Up Challenge Requirements
- Select duration (e.g., 15 minutes)
- Choose number of repetitions (not specific times, but count)
- System calculates when to trigger during work day
- User can set start/end time for work day
- Once set, these times should be suggested next time
- Add configurable work hours in settings that applies to all reminders

### Timer Functionality
- Count UP timer showing how long user has stood up
- Updates every full minute (no seconds)
- Default is the set duration, can add minutes but not reduce
- Can pause the timer
- If new reminder comes while paused, this one is dismissed as incomplete
- Show fun animation when time is completed

## Implementation Details

### 1. New Screens Created

#### `reminder_type_selection_screen.dart`
- Displays choice between Custom and Office reminder types
- Replaces direct navigation to AddReminderScreen when clicking +
- Clean card-based UI with icons and descriptions

#### `office_template_selection_screen.dart`
- Shows available office templates (Walk and Stand Up Challenge)
- Walk template shows "coming soon" message
- Stand Up Challenge navigates to configuration screen

#### `stand_up_config_screen.dart`
- Duration slider (5-60 minutes)
- Repetitions slider (1-10 times per day)
- Work hours configuration (start/end time)
- Preview section showing calculated reminder times
- Creates reminder with proper configuration

#### `stand_up_timer_screen.dart`
- Count-up timer showing elapsed minutes
- Circular progress indicator
- Pause/Resume functionality
- Add Minutes button (can only add, not reduce)
- Complete button appears when target reached
- Confetti animation on completion
- Uses `confetti` package for celebration animation

### 2. New Providers

#### `work_hours_provider.dart`
- Manages default work hours (9:00-17:00 default)
- Persists settings using SharedPreferences
- Calculates evenly-spaced reminder times during work day
- Used by stand-up configuration and settings

### 3. Updated Components

#### `home_screen.dart`
- Modified FAB to navigate to `ReminderTypeSelectionScreen` instead of directly to `AddReminderScreen`

#### `settings_screen.dart`
- Added work hours settings section
- Users can configure default work hours
- Made screen scrollable to accommodate new section
- Settings sync with WorkHoursProvider

#### `reminder_card.dart`
- Detects stand-up challenges by checking for 'standup' tag
- Opens timer screen instead of immediately completing
- Marks as complete only after timer finishes

#### `main.dart`
- Added `WorkHoursProvider` to providers list

### 4. Localization

#### Added Strings (English/Swedish)
- reminderType / Påminnelsetyp
- customReminder / Anpassad
- officeReminder / Kontor
- selectReminderType / Välj påminnelsetyp
- walk / Promenad
- standUpChallenge / Stå upp utmaning
- duration / Varaktighet
- minutes / Minuter
- repetitions / Upprepningar
- timesPerDay / Gånger per dag
- workHours / Arbetstid
- startTime / Starttid
- endTime / Sluttid
- timerRunning / Timer körs
- pause / Pausa
- resume / Återuppta
- complete / Slutför
- addMinutes / Lägg till minuter
- greatJob / Bra jobbat!
- youDidIt / Du klarade din stå upp utmaning!
- workHoursSettings / Arbetstidsinställningar
- setDefaultWorkHours / Ange standardarbetstider för kontorspåminnelser
- configureStandUp / Konfigurera stå upp utmaning
- selectTemplate / Välj mall

Updated files:
- `lib/l10n/app_en.arb`
- `lib/l10n/app_sv.arb`
- `lib/l10n/app_localizations.dart`
- `lib/l10n/app_localizations_en.dart`
- `lib/l10n/app_localizations_sv.dart`

### 5. Dependencies Added

```yaml
confetti: ^0.7.0  # For completion animation
```

### 6. Data Model Usage

The stand-up challenge reuses existing Reminder model:
- `customInterval`: Stores duration in minutes
- `tags`: Contains 'standup' tag for identification
- `times`: List of calculated reminder times during work day
- `notes`: Stores configuration details

### 7. Tests Created

#### `test/work_hours_provider_test.dart`
- Tests default work hours
- Tests reminder time calculations
- Tests work hours updates
- Tests edge cases (zero/negative counts)

## User Flow

1. User clicks + button on home screen
2. Sees choice: Custom or Office
3. Selects Office → sees Stand Up Challenge and Walk options
4. Selects Stand Up Challenge → configuration screen
5. Sets duration (e.g., 15 minutes)
6. Sets repetitions (e.g., 3 times per day)
7. Optionally adjusts work hours (defaults from settings)
8. Sees preview of scheduled times
9. Saves → reminder created with multiple times
10. When reminder is due, user clicks to complete
11. Timer screen opens showing count-up timer
12. Timer counts up every minute
13. User can pause, resume, or add minutes
14. When target reached, Complete button appears
15. User clicks Complete → confetti animation plays
16. Reminder marked as complete

## Settings Integration

Users can set default work hours in Settings > Work Hours Settings:
- Start Time (default 9:00)
- End Time (default 17:00)
- These defaults are used when creating new stand-up challenges
- Can be overridden per reminder during creation

## Technical Decisions

1. **Timer Implementation**: Count-up instead of countdown as requested
2. **Update Frequency**: Every minute (no seconds) as specified
3. **Time Calculation**: Evenly distributed across work day
4. **Storage**: Reused existing fields to avoid model changes
5. **Animation**: Confetti package for celebratory effect
6. **Localization**: Full Swedish/English support

## Future Enhancements

- Walk template implementation
- More office templates (stretch breaks, eye rest, etc.)
- Statistics for stand-up challenges
- Achievements and streaks
- Integration with health tracking apps

## Notes

- The timer currently dismisses on new reminders (as requested)
- Cannot reduce time once set (only add minutes)
- Work hours persist across sessions
- Preview updates in real-time as settings change
