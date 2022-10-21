
import 'package:flutter/material.dart';

import '../../../vaahextendflutter/base/base_stateful.dart';

class TeamHomePage extends StatefulWidget {
  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/'),
      builder: (_) => const TeamHomePage(),
    );
  }

  const TeamHomePage({super.key});

  @override
  State<TeamHomePage> createState() => _TeamHomePageState();
}

class _TeamHomePageState extends BaseStateful<TeamHomePage> {

  @override
  void afterFirstBuild(BuildContext context) {
    super.afterFirstBuild(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Team App Home Page'),
      ),
    );
  }
}
