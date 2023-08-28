import 'package:flutter/material.dart';

class PermissionDeniedPage extends StatelessWidget {
  static const String routePath = '/permission-denied';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routePath),
      builder: (_) => const PermissionDeniedPage(),
    );
  }

  const PermissionDeniedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Permission Denied'),
      ),
    );
  }
}
