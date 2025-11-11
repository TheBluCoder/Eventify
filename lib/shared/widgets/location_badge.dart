import 'package:flutter/material.dart';
import '../../app/app_constants.dart';
import '../../app/app_theme.dart';

/// Reusable location badge widget
class LocationBadge extends StatelessWidget {
  final String location;
  final double? fontSize;
  final EdgeInsets? padding;
  final double? borderRadius;
  final double? maxWidth;

  const LocationBadge({
    super.key,
    required this.location,
    this.fontSize,
    this.padding,
    this.borderRadius,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingM,
            vertical: AppConstants.paddingS,
          ),
      decoration: AppTheme.badgeDecorationWithShadow(
        color: Colors.black,
        borderRadius: borderRadius ?? AppConstants.borderRadiusM,
      ),
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? AppConstants.badgeMaxWidth,
      ),
      child: Text(
        location,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontSize: fontSize ?? AppConstants.fontSizeS,
              fontWeight: FontWeight.w600,
            ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.right,
      ),
    );
  }
}

