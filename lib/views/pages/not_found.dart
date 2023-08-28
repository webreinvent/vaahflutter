import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  static const String routePath = '/page-not-found';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routePath),
      builder: (_) => const NotFoundPage(),
    );
  }

  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Page Not Found!'),
      ),
    );
  }
}
