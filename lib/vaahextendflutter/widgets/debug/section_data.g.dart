// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SectionData _$SectionDataFromJson(Map<String, dynamic> json) => SectionData(
      value: json['value'] as String?,
      tooltip: json['tooltip'] as String?,
      color: SectionData._colorFromJson(json['color'] as int?),
    );

Map<String, dynamic> _$SectionDataToJson(SectionData instance) =>
    <String, dynamic>{
      'value': instance.value,
      'tooltip': instance.tooltip,
      'color': SectionData._colorToJson(instance.color),
    };
