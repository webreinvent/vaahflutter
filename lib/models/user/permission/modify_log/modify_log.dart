import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'modify_log.g.dart';

@immutable
@JsonSerializable()
class ModifyLog {
  @JsonKey(name: 'modified_by')
  final String modifiedBy;
  @JsonKey(name: 'post')
  final String post;
  @JsonKey(name: 'date_and_time')
  final DateTime dateAndTime;

  const ModifyLog({
    required this.modifiedBy,
    required this.post,
    required this.dateAndTime,
  });

  factory ModifyLog.fromJson(Map<String, dynamic> json) => _$ModifyLogFromJson(json);

  Map<String, dynamic> toJson() => _$ModifyLogToJson(this);
}
