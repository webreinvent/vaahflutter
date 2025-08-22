import 'package:permission_handler/permission_handler.dart';

import '../../models/permission_manager/vaah_permission_status.dart';
import 'extensions.dart';
import 'vaah_permission_provider.dart';

class VaahPermissionHandler implements VaahPermissionProvider {
  const VaahPermissionHandler();

  @override
  Future<VaahNotificationPermissionStatus> checkNotificationPermission() async {
    final status = await Permission.notification.status;
    return status.asNotificationPermissionStatus;
  }

  @override
  Future<VaahNotificationPermissionStatus> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.asNotificationPermissionStatus;
  }

  @override
  Future<void> openSettings() {
    return openAppSettings();
  }
}
