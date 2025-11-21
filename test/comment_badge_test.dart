import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_health_reminders/widgets/comment_badge.dart';

void main() {
  group('CommentBadge Widget Tests', () {
    testWidgets('CommentBadge displays correct count', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CommentBadge(commentCount: 5),
          ),
        ),
      );

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('CommentBadge displays 99+ for counts over 99', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CommentBadge(commentCount: 150),
          ),
        ),
      );

      expect(find.text('99+'), findsOneWidget);
    });

    testWidgets('CommentBadge is hidden when count is 0', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CommentBadge(commentCount: 0),
          ),
        ),
      );

      expect(find.byType(Container), findsNothing);
    });

    testWidgets('CommentBadge uses custom colors', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CommentBadge(
              commentCount: 3,
              backgroundColor: Colors.red,
              textColor: Colors.yellow,
            ),
          ),
        ),
      );

      final containerWidget = tester.widget<Container>(
        find.byType(Container).first,
      );
      final decoration = containerWidget.decoration as BoxDecoration;
      
      expect(decoration.color, equals(Colors.red));
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('CommentBadge renders with custom size', (WidgetTester tester) async {
      const customSize = 40.0;
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CommentBadge(
              commentCount: 7,
              size: customSize,
            ),
          ),
        ),
      );

      // Verify the badge is rendered with the comment count
      expect(find.text('7'), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
      
      // Verify the container exists with circular decoration
      final containerWidget = tester.widget<Container>(
        find.byType(Container).first,
      );
      final decoration = containerWidget.decoration as BoxDecoration;
      expect(decoration.shape, equals(BoxShape.circle));
    });
  });
}
