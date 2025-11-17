import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

/// Centralized URL launching utilities
/// Used across the application for opening external links and maps
class UrlLauncherUtil {
  /// Launch a URL with error handling
  ///
  /// [url] - The URL to launch
  /// [context] - BuildContext for showing error messages (optional)
  /// [onError] - Optional custom error handler callback
  static Future<void> launchURL(
    String url, {
    BuildContext? context,
    VoidCallback? onError,
  }) async {
    try {
      final uri = Uri.parse(url);
      if (await launcher.canLaunchUrl(uri)) {
        await launcher.launchUrl(
          uri,
          mode: launcher.LaunchMode.externalApplication,
        );
      } else {
        _handleError(
          context: context,
          message: 'Could not launch URL',
          onError: onError,
        );
      }
    } catch (e) {
      _handleError(
        context: context,
        message: 'Error launching URL: $e',
        onError: onError,
      );
    }
  }

  /// Launch a map location with the given coordinates and optional location name
  ///
  /// [latitude] - Latitude coordinate
  /// [longitude] - Longitude coordinate
  /// [locationName] - Optional location name for the label
  /// [context] - BuildContext for showing error messages (optional)
  static Future<void> launchMapLocation(
    double latitude,
    double longitude, {
    String? locationName,
    BuildContext? context,
  }) async {
    final encodedLocation = locationName != null
        ? Uri.encodeComponent(locationName)
        : '$latitude,$longitude';

    // Try Google Maps first (works on most platforms)
    final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$encodedLocation';

    // Platform-specific map URLs as fallbacks
    // For iOS, can use: 'maps://?q=$encodedLocation'
    // For Android, can use: 'geo:$latitude,$longitude?q=$encodedLocation'

    await launchURL(
      googleMapsUrl,
      context: context,
      onError: () {
        if (context != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open map application')),
          );
        }
      },
    );
  }

  /// Launch email client with optional subject and body
  ///
  /// [email] - Email address to send to
  /// [subject] - Optional email subject
  /// [body] - Optional email body
  /// [context] - BuildContext for showing error messages (optional)
  static Future<void> launchEmail(
    String email, {
    String? subject,
    String? body,
    BuildContext? context,
  }) async {
    final subjectParam = subject != null ? '?subject=${Uri.encodeComponent(subject)}' : '';
    final bodyParam = body != null
        ? (subject != null ? '&body=' : '?body=') + Uri.encodeComponent(body)
        : '';
    final emailUrl = 'mailto:$email$subjectParam$bodyParam';

    await launchURL(emailUrl, context: context);
  }

  /// Launch phone dialer with the given phone number
  ///
  /// [phoneNumber] - Phone number to dial
  /// [context] - BuildContext for showing error messages (optional)
  static Future<void> launchPhone(
    String phoneNumber, {
    BuildContext? context,
  }) async {
    final phoneUrl = 'tel:$phoneNumber';
    await launchURL(phoneUrl, context: context);
  }

  /// Launch SMS app with optional message
  ///
  /// [phoneNumber] - Phone number to send SMS to
  /// [message] - Optional message body
  /// [context] - BuildContext for showing error messages (optional)
  static Future<void> launchSMS(
    String phoneNumber, {
    String? message,
    BuildContext? context,
  }) async {
    final messageParam = message != null ? '?body=${Uri.encodeComponent(message)}' : '';
    final smsUrl = 'sms:$phoneNumber$messageParam';
    await launchURL(smsUrl, context: context);
  }

  /// Private helper to handle errors consistently
  static void _handleError({
    BuildContext? context,
    required String message,
    VoidCallback? onError,
  }) {
    if (onError != null) {
      onError();
    } else if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
}
