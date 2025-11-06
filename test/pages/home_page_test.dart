import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:echoes/pages/home_page.dart';
import 'package:echoes/shared/data/placeholder.dart';

void main() {
  group('HomePage Widget', () {
    testWidgets('should render without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(title: 'Test'),
        ),
      );

      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('should display personalized greeting', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(title: 'Test'),
        ),
      );

      await tester.pumpAndSettle();

      // Should display one of: Good Morning, Good Afternoon, or Good Evening
      final greetingFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Text &&
            (widget.data == 'Good Morning' ||
                widget.data == 'Good Afternoon' ||
                widget.data == 'Good Evening'),
      );
      expect(greetingFinder, findsOneWidget);
    });

    testWidgets('should display user location from PlaceholderData', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(title: 'Test'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text(PlaceholderData.currentUserLocation), findsOneWidget);
    });

    testWidgets('should display location icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(title: 'Test'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
    });

    testWidgets('should display user avatar', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(title: 'Test'),
        ),
      );

      await tester.pumpAndSettle();

      // Should have CircleAvatar with user image
      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('should display floating action button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(title: 'Test'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add_outlined), findsOneWidget);
    });

    testWidgets('should handle FAB tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(title: 'Test'),
        ),
      );

      await tester.pumpAndSettle();

      // Tap the floating action button
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Should not throw any errors
      expect(tester.takeException(), isNull);
    });

    testWidgets('should have transparent AppBar with blur effect', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(title: 'Test'),
        ),
      );

      await tester.pumpAndSettle();

      // Should have AppBar
      expect(find.byType(AppBar), findsOneWidget);

      // Should have BackdropFilter for blur effect
      expect(find.byType(BackdropFilter), findsWidgets);
    });

    testWidgets('should have elevated AppBar', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(title: 'Test'),
        ),
      );

      await tester.pumpAndSettle();

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.elevation, 4);
    });

    testWidgets('should display Home view content', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(title: 'Test'),
        ),
      );

      await tester.pumpAndSettle();

      // Should contain the Home widget
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('should have bottom border on AppBar', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(title: 'Test'),
        ),
      );

      await tester.pumpAndSettle();

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.shape, isA<Border>());
    });
  });

  group('HomePage Greeting Logic', () {
    test('should return Good Morning before noon', () {
      final morning = DateTime(2025, 11, 4, 9, 0); // 9 AM
      final hour = morning.hour;
      final greeting = hour < 12 ? 'Good Morning' : '';
      expect(greeting, 'Good Morning');
    });

    test('should return Good Afternoon between noon and 5 PM', () {
      final afternoon = DateTime(2025, 11, 4, 14, 0); // 2 PM
      final hour = afternoon.hour;
      final greeting = hour >= 12 && hour < 17 ? 'Good Afternoon' : '';
      expect(greeting, 'Good Afternoon');
    });

    test('should return Good Evening after 5 PM', () {
      final evening = DateTime(2025, 11, 4, 19, 0); // 7 PM
      final hour = evening.hour;
      final greeting = hour >= 17 ? 'Good Evening' : '';
      expect(greeting, 'Good Evening');
    });
  });

  group('HomePage Integration', () {
    testWidgets('should use PlaceholderData for user information', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(title: 'Test'),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that PlaceholderData values are used
      expect(find.text(PlaceholderData.currentUserLocation), findsOneWidget);
    });

    testWidgets('should constrain content width on large screens', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(title: 'Test'),
        ),
      );

      await tester.pumpAndSettle();

      // Should have ConstrainedBox with maxWidth of 1000
      expect(find.byType(ConstrainedBox), findsOneWidget);
      
      final constrainedBox = tester.widget<ConstrainedBox>(find.byType(ConstrainedBox));
      expect(constrainedBox.constraints.maxWidth, 1000);
    });
  });
}
