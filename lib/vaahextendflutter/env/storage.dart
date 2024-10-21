import 'package:json_annotation/json_annotation.dart';

part 'storage.g.dart';

enum NetworkStorageType { firebase, supabase, none }

@JsonSerializable(fieldRename: FieldRename.snake)
class SupabaseConfig {
  final String url;
  final String anonKey;

  SupabaseConfig({required this.url, required this.anonKey});

  SupabaseConfig copyWith({
    String? url,
    String? anonKey,
  }) {
    return SupabaseConfig(
      url: url ?? this.url,
      anonKey: anonKey ?? this.anonKey,
    );
  }

  factory SupabaseConfig.fromJson(Map<String, dynamic> json) => _$SupabaseConfigFromJson(json);

  Map<String, dynamic> toJson() => _$SupabaseConfigToJson(this);
}
