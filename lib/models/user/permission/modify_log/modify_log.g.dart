// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modify_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModifyLog _$ModifyLogFromJson(Map<String, dynamic> json) => ModifyLog(
      modifiedBy: json['modified_by'] as String,
      post: json['post'] as String,
      dateAndTime: DateTime.parse(json['date_and_time'] as String),
    );

Map<String, dynamic> _$ModifyLogToJson(ModifyLog instance) => <String, dynamic>{
      'modified_by': instance.modifiedBy,
      'post': instance.post,
      'date_and_time': instance.dateAndTime.toIso8601String(),
    };
