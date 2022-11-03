import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'route.g.dart';

@immutable
@JsonSerializable()
class RouteModel {
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'path')
  final String path;
  @JsonKey(name: 'description')
  final String? description;

  const RouteModel({
    this.name,
    required this.path,
    this.description,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) => _$RouteModelFromJson(json);

  Map<String, dynamic> toJson() => _$RouteModelToJson(this);
}
