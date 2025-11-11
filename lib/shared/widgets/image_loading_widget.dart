import 'package:flutter/material.dart';
import '../../app/app_constants.dart';
import '../../app/app_theme.dart';

/// Reusable widget for loading and error states of network images
class ImageLoadingWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double? loadingProgress;
  final double? errorIconSize;

  const ImageLoadingWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.loadingProgress,
    this.errorIconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: width,
          height: height,
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
          width: width,
          height: height,
          color: AppTheme.grey200,
          child: Icon(
            Icons.image_not_supported,
            size: errorIconSize ?? AppConstants.iconSizeGiant,
            color: AppTheme.grey400,
          ),
        );
      },
    );
  }
}

