import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/main_navigation_page.dart';
import '../pages/user_profile_page.dart';
import '../pages/settings_page.dart';
import '../pages/view_event_page.dart';
import '../pages/events_list_page.dart';
import '../shared/models/event_model.dart';

/// Application routing configuration using go_router
class AppRouter {
  // Route paths
  static const String home = '/';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String viewEvent = '/view-event';
  static const String eventsList = '/events-list';

  /// Main router configuration
  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const MainNavigationPage(),
      ),
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) => const UserProfilePage(),
      ),
      GoRoute(
        path: settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: viewEvent,
        name: 'viewEvent',
        builder: (context, state) {
          final event = state.extra as EventModel?;
          if (event == null) {
            return _buildErrorPage('EventModel is required for view-event route');
          }
          return ViewEventPage(event: event);
        },
      ),
      GoRoute(
        path: eventsList,
        name: 'eventsList',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          if (args == null) {
            return _buildErrorPage('Arguments required for events-list route');
          }
          final title = args['title'] as String? ?? 'Events';
          final events = args['events'] as List<EventModel>? ?? [];
          return EventsListPage(
            title: title,
            events: events,
          );
        },
      ),
    ],
    errorBuilder: (context, state) => _buildErrorPage(
      'Route not found: ${state.uri}',
    ),
  );

  static Widget _buildErrorPage(String message) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Text(message),
      ),
    );
  }
}
