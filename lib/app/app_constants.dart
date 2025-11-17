/// Application-wide constants
class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://api.echoes.app';
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // App Configuration
  static const String appName = 'Echoes';
  static const String appVersion = '1.0.0';
  
  // UI Constants
  static const double maxContentWidth = 1100.0;
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration refreshDelay = Duration(seconds: 1);
  
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 6.0;
  static const double spacingM = 8.0;
  static const double spacingL = 12.0;
  static const double spacingXL = 16.0;
  static const double spacingXXL = 20.0;
  static const double spacingXXXL = 24.0;
  static const double spacingHuge = 40.0;
  
  // Padding
  static const double paddingXS = 2.0;
  static const double paddingS = 4.0;
  static const double paddingM = 8.0;
  static const double paddingL = 12.0;
  static const double paddingXL = 16.0;
  static const double paddingXXL = 20.0;
  
  // Border Radius
  static const double borderRadiusXS = 8.0;
  static const double borderRadiusS = 10.0;
  static const double borderRadiusM = 12.0;
  static const double borderRadiusL = 20.0;
  static const double borderRadiusXL = 25.0;
  static const double borderRadiusCircle = 25.0;
  
  // Icon Sizes
  static const double iconSizeXS = 10.0;
  static const double iconSizeS = 12.0;
  static const double iconSizeM = 14.0;
  static const double iconSizeL = 16.0;
  static const double iconSizeXL = 18.0;
  static const double iconSizeXXL = 20.0;
  static const double iconSizeHuge = 32.0;
  static const double iconSizeGiant = 48.0;
  static const double iconSizePlay = 32.0;
  
  // Font Sizes
  static const double fontSizeXS = 9.0;
  static const double fontSizeS = 10.0;
  static const double fontSizeM = 11.0;
  static const double fontSizeL = 13.0;
  static const double fontSizeXL = 14.0;
  static const double fontSizeXXL = 16.0;
  static const double fontSizeTitle = 24.0;
  
  // Container Sizes
  static const double avatarRadiusSmall = 10.0;
  static const double avatarRadiusMedium = 20.0;
  static const double bannerHeight = 280.0;
  static const double cardImageHeight = 100.0;
  static const double cardImageWidth = 100.0;
  static const double trendingCardHeight = 200.0;
  static const double dragHandleWidth = 40.0;
  static const double dragHandleHeight = 4.0;
  static const double categoryFilterHeight = 40.0;
  
  // Aspect Ratios
  static const double aspectRatio16_9 = 16 / 9;
  static const double aspectRatioCard = 0.60;
  
  // Screen Percentages
  static const double mapHeightPercentage = 0.4;
  static const double sheetInitialSize = 0.6;
  static const double sheetMinSize = 0.6;
  static const double sheetMaxSize = 1.0;
  
  // Card Width Constraints
  static const double cardWidthMin = 200.0;
  static const double cardWidthMax = 350.0;
  static const double cardWidthPortraitPercentage = 0.32;
  static const double cardWidthLandscapePercentage = 0.22;
  
  // Badge Constraints
  static const double badgeMaxWidth = 120.0;
  static const double registrationButtonWidth = 80.0;
  static const double registrationButtonHeight = 28.0;
  
  // Opacity Values
  static const double opacityLight = 0.2;
  static const double opacityMedium = 0.5;
  static const double opacityHeavy = 0.7;
  static const double opacityVeryHeavy = 0.8;
  
  // Shadow
  static const double shadowBlurS = 4.0;
  static const double shadowBlurM = 8.0;
  static const double shadowBlurL = 10.0;
  static const double shadowBlurXL = 20.0;
  static const double shadowOffsetY = 2.0;
  static const double shadowOffsetX = 0.0;
  
  // Animation
  static const double blurSigma = 1.5;
  static const double blurSigmaM = 2.0;
  
  // Map
  static const double mapZoom = 13.0;
  
  // Text
  static const double textLineHeight = 1.3;
  static const int maxLinesTitle = 2;
  static const int maxLinesDescription = 2;
  
  // Feed Tabs
  static const String feedTabFollowing = 'Following';
  static const String feedTabForYou = 'For You';
  
  // Categories
  static const String categoryAllEvents = 'All Events';

  // Date/Time Constants
  static const List<String> monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  static const List<String> monthNamesFull = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  static const List<String> dayNames = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
  ];

  static const List<String> dayNamesFull = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday',
    'Friday', 'Saturday', 'Sunday'
  ];

  // App Information
  static const String appBuildNumber = '1000';
  static const String appVersionFull = 'Version $appVersion ($appBuildNumber)';
}
