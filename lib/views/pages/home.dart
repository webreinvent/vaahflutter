import 'package:flutter/material.dart';

import './ui/index.dart';
import '../../vaahextendflutter/base/base_stateful.dart';
import '../../vaahextendflutter/env.dart';

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

class _HomePageState extends BaseStateful<HomePage> {
  @override
  void initState() {
    super.initState();
    EnvironmentConfig.getEnvConfig().increaseOpenCount();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(),
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
