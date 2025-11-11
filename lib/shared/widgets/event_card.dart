import 'package:flutter/material.dart';
import '../../app/app_constants.dart';
import '../../app/app_theme.dart';
import '../models/event_model.dart';
import 'event_image_with_overlays.dart';
import 'registration_button.dart';

/// Reusable event card widget
class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onLikeTap;
  final VoidCallback? onMoreTap;
  final VoidCallback? onRegistrationTap;
  final bool showRegistrationButton;
  final bool showImage;
  final double? imageAspectRatio;

  const EventCard({
    super.key,
    required this.event,
    this.onLikeTap,
    this.onMoreTap,
    this.onRegistrationTap,
    this.showRegistrationButton = true,
    this.showImage = true,
    this.imageAspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: AppTheme.grey300)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: AppConstants.paddingXS,
              right: AppConstants.spacingXL,
              top: AppConstants.spacingL,
              bottom: AppConstants.spacingL,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Organizer avatar
                CircleAvatar(
                  radius: AppConstants.avatarRadiusMedium,
                  backgroundColor: AppTheme.grey200,
                  backgroundImage: NetworkImage(event.organizerAvatar),
                  onBackgroundImageError: (exception, stackTrace) {},
                  child: event.organizerAvatar.isEmpty
                      ? Icon(
                          Icons.person,
                          size: AppConstants.iconSizeXXL,
                          color: AppTheme.grey600,
                        )
                      : null,
                ),
                const SizedBox(width: AppConstants.spacingL),
                // Content area
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Organizer name
                      Row(
                        children: [
                          Expanded(
                            child: Wrap(
                              children: [
                                Text(
                                  event.organizerUsername,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: AppConstants.fontSizeL,
                                        color: AppTheme.grey700,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: onMoreTap,
                            icon: Icon(
                              Icons.more_horiz,
                              size: AppConstants.iconSizeXL,
                              color: AppTheme.grey600,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.spacingS),
                      // Image with overlays
                      if (showImage && event.mediaUrl.isNotEmpty)
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
                            child: AspectRatio(
                              aspectRatio: imageAspectRatio ?? AppConstants.aspectRatio16_9,
                              child: EventImageWithOverlays(
                                event: event,
                                onLikeTap: onLikeTap,
                              ),
                            ),
                          ),
                        ),
                      if (showImage && event.mediaUrl.isNotEmpty)
                        const SizedBox(height: AppConstants.spacingL),
                      // Event details
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Event title
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  event.title,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                        fontSize: AppConstants.fontSizeXL,
                                        height: AppConstants.textLineHeight,
                                      ),
                                ),
                              ),
                              // Registration button
                              if (showRegistrationButton &&
                                  event.registrationUrl != null &&
                                  event.registrationUrl!.isNotEmpty)
                                RegistrationButton(
                                  onPressed: onRegistrationTap ?? () {},
                                ),
                            ],
                          ),
                          const SizedBox(height: AppConstants.paddingM),
                          // Time with icon
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: AppConstants.iconSizeM,
                                color: AppTheme.grey600,
                              ),
                              const SizedBox(width: AppConstants.spacingS),
                              Text(
                                event.formattedDateTime,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.grey700,
                                      fontSize: AppConstants.fontSizeL,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppConstants.spacingS),
                          // Location with icon
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: AppConstants.iconSizeM,
                                color: AppTheme.grey600,
                              ),
                              const SizedBox(width: AppConstants.spacingS),
                              Expanded(
                                child: Text(
                                  event.location,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.grey700,
                                        fontSize: AppConstants.fontSizeL,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppConstants.spacingS),
                          // Partial description
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text(
                              event.description,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.grey600,
                                    fontSize: AppConstants.fontSizeL,
                                    height: AppConstants.textLineHeight,
                                  ),
                              maxLines: AppConstants.maxLinesDescription,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.spacingL),
                      // Tags
                      if (event.tags.isNotEmpty) ...[
                        Wrap(
                          spacing: AppConstants.spacingS,
                          runSpacing: AppConstants.paddingS,
                          children: event.tags
                              .map(
                                (tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppConstants.paddingM,
                                    vertical: AppConstants.paddingS,
                                  ),
                                  decoration: AppTheme.tagDecoration,
                                  child: Text(
                                    tag,
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                          fontSize: AppConstants.fontSizeM,
                                          color: AppTheme.grey700,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

