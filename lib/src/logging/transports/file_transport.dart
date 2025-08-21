import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../models/logs/logs.dart';
import '../../models/user/vaah_user.dart';

class FileTransport {
  FileTransport();

  IOSink? _sink;
  File? _currentFile;
  bool _initializing = false;
  bool _writing = false;

  final List<LogRecord> _queue = [];

  Future<void> _initIfNeeded() async {
    if (_sink != null || _initializing) return;
    _initializing = true;
    try {
      final dir = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
      final logsDir = Directory('${dir.path}/logs');
      if (!await logsDir.exists()) {
        await logsDir.create(recursive: true);
      }

      _currentFile = File('${logsDir.path}/vaahflutter.log');
      _sink = _currentFile!.openWrite(mode: FileMode.append);

      await _enforceRotation();
      await _enforceRetention(logsDir);
    } catch (_) {
      // swallow
    } finally {
      _initializing = false;
    }
  }

  Future<void> _enforceRotation() async {
    try {
      if (_currentFile == null) return;
      const maxBytes = 5 * 1024 * 1024;
      final size = await _currentFile!.length();
      if (size >= maxBytes) {
        await _sink?.flush();
        await _sink?.close();

        final ts = DateTime.now().toUtc().toIso8601String().replaceAll(':', '-');
        final rotated = File(_currentFile!.path.replaceAll('.log', '.$ts.log'));
        final parent = _currentFile!.parent;
        const baseName = 'vaahflutter.log';
        await _currentFile!.rename(rotated.path);

        _currentFile = File('${parent.path}/$baseName');
        _sink = _currentFile!.openWrite(mode: FileMode.append);
      }
    } catch (_) {
      // swallow
    }
  }

  Future<void> _enforceRetention(Directory logsDir) async {
    try {
      final files =
          logsDir.listSync().whereType<File>().where((f) => f.path.endsWith('.log')).toList()
            ..sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

      const keep = 7;
      for (var i = keep; i < files.length; i++) {
        try {
          await files[i].delete();
        } catch (_) {}
      }
    } catch (_) {
      // swallow
    }
  }

  Future<void> bindUser(VaahUser user) async {
    await log(
      LogRecord(
        timestamp: DateTime.now().toUtc(),
        level: LogLevel.info,
        message: 'User bound: ${user.id}',
        context: {'name': user.name, 'username': user.username, 'email': user.email},
      ),
    );
  }

  Future<void> unbindUser() async {
    await log(
      LogRecord(timestamp: DateTime.now().toUtc(), level: LogLevel.info, message: 'User unbound'),
    );
  }

  Future<void> log(LogRecord record) async {
    _queue.add(record);
    if (!_writing) {
      _processQueue();
    }
  }

  Future<void> _processQueue() async {
    if (_writing) return;
    _writing = true;

    while (_queue.isNotEmpty) {
      final record = _queue.removeAt(0);
      try {
        await _initIfNeeded();
        if (_sink == null) {
          _queue.insert(0, record);
          break;
        }

        final jsonLine = jsonEncode(record.toJson());
        _sink!.writeln(jsonLine);

        await _sink?.flush();
        await _enforceRotation();
      } catch (_) {
        // swallow
      }
    }

    _writing = false;
  }

  Future<void> dispose() async {
    try {
      _queue.clear();
      await _sink?.flush();
      await _sink?.close();
    } catch (_) {}
  }
}
