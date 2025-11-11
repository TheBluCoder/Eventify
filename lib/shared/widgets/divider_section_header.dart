import 'package:flutter/material.dart';
import '../../app/app_constants.dart';
import '../../app/app_theme.dart';

/// Reusable divider section header widget
class DividerSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final EdgeInsets? padding;

  const DividerSectionHeader({
    super.key,
    required this.title,
    this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingXXL,
            vertical: AppConstants.paddingM,
          ),
      child: Column(
        children: [
          Divider(height: 1, color: AppTheme.grey200),
          const SizedBox(height: AppConstants.paddingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.grey700,
                    ),
              ),
              Icon(
                Icons.arrow_forward_ios_outlined,
                size: AppConstants.iconSizeL,
                color: AppTheme.grey600,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingM),
          Divider(height: 1, color: AppTheme.grey200),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }
}

