// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_debug_section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomDebugSection _$CustomDebugSectionFromJson(Map<String, dynamic> json) =>
    CustomDebugSection(
      contentHolder: PanelDataContentHolder.fromJson(
          json['content_holder'] as Map<String, dynamic>),
      sectionName: json['section_name'] as String,
    );

Map<String, dynamic> _$CustomDebugSectionToJson(CustomDebugSection instance) =>
    <String, dynamic>{
      'section_name': instance.sectionName,
      'content_holder': instance.contentHolder,
    };
