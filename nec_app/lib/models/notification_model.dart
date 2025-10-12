class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });

  // Demo notifications data
  static List<NotificationModel> getNotifications() {
    return List.generate(8, (index) {
      return NotificationModel(
        id: 'notification_${index + 1}',
        title: 'Notification #${index + 1}',
        message: 'This is a demo notification message showing how it will appear.',
        timestamp: DateTime.now().subtract(Duration(minutes: index * 5)),
        isRead: false,
      );
    });
  }

  // Get count of unread notifications
  static int getUnreadCount() {
    return getNotifications().where((notification) => !notification.isRead).length;
  }

  // Get total count of notifications
  static int getTotalCount() {
    return getNotifications().length;
  }
}
