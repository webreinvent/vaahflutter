import 'package:permission_handler/permission_handler.dart';

import '../../models/permission_manager/vaah_permission_status.dart';

extension PermissionStatusExtensions on PermissionStatus {
  VaahNotificationPermissionStatus get asNotificationPermissionStatus {
    switch (this) {
      case PermissionStatus.denied:
        return VaahNotificationPermissionStatus.denied;
      case PermissionStatus.granted:
        return VaahNotificationPermissionStatus.granted;
      case PermissionStatus.permanentlyDenied:
        return VaahNotificationPermissionStatus.permanentlyDenied;
      default:
        return VaahNotificationPermissionStatus.unknown;
    }
  }
}
