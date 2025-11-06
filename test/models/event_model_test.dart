import 'package:flutter_test/flutter_test.dart';
import 'package:echoes/shared/models/event_model.dart';

void main() {
  group('EventModel', () {
    late EventModel testEvent;

    setUp(() {
      testEvent = EventModel(
        id: 'test-1',
        title: 'Test Event',
        description: 'A test event description',
        organizerUsername: 'Test Organizer',
        organizerAvatar: 'https://example.com/avatar.jpg',
        dateTime: DateTime(2025, 11, 5, 15, 30), // Nov 5, 2025, 3:30 PM
        location: 'Test Location',
        distanceKm: 1.5,
        attendeeCount: 50,
        tags: ['Test', 'Event'],
        mediaUrl: 'https://example.com/image.jpg',
      );
    });

    group('constructor', () {
      test('should create event with required fields', () {
        expect(testEvent.id, 'test-1');
        expect(testEvent.title, 'Test Event');
        expect(testEvent.description, 'A test event description');
        expect(testEvent.organizerUsername, 'Test Organizer');
        expect(testEvent.location, 'Test Location');
      });

      test('should have default values for optional fields', () {
        expect(testEvent.isVideo, false);
        expect(testEvent.isLiked, false);
        expect(testEvent.isSaved, false);
        expect(testEvent.isRSVP, false);
        expect(testEvent.isFollowingOrganizer, false);
        expect(testEvent.likesCount, 0);
        expect(testEvent.sharesCount, 0);
        expect(testEvent.commentsCount, 0);
        expect(testEvent.isUserEvent, false);
      });

      test('should accept custom values for optional fields', () {
        final event = EventModel(
          id: 'test-2',
          title: 'Custom Event',
          description: 'Custom description',
          organizerUsername: 'Custom Organizer',
          organizerAvatar: 'https://example.com/custom-avatar.jpg',
          dateTime: DateTime(2025, 11, 6),
          location: 'Custom Location',
          distanceKm: 2.0,
          attendeeCount: 100,
          tags: ['Custom'],
          mediaUrl: 'https://example.com/custom-video.mp4',
          isVideo: true,
          isLiked: true,
          isSaved: true,
          isRSVP: true,
          isFollowingOrganizer: true,
          likesCount: 42,
          sharesCount: 15,
          commentsCount: 23,
          isUserEvent: true,
        );

        expect(event.isVideo, true);
        expect(event.isLiked, true);
        expect(event.isSaved, true);
        expect(event.isRSVP, true);
        expect(event.isFollowingOrganizer, true);
        expect(event.likesCount, 42);
        expect(event.sharesCount, 15);
        expect(event.commentsCount, 23);
        expect(event.isUserEvent, true);
      });
    });

    group('formattedDateTime', () {
      test('should format today\'s event correctly', () {
        final now = DateTime.now();
        final todayEvent = EventModel(
          id: 'today-event',
          title: 'Today Event',
          description: 'Description',
          organizerUsername: 'Organizer',
          organizerAvatar: 'https://example.com/avatar.jpg',
          dateTime: DateTime(now.year, now.month, now.day, 14, 30),
          location: 'Location',
          distanceKm: 1.0,
          attendeeCount: 10,
          tags: ['Test'],
          mediaUrl: 'https://example.com/image.jpg',
        );

        expect(todayEvent.formattedDateTime, startsWith('Today, '));
        expect(todayEvent.formattedDateTime, contains('2:30 PM'));
      });

      test('should format tomorrow\'s event correctly', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        final tomorrowEvent = EventModel(
          id: 'tomorrow-event',
          title: 'Tomorrow Event',
          description: 'Description',
          organizerUsername: 'Organizer',
          organizerAvatar: 'https://example.com/avatar.jpg',
          dateTime: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 10, 15),
          location: 'Location',
          distanceKm: 1.0,
          attendeeCount: 10,
          tags: ['Test'],
          mediaUrl: 'https://example.com/image.jpg',
        );

        expect(tomorrowEvent.formattedDateTime, startsWith('Tomorrow, '));
        expect(tomorrowEvent.formattedDateTime, contains('10:15 AM'));
      });

      test('should format future date event correctly', () {
        final futureEvent = EventModel(
          id: 'future-event',
          title: 'Future Event',
          description: 'Description',
          organizerUsername: 'Organizer',
          organizerAvatar: 'https://example.com/avatar.jpg',
          dateTime: DateTime(2025, 12, 25, 18, 45),
          location: 'Location',
          distanceKm: 1.0,
          attendeeCount: 10,
          tags: ['Test'],
          mediaUrl: 'https://example.com/image.jpg',
        );

        expect(futureEvent.formattedDateTime, 'Dec 25, 6:45 PM');
      });

      test('should handle midnight correctly', () {
        final midnightEvent = EventModel(
          id: 'midnight-event',
          title: 'Midnight Event',
          description: 'Description',
          organizerUsername: 'Organizer',
          organizerAvatar: 'https://example.com/avatar.jpg',
          dateTime: DateTime(2025, 11, 10, 0, 0),
          location: 'Location',
          distanceKm: 1.0,
          attendeeCount: 10,
          tags: ['Test'],
          mediaUrl: 'https://example.com/image.jpg',
        );

        expect(midnightEvent.formattedDateTime, contains('12:00 AM'));
      });

      test('should handle noon correctly', () {
        final noonEvent = EventModel(
          id: 'noon-event',
          title: 'Noon Event',
          description: 'Description',
          organizerUsername: 'Organizer',
          organizerAvatar: 'https://example.com/avatar.jpg',
          dateTime: DateTime(2025, 11, 10, 12, 0),
          location: 'Location',
          distanceKm: 1.0,
          attendeeCount: 10,
          tags: ['Test'],
          mediaUrl: 'https://example.com/image.jpg',
        );

        expect(noonEvent.formattedDateTime, contains('12:00 PM'));
      });
    });

    group('formattedDistance', () {
      test('should format distance less than 1 km in meters', () {
        final closeEvent = EventModel(
          id: 'close-event',
          title: 'Close Event',
          description: 'Description',
          organizerUsername: 'Organizer',
          organizerAvatar: 'https://example.com/avatar.jpg',
          dateTime: DateTime(2025, 11, 10),
          location: 'Location',
          distanceKm: 0.5,
          attendeeCount: 10,
          tags: ['Test'],
          mediaUrl: 'https://example.com/image.jpg',
        );

        expect(closeEvent.formattedDistance, '500m');
      });

      test('should format distance of exactly 1 km', () {
        final oneKmEvent = EventModel(
          id: 'one-km-event',
          title: 'One KM Event',
          description: 'Description',
          organizerUsername: 'Organizer',
          organizerAvatar: 'https://example.com/avatar.jpg',
          dateTime: DateTime(2025, 11, 10),
          location: 'Location',
          distanceKm: 1.0,
          attendeeCount: 10,
          tags: ['Test'],
          mediaUrl: 'https://example.com/image.jpg',
        );

        expect(oneKmEvent.formattedDistance, '1.0 km');
      });

      test('should format distance greater than 1 km with decimal', () {
        expect(testEvent.formattedDistance, '1.5 km');
      });

      test('should format very small distances in meters', () {
        final veryCloseEvent = EventModel(
          id: 'very-close-event',
          title: 'Very Close Event',
          description: 'Description',
          organizerUsername: 'Organizer',
          organizerAvatar: 'https://example.com/avatar.jpg',
          dateTime: DateTime(2025, 11, 10),
          location: 'Location',
          distanceKm: 0.123,
          attendeeCount: 10,
          tags: ['Test'],
          mediaUrl: 'https://example.com/image.jpg',
        );

        expect(veryCloseEvent.formattedDistance, '123m');
      });

      test('should format large distances correctly', () {
        final farEvent = EventModel(
          id: 'far-event',
          title: 'Far Event',
          description: 'Description',
          organizerUsername: 'Organizer',
          organizerAvatar: 'https://example.com/avatar.jpg',
          dateTime: DateTime(2025, 11, 10),
          location: 'Location',
          distanceKm: 15.7,
          attendeeCount: 10,
          tags: ['Test'],
          mediaUrl: 'https://example.com/image.jpg',
        );

        expect(farEvent.formattedDistance, '15.7 km');
      });
    });

    group('private formatting methods', () {
      test('_formatTime should handle various times correctly', () {
        final morningEvent = EventModel(
          id: 'morning',
          title: 'Morning',
          description: 'Description',
          organizerUsername: 'Organizer',
          organizerAvatar: 'https://example.com/avatar.jpg',
          dateTime: DateTime(2025, 11, 10, 9, 5),
          location: 'Location',
          distanceKm: 1.0,
          attendeeCount: 10,
          tags: ['Test'],
          mediaUrl: 'https://example.com/image.jpg',
        );
        expect(morningEvent.formattedDateTime, contains('9:05 AM'));
      });

      test('_formatDate should format month abbreviations correctly', () {
        final months = [
          (1, 'Jan'), (2, 'Feb'), (3, 'Mar'), (4, 'Apr'),
          (5, 'May'), (6, 'Jun'), (7, 'Jul'), (8, 'Aug'),
          (9, 'Sep'), (10, 'Oct'), (11, 'Nov'), (12, 'Dec'),
        ];

        for (final (month, abbr) in months) {
          final event = EventModel(
            id: 'month-$month',
            title: 'Month Event',
            description: 'Description',
            organizerUsername: 'Organizer',
            organizerAvatar: 'https://example.com/avatar.jpg',
            dateTime: DateTime(2025, month, 15, 12, 0),
            location: 'Location',
            distanceKm: 1.0,
            attendeeCount: 10,
            tags: ['Test'],
            mediaUrl: 'https://example.com/image.jpg',
          );
          expect(event.formattedDateTime, contains('$abbr 15'));
        }
      });
    });

    group('edge cases', () {
      test('should handle empty tags list', () {
        final noTagsEvent = EventModel(
          id: 'no-tags',
          title: 'No Tags Event',
          description: 'Description',
          organizerUsername: 'Organizer',
          organizerAvatar: 'https://example.com/avatar.jpg',
          dateTime: DateTime(2025, 11, 10),
          location: 'Location',
          distanceKm: 1.0,
          attendeeCount: 10,
          tags: [],
          mediaUrl: 'https://example.com/image.jpg',
        );

        expect(noTagsEvent.tags, isEmpty);
      });

      test('should handle zero attendees', () {
        final noAttendeesEvent = EventModel(
          id: 'no-attendees',
          title: 'No Attendees Event',
          description: 'Description',
          organizerUsername: 'Organizer',
          organizerAvatar: 'https://example.com/avatar.jpg',
          dateTime: DateTime(2025, 11, 10),
          location: 'Location',
          distanceKm: 1.0,
          attendeeCount: 0,
          tags: ['Test'],
          mediaUrl: 'https://example.com/image.jpg',
        );

        expect(noAttendeesEvent.attendeeCount, 0);
      });

      test('should handle very high social counts', () {
        final popularEvent = EventModel(
          id: 'popular',
          title: 'Popular Event',
          description: 'Description',
          organizerUsername: 'Organizer',
          organizerAvatar: 'https://example.com/avatar.jpg',
          dateTime: DateTime(2025, 11, 10),
          location: 'Location',
          distanceKm: 1.0,
          attendeeCount: 1000,
          tags: ['Test'],
          mediaUrl: 'https://example.com/image.jpg',
          likesCount: 9999,
          sharesCount: 5555,
          commentsCount: 3333,
        );

        expect(popularEvent.likesCount, 9999);
        expect(popularEvent.sharesCount, 5555);
        expect(popularEvent.commentsCount, 3333);
      });
    });
  });
}
