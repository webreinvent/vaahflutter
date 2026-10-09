import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

enum PushNotificationsServiceType { local, remote, both, none }

enum InternalNotificationsServiceType { pusher, firebase, custom, none }

extension PushNotificationsServiceTypeExtension on PushNotificationsServiceType {
  bool get isNone {
    return this == PushNotificationsServiceType.none;
  }
}

extension InternalNotificationsServiceTypeExtension on InternalNotificationsServiceType {
  bool get isNone {
    return this == InternalNotificationsServiceType.none;
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class OneSignalConfig {
  final String appId;

  const OneSignalConfig({
    required this.appId,
  });

  factory OneSignalConfig.fromJson(Map<String, dynamic> json) => _$OneSignalConfigFromJson(json);

  Map<String, dynamic> toJson() => _$OneSignalConfigToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PusherConfig {
  final String apiKey;
  final String cluster;

  const PusherConfig({
    required this.apiKey,
    required this.cluster,
  });

  factory PusherConfig.fromJson(Map<String, dynamic> json) => _$PusherConfigFromJson(json);

  Map<String, dynamic> toJson() => _$PusherConfigToJson(this);
}
