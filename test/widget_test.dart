// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:provider/provider.dart';

// import 'package:todo_health_reminders/main.dart';
// import 'package:todo_health_reminders/providers/reminder_provider.dart';
// import 'package:todo_health_reminders/providers/statistics_provider.dart';

// void main() {
//   group('2do Health Reminders App Tests', () {
//     testWidgets('App launches and shows home screen', (WidgetTester tester) async {
//       // Build our app and trigger a frame.
//       await tester.pumpWidget(const MyApp());

//       // Verify that the app title is displayed
//       expect(find.text('2do Health Reminders'), findsOneWidget);
      
//       // Verify that the bottom navigation is present
//       expect(find.byType(NavigationBar), findsOneWidget);
      
//       // Verify navigation destinations
//       expect(find.text('Dashboard'), findsOneWidget);
//       expect(find.text('Statistics'), findsOneWidget);
//       expect(find.text('Profile'), findsOneWidget);
//     });

//     testWidgets('Navigation between screens works', (WidgetTester tester) async {
//       await tester.pumpWidget(const MyApp());

//       // Initially on Dashboard
//       expect(find.text('Today\'s Reminders'), findsOneWidget);

//       // Tap on Statistics tab
//       await tester.tap(find.text('Statistics'));
//       await tester.pumpAndSettle();

//       // Should show statistics screen
//       expect(find.text('Health Statistics'), findsOneWidget);

//       // Tap on Profile tab
//       await tester.tap(find.text('Profile'));
//       await tester.pumpAndSettle();

//       // Should show profile screen
//       expect(find.text('Profile'), findsWidgets);
//     });

//     testWidgets('Empty state is shown when no reminders', (WidgetTester tester) async {
//       await tester.pumpWidget(const MyApp());

//       // Should show empty state message
//       expect(find.textContaining('No reminders for today'), findsOneWidget);
//       expect(find.textContaining('Tap the + button'), findsOneWidget);
//     });

//     testWidgets('FloatingActionButton is present on dashboard', (WidgetTester tester) async {
//       await tester.pumpWidget(const MyApp());

//       // Should show FAB on dashboard
//       expect(find.byType(FloatingActionButton), findsOneWidget);
//     });
//   });

//   group('Provider Tests', () {
//     test('ReminderProvider initial state', () {
//       final provider = ReminderProvider();
      
//       expect(provider.reminders, isEmpty);
//       expect(provider.upcomingReminders, isEmpty);
//       expect(provider.todayReminderCount, equals(0));
//       expect(provider.completedTodayCount, equals(0));
//     });

//     test('StatisticsProvider initial state', () {
//       final provider = StatisticsProvider();
      
//       expect(provider.completedToday, equals(0));
//       expect(provider.totalToday, equals(0));
//       expect(provider.overdueToday, equals(0));
//       expect(provider.weeklyStreak, equals(0));
//       expect(provider.healthScore, equals(100));
//       expect(provider.totalCompleted, equals(0));
//       expect(provider.dailyProgress, equals(1.0));
//     });
//   });

//   group('Responsive Layout Tests', () {
//     testWidgets('Responsive layout adapts to different screen sizes', (WidgetTester tester) async {
//       // Test mobile layout
//       await tester.binding.setSurfaceSize(const Size(400, 800));
//       await tester.pumpWidget(const MyApp());
//       await tester.pumpAndSettle();

//       // Verify mobile layout
//       expect(find.byType(NavigationBar), findsOneWidget);

//       // Test tablet layout
//       await tester.binding.setSurfaceSize(const Size(800, 600));
//       await tester.pumpWidget(const MyApp());
//       await tester.pumpAndSettle();

//       // Should still work on tablet
//       expect(find.byType(NavigationBar), findsOneWidget);
//     });
//   });
// }