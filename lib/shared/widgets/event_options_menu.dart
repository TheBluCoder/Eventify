import 'package:flutter/material.dart';
import '../../app/app_constants.dart';
import '../../app/app_theme.dart';

/// Reusable event options menu widget
/// Provides a popup menu with common event actions
class EventOptionsMenu extends StatelessWidget {
  final String organizerUsername;
  final VoidCallback? onAddToCalendar;
  final VoidCallback? onFlag;
  final VoidCallback? onShare;
  final VoidCallback? onFollow;
  final bool showAddToCalendar;
  final bool showFlag;
  final bool showShare;
  final bool showFollow;
  final Widget? icon;
  final Color? iconColor;
  final double? iconSize;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final Color? menuColor;
  final bool useCustomButton;
  final Widget? customButton;

  const EventOptionsMenu({
    super.key,
    required this.organizerUsername,
    this.onAddToCalendar,
    this.onFlag,
    this.onShare,
    this.onFollow,
    this.showAddToCalendar = true,
    this.showFlag = true,
    this.showShare = true,
    this.showFollow = true,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.padding,
    this.constraints,
    this.menuColor,
    this.useCustomButton = false,
    this.customButton,
  });

  @override
  Widget build(BuildContext context) {
    final List<PopupMenuItem<String>> items = [];

    if (showAddToCalendar && onAddToCalendar != null) {
      items.add(
        PopupMenuItem<String>(
          value: 'add_to_calendar',
          child: Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: AppConstants.iconSizeM,
                color: AppTheme.grey700,
              ),
              const SizedBox(width: AppConstants.spacingM),
              Text(
                'Add to Calendar',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: AppConstants.fontSizeL,
                      color: AppTheme.grey700,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    if (showFlag && onFlag != null) {
      items.add(
        PopupMenuItem<String>(
          value: 'flag',
          child: Row(
            children: [
              Icon(
                Icons.flag_outlined,
                size: AppConstants.iconSizeM,
                color: AppTheme.grey700,
              ),
              const SizedBox(width: AppConstants.spacingM),
              Text(
                'Flag',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: AppConstants.fontSizeL,
                      color: AppTheme.grey700,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    if (showShare && onShare != null) {
      items.add(
        PopupMenuItem<String>(
          value: 'share',
          child: Row(
            children: [
              Icon(
                Icons.ios_share_outlined,
                size: AppConstants.iconSizeM,
                color: AppTheme.grey700,
              ),
              const SizedBox(width: AppConstants.spacingM),
              Text(
                'Share',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: AppConstants.fontSizeL,
                      color: AppTheme.grey700,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    if (showFollow && onFollow != null) {
      items.add(
        PopupMenuItem<String>(
          value: 'follow',
          child: Row(
            children: [
              Icon(
                Icons.person_add,
                size: AppConstants.iconSizeM,
                color: AppTheme.grey700,
              ),
              const SizedBox(width: AppConstants.spacingM),
              Text(
                'Follow $organizerUsername',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: AppConstants.fontSizeL,
                      color: AppTheme.grey700,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return PopupMenuButton<String>(
      icon: useCustomButton
          ? null
          : (icon ??
              Icon(
                Icons.more_horiz,
                size: iconSize ?? AppConstants.iconSizeXL,
                color: iconColor ?? AppTheme.grey600,
              )),
      child: useCustomButton ? customButton : null,
      padding: padding ?? EdgeInsets.zero,
      constraints: constraints ?? const BoxConstraints(),
      color: menuColor ?? Colors.white,
      onSelected: (value) {
        switch (value) {
          case 'add_to_calendar':
            onAddToCalendar?.call();
            break;
          case 'flag':
            onFlag?.call();
            break;
          case 'share':
            onShare?.call();
            break;
          case 'follow':
            onFollow?.call();
            break;
        }
      },
      itemBuilder: (BuildContext context) => items,
    );
  }
}

