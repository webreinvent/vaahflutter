import 'package:flutter/material.dart';
import 'package:vaahflutter/vaahflutter.dart';
import 'package:vaahflutterexample/models/user.dart';

class PushNotificationSection extends StatelessWidget {
  const PushNotificationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final pushNotifications = VaahPushNotifications();
    final user = User(id: 'abc123', name: 'John Doe');
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  pushNotifications.grantConsent();
                },
                child: const Text('Grant Push Consent'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  pushNotifications.revokeConsent();
                },
                child: const Text('Revoke Push Consent'),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  pushNotifications.bindUser(user);
                },
                child: const Text('Bind Push User'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  pushNotifications.unbindUser();
                },
                child: const Text('Unbind Push User'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
