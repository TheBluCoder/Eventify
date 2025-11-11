import 'package:flutter/material.dart';
import '../../app/app_constants.dart';
import '../../app/app_theme.dart';

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
        'Register',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontSize: AppConstants.fontSizeM,
            ),
      ),
      style: OutlinedButton.styleFrom(
        fixedSize: const Size(
          AppConstants.registrationButtonWidth,
          AppConstants.registrationButtonHeight,
        ),
        foregroundColor: AppTheme.blue700,
        side: BorderSide(color: AppTheme.blue700),
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

