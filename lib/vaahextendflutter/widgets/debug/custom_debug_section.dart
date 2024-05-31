import 'package:json_annotation/json_annotation.dart';

import 'panel_content_holder.dart';

part 'custom_debug_section.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CustomDebugSection {
  final String sectionName;

  ///Provide an instance of [PanelDataContentHolder].
  final PanelDataContentHolder contentHolder;

  CustomDebugSection({required this.contentHolder, required this.sectionName});

  factory CustomDebugSection.fromJson(Map<String, dynamic> json) =>
      _$CustomDebugSectionFromJson(json);

  Map<String, dynamic> toJson() => _$CustomDebugSectionToJson(this);
}
