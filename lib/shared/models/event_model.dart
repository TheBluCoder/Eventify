class EventModel {
  final String id;
  final String title;
  final String description;
  final String organizerUsername; // The username of the organizer (e.g., "Tech Community")
  final String organizerAvatar; // The profile picture URL of the organizer
  final DateTime dateTime;
  final String location;
  final double distanceKm;
  final double latitude; // Map coordinate latitude
  final double longitude; // Map coordinate longitude
  final int interestedCount;
  final List<String> tags;
  final String mediaUrl; // Can be either image or video URL
  final bool isVideo; // Whether the mediaUrl is a video or image
  final String? registrationUrl; // External registration link (Eventbrite, etc.) - null if no registration required
  
  // Event scheduling
  final DateTime? expirationDate; // Date when event should be removed from backend (defaults to start date)
  final bool isRecurring; // Whether this is a recurring event
  final List<int>? recurringDays; // Days of week (1=Monday, 7=Sunday) when event recurs
  final DateTime? recurringPeriodStart; // Start date of recurring period
  final DateTime? recurringPeriodEnd; // End date of recurring period
  
  // Social features
  final bool isLiked;
  final bool isSaved;
  final bool isRSVP; // User RSVP status
  final bool isFollowingOrganizer; // Whether user follows the organizer
  final int sharesCount;
  final bool isUserEvent; // Whether this is user's own event
  final bool isBoosted; // Whether this event was boosted by someone you follow
  final String? boosterUsername; // Username of the person who boosted this event (if boosted)

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.organizerUsername,
    required this.organizerAvatar,
    required this.dateTime,
    required this.location,
    required this.distanceKm,
    required this.latitude,
    required this.longitude,
    required this.tags,
    required this.mediaUrl,
    this.isVideo = false,
    this.interestedCount = 0,
    this.registrationUrl,
    this.expirationDate,
    this.isRecurring = false,
    this.recurringDays,
    this.recurringPeriodStart,
    this.recurringPeriodEnd,
    this.isLiked = false,
    this.isSaved = false,
    this.isRSVP = false,
    this.isFollowingOrganizer = false,
    // this.likesCount = 0,
    this.sharesCount = 0,
    this.isUserEvent = false,
    this.isBoosted = false,
    this.boosterUsername,
  });

  /// Gets the expiration date, defaulting to the event start date if not set
  DateTime get effectiveExpirationDate {
    return expirationDate ?? dateTime;
  }

  String get formattedDateTime {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (eventDate == today) {
      return 'Today, ${_formatTime(dateTime)}';
    } else if (eventDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow, ${_formatTime(dateTime)}';
    } else {
      return '${_formatDate(dateTime)}, ${_formatTime(dateTime)}';
    }
  }

  String get formattedDistance {
    if (distanceKm < 1) {
      return '${(distanceKm * 1000).round()}m';
    } else {
      return '${distanceKm.toStringAsFixed(1)} km';
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  String _formatDate(DateTime dateTime) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dateTime.month - 1]} ${dateTime.day}';
  }
}
