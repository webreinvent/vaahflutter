// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoggerConfig _$LoggerConfigFromJson(Map<String, dynamic> json) => LoggerConfig(
  level: $enumDecodeNullable(_$LogLevelEnumMap, json['level']) ?? LogLevel.info,
  transports:
      (json['transports'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$LogTransportEnumMap, e))
          .toList() ??
      const [],
  remoteProviderConfig: LoggerConfig._remoteProviderConfigFromJson(
    json['remote_provider_config'],
  ),
);

const _$LogLevelEnumMap = {
  LogLevel.debug: 'debug',
  LogLevel.info: 'info',
  LogLevel.warn: 'warn',
  LogLevel.error: 'error',
  LogLevel.fatal: 'fatal',
};

const _$LogTransportEnumMap = {
  LogTransport.console: 'console',
  LogTransport.file: 'file',
  LogTransport.remote: 'remote',
};
