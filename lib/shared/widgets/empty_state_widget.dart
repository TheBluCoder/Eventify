import 'package:flutter/material.dart';
import '../../app/app_constants.dart';
import '../../app/app_theme.dart';

/// Reusable empty state widget
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final double? iconSize;
  final EdgeInsets? padding;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.icon = Icons.event_busy,
    this.iconSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(AppConstants.spacingHuge),
      child: Center(
        child: Column(
          children: [
            Icon(
              icon,
              size: iconSize ?? AppConstants.iconSizeGiant,
              color: AppTheme.grey400,
            ),
            const SizedBox(height: AppConstants.spacingXL),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.grey600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

