import '../../models/permission_manager/vaah_permission_status.dart';

abstract class VaahPermissionProvider {
  Future<VaahNotificationPermissionStatus> checkNotificationPermission();

  Future<VaahNotificationPermissionStatus> requestNotificationPermission();

  Future<void> openSettings();
}
