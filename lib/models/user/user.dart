import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:team/models/user/permission/permission.dart';

part 'user.g.dart';

@immutable
@JsonSerializable()
class User {
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String? lastName;
  @JsonKey(name: 'permissions')
  final Permission permissions;

  const User({
    required this.firstName,
    this.lastName,
    required this.permissions,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
