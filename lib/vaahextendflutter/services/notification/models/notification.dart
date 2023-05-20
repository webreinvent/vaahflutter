import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class PushNotification {
  final int id;
  final NotificationType type;
  @JsonKey(name: 'player_ids')
  final List<String> playerIds;
  final String? heading;
  final String content;
  @JsonKey(name: 'payload_path')
  final String? payloadPath;
  @JsonKey(name: 'payload_data')
  final dynamic payloadData;
  @JsonKey(name: 'payload_auth')
  final dynamic payloadAuth;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(name: 'send_after')
  final DateTime? sendAfter;
  final List<NotificationButton>? buttons;

  const PushNotification({
    required this.id,
    required this.type,
    required this.playerIds,
    this.heading,
    required this.content,
    this.payloadPath,
    this.payloadData,
    this.payloadAuth,
    this.imageUrl,
    this.sendAfter,
    this.buttons,
  });

  factory PushNotification.fromJson(Map<String, dynamic> json) => _$PushNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$PushNotificationToJson(this);
}

@JsonSerializable()
class InternalNotification {
  final String id;
  final String? heading;
  final String content;
  final dynamic payload;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(name: 'send_after')
  final DateTime? sendAfter;
  final bool opened;
  final List<NotificationButton>? buttons;

  const InternalNotification({
    required this.id,
    this.heading,
    required this.content,
    this.payload,
    this.imageUrl,
    this.sendAfter,
    this.opened = false,
    this.buttons,
  });

  factory InternalNotification.fromJson(Map<String, dynamic> json) =>
      _$InternalNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$InternalNotificationToJson(this);
}

@JsonSerializable()
class NotificationButton {
  final String id;
  final String text;
  final String? icon;

  NotificationButton({
    required this.id,
    required this.text,
    this.icon,
  });

  factory NotificationButton.fromJson(Map<String, dynamic> json) =>
      _$NotificationButtonFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationButtonToJson(this);
}

enum NotificationType {
  local,
  remote,
}
