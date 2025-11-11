import 'package:flutter/material.dart';
import '../../app/app_constants.dart';
import '../../app/app_theme.dart';
import '../models/event_model.dart';
import 'distance_badge.dart';

/// Reusable event image with overlays widget
class EventImageWithOverlays extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onLikeTap;
  final bool showLikeButton;
  final double? borderRadius;
  final EdgeInsets? badgePadding;

  const EventImageWithOverlays({
    super.key,
    required this.event,
    this.onLikeTap,
    this.showLikeButton = true,
    this.borderRadius,
    this.badgePadding,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          event.mediaUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;

            return Container(
              color: AppTheme.grey300,
              child: Center(
                child: CircularProgressIndicator.adaptive(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  strokeWidth: 2,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppTheme.grey200,
              child: Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: AppConstants.iconSizeGiant,
                  color: AppTheme.grey400,
                ),
              ),
            );
          },
        ),
        // Gradient overlay
        Container(
          decoration: AppTheme.gradientOverlay,
        ),
        // Like icon on top-left
        if (showLikeButton)
          Positioned(
            top: AppConstants.spacingL,
            left: AppConstants.spacingL,
            child: GestureDetector(
              onTap: onLikeTap,
              child: Container(
                padding: const EdgeInsets.all(AppConstants.paddingM),
                decoration: AppTheme.badgeDecoration(
                  color: Colors.black,
                  borderRadius: AppConstants.borderRadiusCircle,
                  opacity: AppConstants.opacityMedium,
                ),
                child: Icon(
                  event.isLiked ? Icons.favorite : Icons.favorite_border,
                  size: AppConstants.iconSizeXXL,
                  color: event.isLiked ? Colors.red : Colors.white,
                ),
              ),
            ),
          ),
        // Location and Distance stacked on top-right
        Positioned(
          top: AppConstants.spacingL,
          right: AppConstants.spacingL,
          child: DistanceBadge(
            distance: event.formattedDistance,
            padding: badgePadding,
          ),
        ),
        // Video indicator if it's a video (centered play button)
        if (event.isVideo)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: AppConstants.opacityLight),
                borderRadius: BorderRadius.circular(
                  borderRadius ?? AppConstants.borderRadiusM,
                ),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.spacingL),
                  decoration: AppTheme.badgeDecoration(
                    color: Colors.black,
                    borderRadius: AppConstants.borderRadiusCircle,
                    opacity: AppConstants.opacityHeavy,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    size: AppConstants.iconSizePlay,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

