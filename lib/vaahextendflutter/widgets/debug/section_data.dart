import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'section_data.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SectionData {
  final String? value;
  final String? tooltip;
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  final Color? color;

  static Color? _colorFromJson(int? color) {
    return color == null ? null : Color(color);
  }

  static int _colorToJson(Color? color) {
    return color!.value;
  }

  const SectionData({
    this.value,
    this.tooltip,
    this.color,
  });

  factory SectionData.fromJson(Map<String, dynamic> json) => _$SectionDataFromJson(json);

  Map<String, dynamic> toJson() => _$SectionDataToJson(this);
}
