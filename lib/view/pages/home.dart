import 'package:flutter/material.dart';
import 'package:team/vaahextendflutter/base/base_stateful.dart';

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
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: Text('WebReinvent')),
    );
  }
}
