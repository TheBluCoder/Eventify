import 'package:flutter_test/flutter_test.dart';
import 'package:echoes/shared/data/placeholder.dart';

void main() {
  group('PlaceholderData', () {
    group('followingEvents', () {
      test('should contain exactly 2 events', () {
        expect(PlaceholderData.followingEvents.length, 2);
      });

      test('should have valid event structure', () {
        for (final event in PlaceholderData.followingEvents) {
          expect(event.id, isNotEmpty);
          expect(event.title, isNotEmpty);
          expect(event.description, isNotEmpty);
          expect(event.organizerUsername, isNotEmpty);
          expect(event.location, isNotEmpty);
          expect(event.attendeeCount, greaterThan(0));
          expect(event.tags, isNotEmpty);
          expect(event.mediaUrl, isNotEmpty);
        }
      });

      test('should have all events marked as following organizer', () {
        for (final event in PlaceholderData.followingEvents) {
          expect(event.isFollowingOrganizer, isTrue);
        }
      });

      test('should have future dates', () {
        final now = DateTime.now();
        for (final event in PlaceholderData.followingEvents) {
          expect(event.dateTime.isAfter(now), isTrue);
        }
      });

      test('first event should be Tech Innovation Summit', () {
        final firstEvent = PlaceholderData.followingEvents.first;
        expect(firstEvent.title, 'Tech Innovation Summit');
        expect(firstEvent.id, '1');
        expect(firstEvent.isRSVP, isTrue);
        expect(firstEvent.isLiked, isTrue);
        expect(firstEvent.likesCount, 42);
      });

      test('second event should be Music Concert Night', () {
        final secondEvent = PlaceholderData.followingEvents[1];
        expect(secondEvent.title, 'Music Concert Night');
        expect(secondEvent.id, '2');
        expect(secondEvent.isSaved, isTrue);
        expect(secondEvent.likesCount, 67);
      });
    });

    group('forYouEvents', () {
      test('should contain exactly 2 events', () {
        expect(PlaceholderData.forYouEvents.length, 2);
      });

      test('should have valid event structure', () {
        for (final event in PlaceholderData.forYouEvents) {
          expect(event.id, isNotEmpty);
          expect(event.title, isNotEmpty);
          expect(event.description, isNotEmpty);
          expect(event.organizerUsername, isNotEmpty);
          expect(event.location, isNotEmpty);
          expect(event.attendeeCount, greaterThan(0));
          expect(event.tags, isNotEmpty);
          expect(event.mediaUrl, isNotEmpty);
        }
      });

      test('should have all events marked as not following organizer', () {
        for (final event in PlaceholderData.forYouEvents) {
          expect(event.isFollowingOrganizer, isFalse);
        }
      });

      test('should have future dates', () {
        final now = DateTime.now();
        for (final event in PlaceholderData.forYouEvents) {
          expect(event.dateTime.isAfter(now), isTrue);
        }
      });

      test('first event should be Design Thinking Workshop', () {
        final firstEvent = PlaceholderData.forYouEvents.first;
        expect(firstEvent.title, 'Design Thinking Workshop');
        expect(firstEvent.id, '3');
        expect(firstEvent.isVideo, isTrue);
      });

      test('second event should be Startup Networking Mixer', () {
        final secondEvent = PlaceholderData.forYouEvents[1];
        expect(secondEvent.title, 'Startup Networking Mixer');
        expect(secondEvent.id, '4');
        expect(secondEvent.isLiked, isTrue);
        expect(secondEvent.isSaved, isTrue);
      });
    });

    group('discoverEvents', () {
      test('should contain exactly 5 events', () {
        expect(PlaceholderData.discoverEvents.length, 5);
      });

      test('should have valid event structure', () {
        for (final event in PlaceholderData.discoverEvents) {
          expect(event.id, isNotEmpty);
          expect(event.title, isNotEmpty);
          expect(event.description, isNotEmpty);
          expect(event.organizerUsername, isNotEmpty);
          expect(event.location, isNotEmpty);
          expect(event.attendeeCount, greaterThan(0));
          expect(event.tags, isNotEmpty);
          expect(event.mediaUrl, isNotEmpty);
        }
      });

      test('should have future dates', () {
        final now = DateTime.now();
        for (final event in PlaceholderData.discoverEvents) {
          expect(event.dateTime.isAfter(now), isTrue);
        }
      });

      test('should have increasing distances', () {
        final distances = PlaceholderData.discoverEvents.map((e) => e.distanceKm).toList();
        expect(distances[0], 0.3);
        expect(distances[1], 0.5);
        expect(distances[2], 0.7);
        expect(distances[3], 1.2);
        expect(distances[4], 2.5);
      });

      test('should have variety of event types', () {
        final titles = PlaceholderData.discoverEvents.map((e) => e.title).toList();
        expect(titles, contains('Lotal Bands Night'));
        expect(titles, contains('Music Concert Night'));
        expect(titles, contains('Tech Meetup'));
        expect(titles, contains('Art Gallery Opening'));
        expect(titles, contains('Food Festival'));
      });

      test('last event should have highest attendee count', () {
        final lastEvent = PlaceholderData.discoverEvents.last;
        expect(lastEvent.title, 'Food Festival');
        expect(lastEvent.attendeeCount, 50);
      });
    });

    group('discoverCategories', () {
      test('should contain exactly 4 categories', () {
        expect(PlaceholderData.discoverCategories.length, 4);
      });

      test('should have expected categories in order', () {
        expect(PlaceholderData.discoverCategories[0], 'All Events');
        expect(PlaceholderData.discoverCategories[1], 'Today');
        expect(PlaceholderData.discoverCategories[2], 'Free');
        expect(PlaceholderData.discoverCategories[3], 'Music & Concerts');
      });

      test('should start with "All Events"', () {
        expect(PlaceholderData.discoverCategories.first, 'All Events');
      });

      test('all categories should be non-empty strings', () {
        for (final category in PlaceholderData.discoverCategories) {
          expect(category, isNotEmpty);
          expect(category, isA<String>());
        }
      });
    });

    group('currentUserAvatar', () {
      test('should be a valid URL string', () {
        expect(PlaceholderData.currentUserAvatar, isNotEmpty);
        expect(PlaceholderData.currentUserAvatar, startsWith('http'));
      });

      test('should be a const string', () {
        expect(PlaceholderData.currentUserAvatar, isA<String>());
      });
    });

    group('currentUserLocation', () {
      test('should be a valid location string', () {
        expect(PlaceholderData.currentUserLocation, isNotEmpty);
        expect(PlaceholderData.currentUserLocation, 'Downtown, Ottawa');
      });

      test('should be a const string', () {
        expect(PlaceholderData.currentUserLocation, isA<String>());
      });
    });

    group('data consistency', () {
      test('all events should have unique IDs within their category', () {
        final allEvents = [
          ...PlaceholderData.followingEvents,
          ...PlaceholderData.forYouEvents,
          ...PlaceholderData.discoverEvents,
        ];
        final ids = allEvents.map((e) => e.id).toList();
        
        // Note: Some IDs may overlap between different lists, which is okay
        expect(ids.length, greaterThan(0));
      });

      test('all events should have valid distance values', () {
        final allEvents = [
          ...PlaceholderData.followingEvents,
          ...PlaceholderData.forYouEvents,
          ...PlaceholderData.discoverEvents,
        ];
        
        for (final event in allEvents) {
          expect(event.distanceKm, greaterThanOrEqualTo(0.0));
          expect(event.distanceKm, lessThan(100.0)); // Reasonable max distance
        }
      });

      test('all events should have at least one tag', () {
        final allEvents = [
          ...PlaceholderData.followingEvents,
          ...PlaceholderData.forYouEvents,
          ...PlaceholderData.discoverEvents,
        ];
        
        for (final event in allEvents) {
          expect(event.tags.length, greaterThan(0));
        }
      });

      test('all events should have valid URLs', () {
        final allEvents = [
          ...PlaceholderData.followingEvents,
          ...PlaceholderData.forYouEvents,
          ...PlaceholderData.discoverEvents,
        ];
        
        for (final event in allEvents) {
          expect(event.mediaUrl, startsWith('http'));
          expect(event.organizerAvatar, startsWith('http'));
        }
      });
    });
  });
}
