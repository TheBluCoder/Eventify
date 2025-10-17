import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/home/controllers/home_controller.dart';

/// Centralized provider configuration for the app
class AppProviders {
  /// Returns a list of all providers used in the app
  static List<ChangeNotifierProvider> get providers => [
    ChangeNotifierProvider(
      create: (_) => HomePageController()..initialize(),
    ),
    // Add more providers here as you create them:
    // ChangeNotifierProvider(create: (_) => EventsController()),
    // ChangeNotifierProvider(create: (_) => AuthController()),
    // ChangeNotifierProvider(create: (_) => LocationController()),
  ];

  /// Helper method to create MultiProvider widget
  static Widget createMultiProvider({required Widget child}) {
    return MultiProvider(
      providers: providers,
      child: child,
    );
  }
}
