import 'package:flutter/material.dart';
import 'package:team/vaahextendflutter/base/base_stateless.dart';

class PermissionDeniedPage extends BaseStateless {
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
    super.build(context);
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Permission Denied'),
      ),
    );
  }
}
