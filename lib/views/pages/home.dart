import 'package:flutter/material.dart';

import '../../vaahextendflutter/services/notification/internal/notification_view.dart';
import 'ui/index.dart';

class HomePage extends StatefulWidget {
  static const String routePath = '/home';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routePath),
      builder: (_) => const HomePage(),
    );
  }

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // TODO:
    // increaseOpenCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          InternalNotificationsBadge(),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, UIPage.route());
          },
          child: const Text('WebReinvent'),
        ),
      ),
    );
  }
}
