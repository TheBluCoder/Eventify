import 'package:flutter/material.dart';

/// Application-wide theme configuration
class AppTheme {
  static const String primaryFontFamily = 'Poppins';
  static const double defaultBorderRadius = 12.0;
  static const double defaultPadding = 16.0;

  // Light Theme Colors
  static Color get grey200 => Colors.grey[200]!;
  static Color get grey300 => Colors.grey[300]!;
  static Color get grey400 => Colors.grey[400]!;
  static Color get grey500 => Colors.grey[500]!;
  static Color get grey600 => Colors.grey[600]!;
  static Color get grey700 => Colors.grey[700]!;
  static Color get blue600 => Colors.blue[600]!;
  static Color get blue700 => Colors.blue[700]!;
  static Color get orange600 => Colors.orange[600]!;
  static Color get orange200 => Colors.orange[200]!;
  static Color get red600 => Colors.red[600]!;

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceVariant = Color(0xFF2C2C2C);
  static const Color darkBorder = Color(0xFF3A3A3A);
  static const Color darkText = Color(0xFFE1E1E1);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkTextTertiary = Color(0xFF808080);

  // Theme-aware color getters
  static Color backgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBackground
        : Colors.white;
  }

  static Color surfaceColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSurface
        : Colors.white;
  }

  static Color surfaceVariantColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSurfaceVariant
        : grey200;
  }

  static Color borderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBorder
        : grey300;
  }

  static Color textPrimaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkText
        : Colors.black;
  }

  static Color textSecondaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextSecondary
        : grey600;
  }

  static Color textTertiaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextTertiary
        : grey500;
  }

  static Color iconColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkText
        : const Color.fromARGB(255, 15, 15, 15);
  }

  static Color cardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSurface
        : Colors.white;
  }

  static Color dividerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBorder
        : grey300;
  }
  
  // Shadow configurations (theme-aware)
  static List<BoxShadow> shadowSmall(BuildContext context) => [
    BoxShadow(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.black.withValues(alpha: 0.3)
          : Colors.grey.withValues(alpha: 0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowMedium(BuildContext context) => [
    BoxShadow(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.black.withValues(alpha: 0.4)
          : Colors.black.withValues(alpha: 0.1),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowLarge(BuildContext context) => [
    BoxShadow(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.black.withValues(alpha: 0.5)
          : Colors.black.withValues(alpha: 0.15),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> shadowBadge(BuildContext context) => [
    BoxShadow(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.black.withValues(alpha: 0.4)
          : Colors.black.withValues(alpha: 0.2),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowOrange(BuildContext context) => [
    BoxShadow(
      color: Colors.orange.withValues(alpha: 0.1),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
  
  // Gradient overlays
  static BoxDecoration get gradientOverlay => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.transparent,
        Colors.black.withValues(alpha: 0.7),
      ],
    ),
  );

  static BoxDecoration get gradientOverlayLight => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.transparent,
        Colors.black.withValues(alpha: 0.5),
      ],
    ),
  );

  // Text shadows
  static List<Shadow> get textShadow => [
    Shadow(
      color: Colors.black.withValues(alpha: 0.5),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  // Badge decorations
  static BoxDecoration badgeDecoration({
    required Color color,
    double borderRadius = 8.0,
    double opacity = 0.7,
  }) =>
      BoxDecoration(
        color: color.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(borderRadius),
      );

  static BoxDecoration badgeDecorationWithShadow(
    BuildContext context, {
    required Color color,
    double borderRadius = 12.0,
  }) =>
      BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadowBadge(context),
      );

  // Tag decoration
  static BoxDecoration tagDecoration(BuildContext context) => BoxDecoration(
    color: Theme.of(context).brightness == Brightness.dark
        ? darkSurfaceVariant.withValues(alpha: 0.5)
        : grey400.withValues(alpha: 0.2),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: Theme.of(context).brightness == Brightness.dark
          ? darkBorder
          : grey200,
    ),
  );

  // Tag decoration small
  static BoxDecoration tagDecorationSmall(BuildContext context) => BoxDecoration(
    color: Theme.of(context).brightness == Brightness.dark
        ? darkSurfaceVariant
        : grey200,
    borderRadius: BorderRadius.circular(8),
  );

  // Complete Light Theme
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.white.withValues(alpha: 0.85),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontFamily: primaryFontFamily),
        bodyMedium: TextStyle(fontFamily: primaryFontFamily),
        bodySmall: TextStyle(fontFamily: primaryFontFamily),
        displayLarge: TextStyle(fontFamily: primaryFontFamily),
        displayMedium: TextStyle(fontFamily: primaryFontFamily),
        displaySmall: TextStyle(fontFamily: primaryFontFamily),
        headlineLarge: TextStyle(fontFamily: primaryFontFamily),
        headlineMedium: TextStyle(fontFamily: primaryFontFamily),
        headlineSmall: TextStyle(fontFamily: primaryFontFamily),
        titleLarge: TextStyle(fontFamily: primaryFontFamily),
        titleMedium: TextStyle(fontFamily: primaryFontFamily),
        titleSmall: TextStyle(fontFamily: primaryFontFamily),
        labelLarge: TextStyle(fontFamily: primaryFontFamily),
        labelMedium: TextStyle(fontFamily: primaryFontFamily),
        labelSmall: TextStyle(fontFamily: primaryFontFamily),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  // Complete Dark Theme
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2196F3),
        brightness: Brightness.dark,
        surface: darkSurface,
      ),
      scaffoldBackgroundColor: darkBackground,
      cardColor: darkSurface,
      dividerColor: darkBorder,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontFamily: primaryFontFamily, color: darkText),
        bodyMedium: TextStyle(fontFamily: primaryFontFamily, color: darkText),
        bodySmall: TextStyle(fontFamily: primaryFontFamily, color: darkTextSecondary),
        displayLarge: TextStyle(fontFamily: primaryFontFamily, color: darkText),
        displayMedium: TextStyle(fontFamily: primaryFontFamily, color: darkText),
        displaySmall: TextStyle(fontFamily: primaryFontFamily, color: darkText),
        headlineLarge: TextStyle(fontFamily: primaryFontFamily, color: darkText),
        headlineMedium: TextStyle(fontFamily: primaryFontFamily, color: darkText),
        headlineSmall: TextStyle(fontFamily: primaryFontFamily, color: darkText),
        titleLarge: TextStyle(fontFamily: primaryFontFamily, color: darkText),
        titleMedium: TextStyle(fontFamily: primaryFontFamily, color: darkText),
        titleSmall: TextStyle(fontFamily: primaryFontFamily, color: darkText),
        labelLarge: TextStyle(fontFamily: primaryFontFamily, color: darkText),
        labelMedium: TextStyle(fontFamily: primaryFontFamily, color: darkText),
        labelSmall: TextStyle(fontFamily: primaryFontFamily, color: darkTextSecondary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: darkText),
      ),
      iconTheme: const IconThemeData(color: darkText),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: Colors.blue,
        unselectedItemColor: darkTextSecondary,
      ),
    );
  }
}
