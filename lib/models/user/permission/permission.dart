import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:team/models/user/permission/modify_log/modify_log.dart';
import 'package:team/models/user/permission/route/route.dart';

part 'permission.g.dart';

@immutable
@JsonSerializable()
class Permission {
  @JsonKey(name: 'modify_log')
  final List<ModifyLog> modifyLog;
  @JsonKey(name: 'permissions')
  final List<RouteModel> routes;

  const Permission({
    required this.modifyLog,
    required this.routes,
  });

  factory Permission.fromJson(Map<String, dynamic> json) => _$PermissionFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionToJson(this);
}
