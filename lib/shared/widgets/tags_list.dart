import 'package:flutter/material.dart';
import '../../app/app_theme.dart';

/// Reusable tags list widget
/// Displays a list of tags in a wrap layout with consistent styling
class TagsList extends StatelessWidget {
  final List<String> tags;
  final int? maxTags;
  final double fontSize;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;
  final double spacing;
  final double runSpacing;

  const TagsList({
    super.key,
    required this.tags,
    this.maxTags,
    this.fontSize = 10,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 8,
    this.spacing = 8,
    this.runSpacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    final displayTags = maxTags != null && tags.length > maxTags!
        ? tags.take(maxTags!).toList()
        : tags;

    if (displayTags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: displayTags.map((tag) => _buildTag(context, tag)).toList(),
    );
  }

  Widget _buildTag(BuildContext context, String tag) {
    final effectiveBackgroundColor = backgroundColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? AppTheme.darkSurfaceVariant.withValues(alpha: 0.5)
            : Colors.grey[200]);

    final effectiveTextColor = textColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? AppTheme.darkText
            : Colors.black87);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontSize: fontSize,
          color: effectiveTextColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
