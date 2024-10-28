// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushNotification _$PushNotificationFromJson(Map<String, dynamic> json) =>
    PushNotification(
      id: (json['id'] as num).toInt(),
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      externalIds: (json['external_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      heading: json['heading'] as String?,
      content: json['content'] as String,
      payloadPath: json['payload_path'] as String?,
      payloadData: json['payload_data'],
      payloadAuth: json['payload_auth'],
      imageUrl: json['image_url'] as String?,
      sendAfter: json['send_after'] == null
          ? null
          : DateTime.parse(json['send_after'] as String),
      buttons: (json['buttons'] as List<dynamic>?)
          ?.map((e) => NotificationButton.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PushNotificationToJson(PushNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'external_ids': instance.externalIds,
      'heading': instance.heading,
      'content': instance.content,
      'payload_path': instance.payloadPath,
      'payload_data': instance.payloadData,
      'payload_auth': instance.payloadAuth,
      'image_url': instance.imageUrl,
      'send_after': instance.sendAfter?.toIso8601String(),
      'buttons': instance.buttons,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.local: 'local',
  NotificationType.remote: 'remote',
};

InternalNotification _$InternalNotificationFromJson(
        Map<String, dynamic> json) =>
    InternalNotification(
      id: json['id'] as String,
      heading: json['heading'] as String?,
      content: json['content'] as String,
      payload: json['payload'],
      imageUrl: json['image_url'] as String?,
      sendAfter: json['send_after'] == null
          ? null
          : DateTime.parse(json['send_after'] as String),
      opened: json['opened'] as bool? ?? false,
      buttons: (json['buttons'] as List<dynamic>?)
          ?.map((e) => NotificationButton.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InternalNotificationToJson(
        InternalNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'heading': instance.heading,
      'content': instance.content,
      'payload': instance.payload,
      'image_url': instance.imageUrl,
      'send_after': instance.sendAfter?.toIso8601String(),
      'opened': instance.opened,
      'buttons': instance.buttons,
    };

NotificationButton _$NotificationButtonFromJson(Map<String, dynamic> json) =>
    NotificationButton(
      id: json['id'] as String,
      text: json['text'] as String,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$NotificationButtonToJson(NotificationButton instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'icon': instance.icon,
    };
