import '../models/event_model.dart';

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
}
