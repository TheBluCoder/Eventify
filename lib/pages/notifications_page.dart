import 'dart:ui';
import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            // TODO: Navigate to user profile
          },
          child: CircleAvatar(
            foregroundImage: NetworkImage(
              "https://cdn.dribbble.com/userupload/16394495/file/original-44f9e9320643c7c6d3f4203f161a987e.webp?resize=1024x1024&vertical=center",
            ),
            radius: 18,
          ),
        ),
      ),
      centerTitle: true,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Notifications",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontFamily: "Roboto",
                ),
          ),
          Text(
            "Stay updated with your events",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
          ),
        ],
      ),
      backgroundColor: Colors.white.withValues(alpha: 0.85),
      surfaceTintColor: null,
      elevation: 4,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.7),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {
            // TODO: Navigate to notification settings
          },
          tooltip: 'Notification Settings',
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: _buildNotificationsList(context),
        ),
      ),
    );
  }

  Widget _buildNotificationsList(BuildContext context) {
    final notifications = _getPlaceholderNotifications();

    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications yet',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'ll see updates about your events here',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      // padding: const EdgeInsets.only(top: kToolbarHeight+8),
      itemCount: notifications.length,
      separatorBuilder: (context, index) => Divider(
        height: 0.5,
        thickness: 0.5,
        color: Colors.grey.shade300,
        indent: 60,
      ),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationTile(context, notification);
      },
    );
  }

  Widget _buildNotificationTile(BuildContext context, NotificationItem notification) {
    return InkWell(
      onTap: () {
        // TODO: Handle notification tap
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile picture with icon overlay
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: notification.userAvatarUrl != null
                      ? NetworkImage(notification.userAvatarUrl!)
                      : null,
                  child: notification.userAvatarUrl == null
                      ? Text(
                          notification.userName.isNotEmpty
                              ? notification.userName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : null,
                ),
                if (notification.type == NotificationType.like ||
                    notification.type == NotificationType.comment)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: _getNotificationColor(notification.type),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(
                        _getNotificationIcon(notification.type),
                        size: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Notification text and preview
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                      children: [
                        TextSpan(
                          text: notification.userName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: ' ${_getActionText(notification)}',
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        ),
                        if (notification.otherUsersCount != null &&
                            notification.otherUsersCount! > 0)
                          TextSpan(
                            text: ' and ${notification.otherUsersCount} others',
                            style: const TextStyle(fontWeight: FontWeight.normal),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatTime(notification.timestamp),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            // Preview thumbnail
            if (notification.previewImageUrl != null)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    notification.previewImageUrl!,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 44,
                        height: 44,
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.image_outlined,
                          size: 20,
                          color: Colors.grey.shade400,
                        ),
                      );
                    },
                  ),
                ),
              )
            else if (notification.type == NotificationType.eventReminder ||
                notification.type == NotificationType.eventUpdate)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.event_outlined,
                    size: 20,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            // Unread indicator
            if (!notification.isRead)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getActionText(NotificationItem notification) {
    switch (notification.type) {
      case NotificationType.like:
        return 'liked your event';
      case NotificationType.comment:
        return 'commented on your event';
      case NotificationType.newFollower:
        return 'started following you';
      case NotificationType.eventReminder:
        return notification.message;
      case NotificationType.eventUpdate:
        return notification.message;
      default:
        return notification.message;
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.eventReminder:
        return Icons.event_outlined;
      case NotificationType.newFollower:
        return Icons.person_add_outlined;
      case NotificationType.eventUpdate:
        return Icons.update_outlined;
      case NotificationType.comment:
        return Icons.comment_outlined;
      case NotificationType.like:
        return Icons.favorite_outline;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.eventReminder:
        return Colors.orange;
      case NotificationType.newFollower:
        return Colors.blue;
      case NotificationType.eventUpdate:
        return Colors.purple;
      case NotificationType.comment:
        return Colors.green;
      case NotificationType.like:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  List<NotificationItem> _getPlaceholderNotifications() {
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
        userAvatarUrl: 'https://cdn.dribbble.com/userupload/16394495/file/original-44f9e9320643c7c6d3f4203f161a987e.webp?resize=1024x1024&vertical=center',
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
        userAvatarUrl: 'https://cdn.dribbble.com/userupload/16394495/file/original-44f9e9320643c7c6d3f4203f161a987e.webp?resize=1024x1024&vertical=center',
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
        userAvatarUrl: 'https://cdn.dribbble.com/userupload/16394495/file/original-44f9e9320643c7c6d3f4203f161a987e.webp?resize=1024x1024&vertical=center',
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
        userAvatarUrl: 'https://cdn.dribbble.com/userupload/16394495/file/original-44f9e9320643c7c6d3f4203f161a987e.webp?resize=1024x1024&vertical=center',
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
        userAvatarUrl: 'https://cdn.dribbble.com/userupload/16394495/file/original-44f9e9320643c7c6d3f4203f161a987e.webp?resize=1024x1024&vertical=center',
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
        userAvatarUrl: 'https://cdn.dribbble.com/userupload/16394495/file/original-44f9e9320643c7c6d3f4203f161a987e.webp?resize=1024x1024&vertical=center',
        previewImageUrl: 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400',
      ),
    ];
  }
}

// Placeholder classes for notifications
// TODO: Replace with actual data models
enum NotificationType {
  eventReminder,
  newFollower,
  eventUpdate,
  comment,
  like,
  other,
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String userName;
  final String? userAvatarUrl;
  final String? previewImageUrl;
  final int? otherUsersCount;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    required this.userName,
    this.userAvatarUrl,
    this.previewImageUrl,
    this.otherUsersCount,
  });
}

