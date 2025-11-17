import 'dart:ui';
import 'package:flutter/material.dart';
import '../shared/models/notification_model.dart';
import '../shared/data/placeholder.dart';
import '../shared/utils/date_time_formatter.dart';

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
              PlaceholderData.currentUserAvatar,
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
    final notifications = PlaceholderData.placeholderNotifications;

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
    return DateTimeFormatter.formatRelativeTime(timestamp);
  }

}

