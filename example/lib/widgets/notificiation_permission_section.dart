import 'package:flutter/material.dart';
import 'package:vaahflutter/vaahflutter.dart';

class NotificationPermissionSection extends StatefulWidget {
  const NotificationPermissionSection({super.key});

  @override
  State<NotificationPermissionSection> createState() => _NotificationPermissionSectionState();
}

class _NotificationPermissionSectionState extends State<NotificationPermissionSection> {
  bool _isLoading = false;

  void _showDialog({
    String? title,
    String? message,
    String confirmText = 'Okay',
    VoidCallback? onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: title == null ? null : Text(title),
        content: message == null ? null : Text(message),
        actions: [
          TextButton(onPressed: onConfirm, child: Text(confirmText)),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ],
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _requestNotificationPermission() async {
    final permissionManager = VaahPermissionManager();
    try {
      setState(() {
        _isLoading = true;
      });
      final status = await permissionManager.checkNotificationPermission();
      if (status == VaahNotificationPermissionStatus.granted) {
        _showSnackbar('Notification permission already granted');
      } else if (status == VaahNotificationPermissionStatus.denied) {
        await permissionManager.requestNotificationPermission();
      } else if (status == VaahNotificationPermissionStatus.permanentlyDenied) {
        _showDialog(
          title: 'Permission Denied',
          message: 'Please enable it from app settings.',
          onConfirm: () {
            permissionManager.openSettings();
            Navigator.pop(context);
          },
        );
      }
    } catch (e) {
      _showSnackbar('Failed to request notification permission');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _requestNotificationPermission,
            child: Text(_isLoading ? '...' : 'Request Notification Permission'),
          ),
        ),
      ],
    );
  }
}
