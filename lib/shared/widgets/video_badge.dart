import 'package:flutter/material.dart';
import '../../app/app_constants.dart';
import '../../app/app_theme.dart';

/// Reusable video badge widget
class VideoBadge extends StatelessWidget {
  final double? iconSize;
  final double? fontSize;
  final EdgeInsets? padding;
  final double? borderRadius;

  const VideoBadge({
    super.key,
    this.iconSize,
    this.fontSize,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingS,
            vertical: AppConstants.paddingXS,
          ),
      decoration: AppTheme.badgeDecoration(
        color: Colors.black,
        borderRadius: borderRadius ?? AppConstants.borderRadiusXS,
        opacity: AppConstants.opacityHeavy,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.play_circle_filled,
            size: iconSize ?? AppConstants.iconSizeS,
            color: Colors.white,
          ),
          const SizedBox(width: AppConstants.paddingXS),
          Text(
            'Video',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontSize: fontSize ?? AppConstants.fontSizeXS,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

