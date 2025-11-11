import 'package:flutter/material.dart';

/// Application-wide theme configuration
class AppTheme {
  static const String primaryFontFamily = 'Poppins';
  static const double defaultBorderRadius = 12.0;
  static const double defaultPadding = 16.0;
  
  // Colors
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
  
  // Shadow configurations
  static List<BoxShadow> get shadowSmall => [
    BoxShadow(
      color: Colors.grey.withValues(alpha: 0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> get shadowMedium => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> get shadowLarge => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
  
  static List<BoxShadow> get shadowBadge => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> get shadowOrange => [
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
  
  static BoxDecoration badgeDecorationWithShadow({
    required Color color,
    double borderRadius = 12.0,
  }) =>
      BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadowBadge,
      );
  
  // Tag decoration
  static BoxDecoration get tagDecoration => BoxDecoration(
    color: grey500.withValues(alpha: 0.2),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: grey300),
  );
  
  // Tag decoration small
  static BoxDecoration get tagDecorationSmall => BoxDecoration(
    color: grey200,
    borderRadius: BorderRadius.circular(8),
  );
}
