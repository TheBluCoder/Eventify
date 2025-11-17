import 'package:flutter/material.dart';
import '../../app/app_constants.dart';
import '../../app/app_theme.dart';

/// Generic reusable badge widget
/// Base component for creating various types of badges (distance, location, tags, etc.)
class Badge extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final EdgeInsets? padding;
  final double? borderRadius;
  final double? maxWidth;
  final bool withShadow;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;

  const Badge({
    super.key,
    required this.label,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.padding,
    this.borderRadius,
    this.maxWidth,
    this.withShadow = true,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? Colors.black.withValues(alpha: 0.6);
    final effectiveTextColor = textColor ?? Colors.white;

    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingM,
            vertical: AppConstants.paddingS,
          ),
      decoration: withShadow
          ? AppTheme.badgeDecorationWithShadow(
              context,
              color: effectiveBackgroundColor,
              borderRadius: borderRadius ?? AppConstants.borderRadiusM,
            )
          : AppTheme.badgeDecoration(
              color: effectiveBackgroundColor,
              borderRadius: borderRadius ?? AppConstants.borderRadiusM,
            ),
      constraints: maxWidth != null
          ? BoxConstraints(maxWidth: maxWidth!)
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: fontSize ?? AppConstants.fontSizeM,
              color: effectiveTextColor,
            ),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: effectiveTextColor,
                    fontSize: fontSize ?? AppConstants.fontSizeM,
                    fontWeight: fontWeight ?? FontWeight.w600,
                  ),
              maxLines: maxLines,
              overflow: overflow,
            ),
          ),
        ],
      ),
    );
  }
}
