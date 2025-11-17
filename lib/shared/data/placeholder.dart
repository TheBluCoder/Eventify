import '../models/event_model.dart';
import '../models/notification_model.dart';

/// Placeholder data for the application
/// This file contains all mock/placeholder data used throughout the app
class PlaceholderData {
  // ============================================
  // Event Data
  // ============================================
  
  /// Events from followed organizers (for Following feed)
  static final List<EventModel> followingEvents = [
    EventModel(
      id: '1',
      title: 'Tech Innovation Summit',
      description: 'Join us for an exciting discussion about latest trends in ML and networking with industry leaders!',
      organizerUsername: 'Tech Community',
      organizerAvatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&crop=face',
      dateTime: DateTime.now().add(const Duration(hours: 7)),
      location: 'Tech Hub Lagos',
      distanceKm: 0.3,
      latitude: 45.4247,
      longitude: -75.6750,
      interestedCount: 124,
      tags: ['Tech', 'AI', 'Networking'],
      mediaUrl: 'https://images.unsplash.com/photo-1515187029135-18ee286d815b?w=300&h=200&fit=crop',
      isVideo: true,
      isFollowingOrganizer: true,
      isRSVP: true,
      isLiked: true,
      isSaved: false,
      sharesCount: 8,
    ),
    EventModel(
      id: '2',
      title: 'Music Concert Night and day and more party and stuff',
      description: 'Amazing live music performance by local bands. Free entry for all attendees!',
      organizerUsername: 'Music Collective',
      organizerAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
      dateTime: DateTime.now().add(const Duration(hours: 15)),
      location: 'Concert Hall Downtown',
      distanceKm: 0.5,
      latitude: 45.4255,
      longitude: -75.6965,
      interestedCount: 89,
      tags: ['Music', 'Live', 'Entertainment'],
      mediaUrl: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=200&fit=crop',
      isVideo: false,
      isFollowingOrganizer: true,
      isRSVP: false,
      isLiked: false,
      isSaved: true,
      sharesCount: 15,
      registrationUrl: "https://www.eventbrite.com/e/music-concert-night-tickets-0987654321",
    ),
  ];

  /// Events for personalized recommendations (For You feed)
  static final List<EventModel> forYouEvents = [
    EventModel(
      id: '3',
      title: 'Design Thinking Workshop',
      description: 'Learn design thinking principles and apply them to real-world problems. Perfect for designers and product managers.',
      organizerUsername: 'Design Guild',
      organizerAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face',
      dateTime: DateTime.now().add(const Duration(hours: 24)),
      location: 'Innovation Center',
      distanceKm: 0.7,
      latitude: 45.4235,
      longitude: -75.6935,
      interestedCount: 45,
      tags: ['Design', 'Workshop', 'Career'],
      mediaUrl: 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=300&h=200&fit=crop',
      isVideo: true,
      isFollowingOrganizer: false,
      isRSVP: false,
      isLiked: false,
      isSaved: false,
      sharesCount: 5,
    ),
    EventModel(
      id: '4',
      title: 'Startup Networking Mixer',
      description: 'Connect with entrepreneurs, investors, and innovators in a relaxed setting. Free drinks and appetizers.',
      organizerUsername: 'Startup Hub',
      organizerAvatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&crop=face',
      dateTime: DateTime.now().add(const Duration(days: 2, hours: 6)),
      location: 'Rooftop Bar',
      distanceKm: 1.2,
      latitude: 45.4465,
      longitude: -75.6975,
      interestedCount: 156,
      tags: ['Startup', 'Networking', 'Business'],
      mediaUrl: 'https://images.unsplash.com/photo-1515187029135-18ee286d815b?w=300&h=200&fit=crop',
      isVideo: false,
      isFollowingOrganizer: false,
      isRSVP: false,
      isLiked: true,
      isSaved: true,
      sharesCount: 22,
      registrationUrl: 'https://www.eventbrite.com/e/tech-innovation-summit-tickets-1234567890',
    ),
  ];

  /// Events for Discover page
  static final List<EventModel> discoverEvents = [
    EventModel(
      id: '1',
      title: 'Lotal Bands Night',
      description: 'Join us for an exciting discussion about latest trends i ML. networking!',
      organizerUsername: 'Tech Community',
      organizerAvatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&crop=face',
      dateTime: DateTime.now().add(const Duration(hours: 7)),
      location: 'Tech Hub Lagos',
      distanceKm: 0.3,
      latitude: 45.4247,
      longitude: -75.6950,
      interestedCount: 8,
      tags: ['Tech', 'AI', 'Networking'],
      mediaUrl: 'https://images.unsplash.com/photo-1515187029135-18ee286d815b?w=300&h=200&fit=crop',
      isVideo: true,
    ),
    EventModel(
      id: '2',
      title: 'Music Concert Night and day and more party and stuff',
      description: 'Amazing live music performance by local bands',
      organizerUsername: 'Tech Community',
      organizerAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
      dateTime: DateTime.now().add(const Duration(hours: 3)),
      location: 'Concert Hall',
      distanceKm: 0.5,
      latitude: 45.4255,
      longitude: -75.6965,
      interestedCount: 15,
      tags: ['Music', 'Live', 'Entertainment'],
      mediaUrl: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=200&fit=crop',
      isVideo: false,
    ),
    EventModel(
      id: '3',
      title: 'Tech Meetup',
      description: 'Networking event for tech professionals',
      organizerUsername: 'Tech Community',
      organizerAvatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face',
      dateTime: DateTime.now().add(const Duration(hours: 5)),
      location: 'Innovation Center',
      distanceKm: 0.7,
      latitude: 45.4235,
      longitude: -75.6935,
      interestedCount: 12,
      tags: ['Tech', 'Networking', 'Career'],
      mediaUrl: 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=300&h=200&fit=crop',
      isVideo: true,
    ),
    EventModel(
      id: '4',
      title: 'Art Gallery Opening',
      description: 'Explore contemporary art from local artists',
      organizerUsername: 'Arts Collective',
      organizerAvatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop&crop=face',
      dateTime: DateTime.now().add(const Duration(hours: 12)),
      location: 'Gallery District',
      distanceKm: 1.2,
      latitude: 45.4275,
      longitude: -75.6985,
      interestedCount: 25,
      tags: ['Art', 'Culture', 'Community'],
      mediaUrl: 'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=300&h=200&fit=crop',
      isVideo: false,
    ),
    EventModel(
      id: '5',
      title: 'Food Festival',
      description: 'Taste the best local cuisine from various vendors',
      organizerUsername: 'Food Network',
      organizerAvatar: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100&h=100&fit=crop&crop=face',
      dateTime: DateTime.now().add(const Duration(hours: 24)),
      location: 'City Park',
      distanceKm: 2.5,
      latitude: 45.4285,
      longitude: -75.6995,
      interestedCount: 50,
      tags: ['Food', 'Festival', 'Family'],
      mediaUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9c8368?w=300&h=200&fit=crop',
      isVideo: false,
    ),
  ];

  // ============================================
  // Category Data
  // ============================================
  
  /// Categories for filtering events in Discover page
  static final List<String> discoverCategories = [
    'All Events',
    'Today',
    'Free',
    'Music & Concerts',
  ];

  /// Trending events (based on interestedCount, sharesCount, and recency)
  static List<EventModel> get trendingEvents {
    final allEvents = [...discoverEvents, ...followingEvents, ...forYouEvents];
    // Sort by trending score: interestedCount * 2 + sharesCount * 3 + recency bonus
    final now = DateTime.now();
    final scoredEvents = allEvents.map((event) {
      final hoursUntilEvent = event.dateTime.difference(now).inHours;
      final recencyBonus = hoursUntilEvent > 0 && hoursUntilEvent < 48 ? 10 : 0;
      final trendingScore = (event.interestedCount * 2) + (event.sharesCount * 3) + recencyBonus;
      return MapEntry(event, trendingScore);
    }).toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return scoredEvents.map((e) => e.key).take(5).toList();
  }

  // ============================================
  // User Data
  // ============================================
  
  /// Current user's avatar image URL (used in home page app bar)
  static const String currentUserAvatar = 
    "https://cdn.dribbble.com/userupload/16394495/file/original-44f9e9320643c7c6d3f4203f161a987e.webp?resize=1024x1024&vertical=center";

  /// Current user's location (used in home page app bar)
  static const String currentUserLocation = "Downtown, Ottawa";

  /// Mock current user profile data
  static const Map<String, dynamic> mockCurrentUser = {
    'userName': 'John Doe',
    'userHandle': '@johndoe',
    'userAvatar': currentUserAvatar,
    'followersCount': 124,
    'followingCount': 89,
  };

  /// Mock followed pages/communities
  static final List<Map<String, dynamic>> mockFollowedPages = [
    {
      'id': '1',
      'name': 'Tech Community',
      'avatar': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&crop=face',
      'type': 'page',
      'followers': 1250,
      'isVerified': true,
    },
    {
      'id': '2',
      'name': 'Music Collective',
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
      'type': 'page',
      'followers': 890,
      'isVerified': false,
    },
    {
      'id': '3',
      'name': 'Design Guild',
      'avatar': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop&crop=face',
      'type': 'page',
      'followers': 650,
      'isVerified': true,
    },
    {
      'id': '4',
      'name': 'Startup Hub',
      'avatar': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop&crop=face',
      'type': 'page',
      'followers': 2100,
      'isVerified': true,
    },
  ];

  // ============================================
  // Location Data
  // ============================================

  /// Popular cities with coordinates for location selector
  static final List<Map<String, dynamic>> popularCities = [
    {'name': 'Lagos, Nigeria', 'lat': 6.5244, 'lng': 3.3792},
    {'name': 'Abuja, Nigeria', 'lat': 9.0765, 'lng': 7.3986},
    {'name': 'Port Harcourt, Nigeria', 'lat': 4.8156, 'lng': 7.0498},
    {'name': 'Ibadan, Nigeria', 'lat': 7.3775, 'lng': 3.9470},
    {'name': 'Kano, Nigeria', 'lat': 12.0022, 'lng': 8.5919},
    {'name': 'Accra, Ghana', 'lat': 5.6037, 'lng': -0.1870},
    {'name': 'Nairobi, Kenya', 'lat': -1.2921, 'lng': 36.8219},
    {'name': 'Cairo, Egypt', 'lat': 30.0444, 'lng': 31.2357},
    {'name': 'Johannesburg, South Africa', 'lat': -26.2041, 'lng': 28.0473},
    {'name': 'Cape Town, South Africa', 'lat': -33.9249, 'lng': 18.4241},
  ];

  /// Default location for discover controller
  static const String defaultLocation = 'Lagos, Nigeria';

  /// Default event count for discover controller
  static const int defaultEventCount = 247;

  // ============================================
  // Search & Filter Data
  // ============================================

  /// Categories for advanced search filtering
  static final List<String> searchFilterCategories = [
    'Tech',
    'Music',
    'Sports',
    'Food',
    'Art',
    'Community',
  ];

  /// Popular tags for events (used in create event sheet)
  static const List<String> popularTags = [
    'Tech',
    'Music',
    'Art',
    'Food',
    'Sports',
    'Networking',
    'Education',
    'Entertainment',
    'Community',
    'Business',
    'Health',
    'Fitness',
    'Culture',
    'Family',
    'AI',
    'Live',
    'Career',
    'Festival',
  ];

  // ============================================
  // Notification Data
  // ============================================

  /// Placeholder notifications for notifications page
  static List<NotificationItem> get placeholderNotifications {
    final now = DateTime.now();
    return [
      NotificationItem(
        id: '1',
        title: 'Event Reminder',
        message: 'Tech Meetup Lagos starts in 2 hours at Victoria Island',
        type: NotificationType.eventReminder,
        timestamp: now.subtract(const Duration(minutes: 15)),
        isRead: false,
        userName: 'Echoes',
        userAvatarUrl: currentUserAvatar,
        previewImageUrl: 'https://images.unsplash.com/photo-1505373877841-8d25f7d46678?w=400',
      ),
      NotificationItem(
        id: '2',
        title: 'New Follower',
        message: 'Sarah Johnson started following you',
        type: NotificationType.newFollower,
        timestamp: now.subtract(const Duration(hours: 1)),
        isRead: false,
        userName: 'sarah_johnson',
        userAvatarUrl: 'https://i.pravatar.cc/150?img=47',
      ),
      NotificationItem(
        id: '3',
        title: 'Event Updated',
        message: 'Music Festival 2024 has been rescheduled to next week',
        type: NotificationType.eventUpdate,
        timestamp: now.subtract(const Duration(hours: 3)),
        isRead: true,
        userName: 'Echoes',
        userAvatarUrl: currentUserAvatar,
        previewImageUrl: 'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=400',
      ),
      NotificationItem(
        id: '4',
        title: 'New Comment',
        message: 'Mike commented on your event: "Looking forward to this!"',
        type: NotificationType.comment,
        timestamp: now.subtract(const Duration(hours: 5)),
        isRead: false,
        userName: 'mike_taylor',
        userAvatarUrl: 'https://i.pravatar.cc/150?img=12',
        previewImageUrl: 'https://images.unsplash.com/photo-1511578314322-379afb476865?w=400',
      ),
      NotificationItem(
        id: '5',
        title: 'Event Reminder',
        message: 'Art Exhibition Opening is tomorrow at 6:00 PM',
        type: NotificationType.eventReminder,
        timestamp: now.subtract(const Duration(hours: 8)),
        isRead: true,
        userName: 'Echoes',
        userAvatarUrl: currentUserAvatar,
        previewImageUrl: 'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=400',
      ),
      NotificationItem(
        id: '6',
        title: 'New Like',
        message: 'Emma and 5 others liked your event "Food & Wine Tasting"',
        type: NotificationType.like,
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
        userName: 'emma_wilson',
        userAvatarUrl: 'https://i.pravatar.cc/150?img=33',
        otherUsersCount: 5,
        previewImageUrl: 'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400',
      ),
      NotificationItem(
        id: '7',
        title: 'New Follower',
        message: 'David Williams started following you',
        type: NotificationType.newFollower,
        timestamp: now.subtract(const Duration(days: 1, hours: 5)),
        isRead: true,
        userName: 'david_williams',
        userAvatarUrl: 'https://i.pravatar.cc/150?img=51',
      ),
      NotificationItem(
        id: '8',
        title: 'Event Reminder',
        message: 'Yoga Session starts in 30 minutes at Central Park',
        type: NotificationType.eventReminder,
        timestamp: now.subtract(const Duration(days: 2)),
        isRead: true,
        userName: 'Echoes',
        userAvatarUrl: currentUserAvatar,
        previewImageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=400',
      ),
      NotificationItem(
        id: '9',
        title: 'New Comment',
        message: 'Lisa replied to your comment on "Startup Networking Event"',
        type: NotificationType.comment,
        timestamp: now.subtract(const Duration(days: 2, hours: 3)),
        isRead: true,
        userName: 'lisa_anderson',
        userAvatarUrl: 'https://i.pravatar.cc/150?img=45',
        previewImageUrl: 'https://images.unsplash.com/photo-1556761175-5973dc0f32e7?w=400',
      ),
      NotificationItem(
        id: '10',
        title: 'Event Updated',
        message: 'Workshop location changed to Main Hall, Building A',
        type: NotificationType.eventUpdate,
        timestamp: now.subtract(const Duration(days: 3)),
        isRead: true,
        userName: 'Echoes',
        userAvatarUrl: currentUserAvatar,
        previewImageUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400',
      ),
      NotificationItem(
        id: '11',
        title: 'New Like',
        message: 'John liked your event "Photography Walk"',
        type: NotificationType.like,
        timestamp: now.subtract(const Duration(days: 4)),
        isRead: true,
        userName: 'john_smith',
        userAvatarUrl: 'https://i.pravatar.cc/150?img=15',
        previewImageUrl: 'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?w=400',
      ),
      NotificationItem(
        id: '12',
        title: 'Event Reminder',
        message: 'Book Club Meeting is this Saturday at 2:00 PM',
        type: NotificationType.eventReminder,
        timestamp: now.subtract(const Duration(days: 5)),
        isRead: true,
        userName: 'Echoes',
        userAvatarUrl: currentUserAvatar,
        previewImageUrl: 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400',
      ),
    ];
  }
}
