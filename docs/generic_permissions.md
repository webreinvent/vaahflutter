# Generic Permission Manager Suggestions
### Intent/Thought Process:
- Currently, our abstraction is **tied only to notification permissions** (`checkNotificationPermission`, `requestNotificationPermission`, etc.). If we want this to be **generic for any type of permission** (camera, location, storage, notification, etc.), we can redesign to be able to handle any kind of permission.
- To achieve this,  the we need to pass the notification type explicitly onto the abstract functions.
***

### File Changes 

1. In `vaah_permission_provider.dart` we need to modify functions by adding Permission type explicitly. Just Like:
 
 ```
 abstract class VaahPermissionProvider {
  Future<VaahPermissionStatus> checkPermission(VaahPermissionType type);
  Future<VaahPermissionStatus> requestPermission(VaahPermissionType type);
  Future<void> openSettings();
}
```
2. Have to create another enum for permission type so that our generic function can handle any kind of permission request.
```
enum VaahPermissionType {
  notification,
  camera,
  location,
  microphone,
  storage,
  contacts,
}
```
3. The implementation class `vaah_permission_handler.dart` can have these changes, so that it is not restricted to notifications. Like: 
```
class VaahPermissionHandler implements VaahPermissionProvider {
  const VaahPermissionHandler();

  Permission _mapToPermission(VaahPermissionType type) {
    switch (type) {
      case VaahPermissionType.notification:
        return Permission.notification;
      case VaahPermissionType.camera:
        return Permission.camera;
      case VaahPermissionType.location:
        return Permission.location;
      case VaahPermissionType.microphone:
        return Permission.microphone;
      case VaahPermissionType.storage:
        return Permission.storage;
      case VaahPermissionType.contacts:
        return Permission.contacts;
    }
  }

  VaahPermissionStatus _mapStatus(PermissionStatus status) {
    if (status.isGranted) return VaahPermissionStatus.granted;
    if (status.isDenied) return VaahPermissionStatus.denied;
    if (status.isRestricted) return VaahPermissionStatus.restricted;
    if (status.isPermanentlyDenied) return VaahPermissionStatus.permanentlyDenied;
    if (status.isLimited) return VaahPermissionStatus.limited;
    return VaahPermissionStatus.denied;
  }

  @override
  Future<VaahPermissionStatus> checkPermission(VaahPermissionType type) async {
    final status = await _mapToPermission(type).status;
    return _mapStatus(status);
  }

  @override
  Future<VaahPermissionStatus> requestPermission(VaahPermissionType type) async {
    final status = await _mapToPermission(type).request();
    return _mapStatus(status);
  }

  @override
  Future<void> openSettings() => openAppSettings();
}
```
4. Now, the permission manager can be implemented as follows:
```
class VaahPermissionManager {
  // Singleton instance
  factory VaahPermissionManager() => _instance;
  static final VaahPermissionManager _instance = VaahPermissionManager._internal();

  VaahPermissionManager._internal({
    VaahPermissionProvider provider = const VaahPermissionHandler(),
  }) : _provider = provider;

  final VaahPermissionProvider _provider;

  /// Check permission for a given type
  Future<VaahPermissionStatus> checkPermission(VaahPermissionType type) {
    return _provider.checkPermission(type);
  }

  /// Request permission for a given type
  Future<VaahPermissionStatus> requestPermission(VaahPermissionType type) {
    return _provider.requestPermission(type);
  }

  /// Open system settings
  Future<void> openSettings() {
    return _provider.openSettings();
  }
  }
  ```
  OR
  we can now define separate classes for handling different kinds of permissions.
***
### Conclusion

-   We club VaahPermissionManager with the generic provider.
-   We can keep a singleton facade (VaahPermissionManager) so the rest of
    our app based on this package doesn't need to know about VaahPermissionProvider directly.
-   We can extend permissions easily (by adding enums in VaahPermissionType).