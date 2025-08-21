import 'dart:async';

import '../../models/logs/log_record.dart';
import '../../models/user/vaah_user.dart';

abstract class VaahRemoteLogProvider {
  const VaahRemoteLogProvider();

  FutureOr<void> wrapAppRunner({required FutureOr<void> Function() appRunner});

  Future<void> bindUser(VaahUser user);

  Future<void> unbindUser();

  Future<void> log(LogRecord record);

  Future<void> dispose();
}
