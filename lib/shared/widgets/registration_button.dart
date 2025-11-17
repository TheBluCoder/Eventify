import 'package:flutter/material.dart';
import '../../app/app_constants.dart';

/// Reusable registration button widget
class RegistrationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const RegistrationButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(
        Icons.event_available,
        size: AppConstants.iconSizeM,
      ),
      label: Text(
        'RSVP',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: AppConstants.fontSizeM,
              color: Colors.blue[600],
            ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white70,
        fixedSize: const Size(
          AppConstants.registrationButtonWidth,
          AppConstants.registrationButtonHeight,
        ),
        foregroundColor: Colors.blue[600],
        side: BorderSide(color: Colors.blue[600]!),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingM,
          vertical: AppConstants.paddingS,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusS),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
      ),
      iconAlignment: IconAlignment.start,
    );
  }
}

