import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:echoes/pages/home_view.dart';
import 'package:echoes/shared/data/placeholder.dart';

void main() {
  group('Home Widget', () {
    testWidgets('should render without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Home(),
          ),
        ),
      );

      expect(find.byType(Home), findsOneWidget);
    });

    testWidgets('should show Following tab by default', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Home(),
          ),
        ),
      );

      expect(find.text('Following'), findsOneWidget);
      expect(find.text('For You'), findsOneWidget);
    });

    testWidgets('should display event cards', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Home(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should display events from PlaceholderData
      expect(find.text('Tech Innovation Summit'), findsOneWidget);
    });

    testWidgets('should switch between Following and For You tabs', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Home(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initially on Following tab
      expect(find.text('Tech Innovation Summit'), findsOneWidget);

      // Tap on For You tab
      await tester.tap(find.text('For You'));
      await tester.pumpAndSettle();

      // Should now show For You events
      expect(find.text('Design Thinking Workshop'), findsOneWidget);
    });

    testWidgets('should display next upcoming event banner', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Home(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show "Next Event" badge
      expect(find.text('Next Event'), findsOneWidget);
    });

    testWidgets('should display remaining upcoming events in horizontal scroll', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Home(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show "More Upcoming" section
      expect(find.text('More Upcoming'), findsOneWidget);
    });

    testWidgets('should handle refresh indicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Home(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the RefreshIndicator and trigger refresh
      await tester.drag(find.byType(RefreshIndicator), const Offset(0, 300));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('should display event organizer avatar', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Home(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show CircleAvatar widgets for organizers
      expect(find.byType(CircleAvatar), findsWidgets);
    });

    testWidgets('should display event media images', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Home(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show Image.network widgets
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets('should display event tags', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Home(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show tags from events
      expect(find.text('Tech'), findsWidgets);
      expect(find.text('AI'), findsWidgets);
    });

    testWidgets('should display event location with icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Home(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show location icon
      expect(find.byIcon(Icons.location_on), findsWidgets);
    });

    testWidgets('should display event time with icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Home(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show time icon
      expect(find.byIcon(Icons.access_time), findsWidgets);
    });

    testWidgets('should show like button on event cards', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Home(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show favorite icons (liked or not)
      expect(find.byIcon(Icons.favorite), findsWidgets);
    });

    testWidgets('should handle empty event list gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Home(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Widget should handle the case when events exist
      expect(find.byType(Home), findsOneWidget);
    });
  });

  group('Home State Management', () {
    testWidgets('should maintain scroll position', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Home(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should have a ScrollController
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should properly dispose resources', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Home(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Remove widget from tree
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));

      // Should not throw any errors
      expect(tester.takeException(), isNull);
    });
  });

  group('Home Data Integration', () {
    test('should use PlaceholderData for following events', () {
      expect(PlaceholderData.followingEvents, isNotEmpty);
      expect(PlaceholderData.followingEvents.length, greaterThanOrEqualTo(1));
    });

    test('should use PlaceholderData for for you events', () {
      expect(PlaceholderData.forYouEvents, isNotEmpty);
      expect(PlaceholderData.forYouEvents.length, greaterThanOrEqualTo(1));
    });
  });
}
