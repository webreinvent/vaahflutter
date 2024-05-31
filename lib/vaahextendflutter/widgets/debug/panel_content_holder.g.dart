// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panel_content_holder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PanelDataContentHolder _$PanelDataContentHolderFromJson(
        Map<String, dynamic> json) =>
    PanelDataContentHolder(
      content: (json['content'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, SectionData.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$PanelDataContentHolderToJson(
        PanelDataContentHolder instance) =>
    <String, dynamic>{
      'content': instance.content,
    };
