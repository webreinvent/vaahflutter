import 'dart:async';

import '../env/env.dart';
import '../models/logs/logs.dart';
import '../models/user/vaah_user.dart';
import 'transports/console_transport.dart';
import 'transports/file_transport.dart';
import 'transports/remote_transport.dart';

class VaahLogger {
  factory VaahLogger() => _instance;
  static final VaahLogger _instance = VaahLogger._internal();
  VaahLogger._internal() {
    _initialize();
  }

  bool _initialized = false;

  void _initialize() {
    if (_initialized) return;
    final loggerConfig = _config.loggerConfig;
    if (loggerConfig.transports.contains(LogTransport.console)) {
      _consoleTransport = const ConsoleTransport();
    }
    if (loggerConfig.transports.contains(LogTransport.file)) {
      _fileTransport = FileTransport();
    }
    if (loggerConfig.transports.contains(LogTransport.remote) &&
        loggerConfig.remoteProviderConfig != null) {
      _remoteTransport = RemoteTransport(_config.env, loggerConfig);
    }
    _controller.stream.listen((record) async {
      final futures = <Future<void>>[
        _consoleTransport?.log(record) ?? Future.value(),
        _fileTransport?.log(record) ?? Future.value(),
        _remoteTransport?.log(record) ?? Future.value(),
      ];
      try {
        await Future.wait(futures);
      } catch (_) {}
    });
    _initialized = true;
  }

  VaahEnvData get _config => VaahEnv.instance.data;

  final _controller = StreamController<LogRecord>.broadcast();

  ConsoleTransport? _consoleTransport;
  FileTransport? _fileTransport;
  RemoteTransport? _remoteTransport;

  FutureOr<void> wrapAppRunner({required FutureOr<void> Function() appRunner}) {
    return _remoteTransport?.wrapAppRunner(appRunner: appRunner) ?? appRunner();
  }

  Future<void> bindUser(VaahUser user) async {
    final futures = <Future<void>>[
      _consoleTransport?.bindUser(user) ?? Future.value(),
      _fileTransport?.bindUser(user) ?? Future.value(),
      _remoteTransport?.bindUser(user) ?? Future.value(),
    ];
    try {
      await Future.wait(futures);
    } catch (_) {}
  }

  Future<void> unbindUser() async {
    final futures = <Future<void>>[
      _consoleTransport?.unbindUser() ?? Future.value(),
      _fileTransport?.unbindUser() ?? Future.value(),
      _remoteTransport?.unbindUser() ?? Future.value(),
    ];
    try {
      await Future.wait(futures);
    } catch (_) {}
  }

  bool _shouldLog(LogLevel level) => level.priority >= _config.loggerConfig.level.priority;

  void _emit(LogRecord record) {
    try {
      if (!_shouldLog(record.level)) {
        return;
      }
      _controller.add(record);
    } catch (_) {
      // swallow
    }
  }

  void info(String message, [Map<String, dynamic>? context]) {
    _emit(
      LogRecord(
        timestamp: DateTime.now().toUtc(),
        level: LogLevel.info,
        message: message,
        context: context,
      ),
    );
  }

  void warn(String message, [Map<String, dynamic>? context]) {
    _emit(
      LogRecord(
        timestamp: DateTime.now().toUtc(),
        level: LogLevel.warn,
        message: message,
        context: context,
      ),
    );
  }

  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    _emit(
      LogRecord(
        timestamp: DateTime.now().toUtc(),
        level: LogLevel.error,
        message: message,
        context: context,
        error: error,
        stackTrace: stackTrace,
      ),
    );
  }

  void fatal(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    _emit(
      LogRecord(
        timestamp: DateTime.now().toUtc(),
        level: LogLevel.fatal,
        message: message,
        context: context,
        error: error,
        stackTrace: stackTrace,
      ),
    );
  }

  Future<void> dispose() async {
    await _controller.close();
    await _consoleTransport?.dispose();
    await _fileTransport?.dispose();
    await _remoteTransport?.dispose();
  }
}
