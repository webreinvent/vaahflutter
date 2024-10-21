// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupabaseConfig _$SupabaseConfigFromJson(Map<String, dynamic> json) =>
    SupabaseConfig(
      url: json['url'] as String,
      anonKey: json['anon_key'] as String,
    );

Map<String, dynamic> _$SupabaseConfigToJson(SupabaseConfig instance) =>
    <String, dynamic>{
      'url': instance.url,
      'anon_key': instance.anonKey,
    };
