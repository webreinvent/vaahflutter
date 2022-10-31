
import 'package:flutter/material.dart';

import '../../vaahextendflutter/base/base_stateless.dart';

class PermissionDenied extends BaseStateless {
  static const String routeName = '/permission-denied';
  
  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/permission-denied'),
      builder: (_) => const PermissionDenied(),
    );
  }

  const PermissionDenied({super.key});

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
