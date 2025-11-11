import 'package:flutter/material.dart';
import '../../app/app_constants.dart';
import '../../app/app_theme.dart';

/// Reusable distance badge widget
class DistanceBadge extends StatelessWidget {
  final String distance;
  final double? fontSize;
  final EdgeInsets? padding;
  final double? borderRadius;

  const DistanceBadge({
    super.key,
    required this.distance,
    this.fontSize,
    this.padding,
    this.borderRadius,
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
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: borderRadius ?? AppConstants.borderRadiusM,
      ),
      child: Text(
        distance,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontSize: fontSize ?? AppConstants.fontSizeM,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

