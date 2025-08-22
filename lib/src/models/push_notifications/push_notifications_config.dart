import 'package:json_annotation/json_annotation.dart';

part 'push_notifications_config.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class PushNotificationsConfig {
  const PushNotificationsConfig({this.providerConfig});

  factory PushNotificationsConfig.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationsConfigFromJson(json);

  @JsonKey(fromJson: _providerConfigFromJson)
  final PushProviderConfig? providerConfig;

  static PushProviderConfig? _providerConfigFromJson(dynamic json) {
    switch (json['name']) {
      case 'onesignal':
        return OneSignalPushProviderConfig.fromJson(json);
      default:
        return null;
    }
  }
}

abstract class PushProviderConfig {
  const PushProviderConfig({required this.name});

  final String name;
}

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class OneSignalPushProviderConfig extends PushProviderConfig {
  const OneSignalPushProviderConfig({required super.name, required this.appId});

  factory OneSignalPushProviderConfig.fromJson(Map<String, dynamic> json) =>
      _$OneSignalPushProviderConfigFromJson(json);

  final String appId;
}
