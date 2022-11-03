// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Permission _$PermissionFromJson(Map<String, dynamic> json) => Permission(
      modifyLog: (json['modify_log'] as List<dynamic>)
          .map((e) => ModifyLog.fromJson(e as Map<String, dynamic>))
          .toList(),
      routes: (json['permissions'] as List<dynamic>)
          .map((e) => RouteModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PermissionToJson(Permission instance) =>
    <String, dynamic>{
      'modify_log': instance.modifyLog,
      'permissions': instance.routes,
    };
