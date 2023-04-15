class NotificationButton {
  final String id;
  final String text;
  final String? icon;

  NotificationButton({required this.id, required this.text, this.icon});
}

enum NotificationType {
  local,
  remote,
}
