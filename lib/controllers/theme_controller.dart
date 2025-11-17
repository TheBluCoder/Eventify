// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// /// Theme preference options
// enum AppThemeMode {
//   system,
//   light,
//   dark,
// }

// /// Controller for managing app theme
// class ThemeController extends ChangeNotifier {
//   static const String _themePreferenceKey = 'theme_mode';

//   AppThemeMode _themeMode = AppThemeMode.system;

//   AppThemeMode get themeMode => _themeMode;

//   /// Get the effective brightness based on theme mode and system settings
//   Brightness getEffectiveBrightness(Brightness systemBrightness) {
//     switch (_themeMode) {
//       case AppThemeMode.light:
//         return Brightness.light;
//       case AppThemeMode.dark:
//         return Brightness.dark;
//       case AppThemeMode.system:
//         return systemBrightness;
//     }
//   }

//   /// Initialize theme from saved preferences
//   Future<void> initialize() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final savedTheme = prefs.getString(_themePreferenceKey);

//       if (savedTheme != null) {
//         _themeMode = AppThemeMode.values.firstWhere(
//           (mode) => mode.name == savedTheme,
//           orElse: () => AppThemeMode.system,
//         );
//         notifyListeners();
//       }
//     } catch (e) {
//       debugPrint('Error loading theme preference: $e');
//     }
//   }

//   /// Set theme mode and save preference
//   Future<void> setThemeMode(AppThemeMode mode) async {
//     if (_themeMode == mode) return;

//     _themeMode = mode;
//     notifyListeners();

//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString(_themePreferenceKey, mode.name);
//     } catch (e) {
//       debugPrint('Error saving theme preference: $e');
//     }
//   }

//   /// Get the current map style path based on theme
//   String getMapStylePath(Brightness systemBrightness) {
//     final effectiveBrightness = getEffectiveBrightness(systemBrightness);
//     return effectiveBrightness == Brightness.dark
//         ? 'assets/dark_map_style.json'
//         : 'assets/map_style.json';
//   }

//   /// Check if dark mode is active
//   bool isDarkMode(Brightness systemBrightness) {
//     return getEffectiveBrightness(systemBrightness) == Brightness.dark;
//   }
// }
