import 'package:flutter/material.dart';

/// Centralized SnackBar utilities
/// Used across the application for consistent user feedback
class SnackBarUtil {
  /// Show a generic success message
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Show a generic error message
  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        backgroundColor: Colors.red,
      ),
    );
  }

  /// Show a generic info message
  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
      ),
    );
  }

  /// Show event action feedback (e.g., "Event added to calendar")
  static void showEventAction(
    BuildContext context,
    String eventTitle,
    String action, {
    Duration duration = const Duration(seconds: 2),
  }) {
    showInfo(context, '$eventTitle $action', duration: duration);
  }

  /// Show calendar action feedback
  static void showCalendarAction(
    BuildContext context,
    String eventTitle,
    bool isAdded, {
    Duration duration = const Duration(seconds: 2),
  }) {
    final message = isAdded
        ? '$eventTitle added to calendar'
        : '$eventTitle removed from calendar';
    showInfo(context, message, duration: duration);
  }

  /// Show like action feedback
  static void showLikeAction(
    BuildContext context,
    String eventTitle,
    bool isLiked, {
    Duration duration = const Duration(seconds: 2),
  }) {
    final message = isLiked
        ? 'You liked $eventTitle'
        : 'You unliked $eventTitle';
    showInfo(context, message, duration: duration);
  }

  /// Show boost action feedback
  static void showBoostAction(
    BuildContext context,
    String eventTitle,
    bool isBoosted, {
    Duration duration = const Duration(seconds: 2),
  }) {
    final message = isBoosted
        ? 'You boosted $eventTitle'
        : 'You unboosted $eventTitle';
    showInfo(context, message, duration: duration);
  }

  /// Show save action feedback
  static void showSaveAction(
    BuildContext context,
    String eventTitle,
    bool isSaved, {
    Duration duration = const Duration(seconds: 2),
  }) {
    final message = isSaved
        ? '$eventTitle saved'
        : '$eventTitle removed from saved';
    showInfo(context, message, duration: duration);
  }

  /// Show flag/report action feedback
  static void showFlagAction(
    BuildContext context,
    String eventTitle, {
    Duration duration = const Duration(seconds: 2),
  }) {
    showInfo(context, '$eventTitle has been flagged', duration: duration);
  }

  /// Show generic action with custom icon
  static void showCustom(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
    Color? backgroundColor,
    Widget? leading,
  }) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (leading != null) ...[
              leading,
              const SizedBox(width: 12),
            ],
            Expanded(child: Text(message)),
          ],
        ),
        duration: duration,
        backgroundColor: backgroundColor,
      ),
    );
  }
}
