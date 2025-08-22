import '../models/permission_manager/vaah_permission_status.dart';
import 'integrations/vaah_permission_provider.dart';
import 'integrations/vaah_permissionhandler.dart';

class VaahPermissionManager {
  factory VaahPermissionManager() => _instance;
  static const VaahPermissionManager _instance = VaahPermissionManager._internal();

  const VaahPermissionManager._internal({
    VaahPermissionProvider provider = const VaahPermissionHandler(),
  }) : _provider = provider;

  final VaahPermissionProvider _provider;

  Future<VaahNotificationPermissionStatus> checkNotificationPermission() async {
    return _provider.checkNotificationPermission();
  }

  Future<VaahNotificationPermissionStatus> requestNotificationPermission() async {
    return _provider.requestNotificationPermission();
  }

  Future<void> openSettings() async {
    return _provider.openSettings();
  }
}
