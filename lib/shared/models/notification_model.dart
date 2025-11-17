/// Notification type enum
enum NotificationType {
  eventReminder,
  newFollower,
  eventUpdate,
  comment,
  like,
  other,
}

/// Model for a notification item
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

  /// Create a copy of this notification with updated fields
  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    String? userName,
    String? userAvatarUrl,
    String? previewImageUrl,
    int? otherUsersCount,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      userName: userName ?? this.userName,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      previewImageUrl: previewImageUrl ?? this.previewImageUrl,
      otherUsersCount: otherUsersCount ?? this.otherUsersCount,
    );
  }
}
