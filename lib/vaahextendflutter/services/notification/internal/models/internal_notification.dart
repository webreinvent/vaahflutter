class InternalNotification {
  final String id;
  final String? heading;
  final String content;
  final dynamic payload;
  // List<NotificationButton>? buttons;
  final String? imageURL;
  final DateTime? sendAfter;
  final bool opened;

  const InternalNotification({
    required this.id,
    this.heading,
    required this.content,
    this.payload,
    // required this.buttons,
    this.imageURL,
    this.sendAfter,
    this.opened = false,
  });

  factory InternalNotification.fromJson(Map<String, dynamic> json) => InternalNotification(
        id: json['id'] as String,
        heading: json['heading'] as String?,
        content: json['content'] as String,
        payload: json['payload'],
        imageURL: json['image_url'] as String?,
        sendAfter: json['send_after'] == null ? null : DateTime.parse(json['send_after'] as String),
        opened: json['opened'] == null ? false : json['opened'] as bool,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'heading': heading,
        'content': content,
        'payload': payload,
        'image_url': imageURL,
        'send_after': sendAfter?.toIso8601String(),
        'opened': opened,
      };
}
