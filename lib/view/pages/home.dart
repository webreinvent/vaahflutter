import 'package:flutter/material.dart';

import '../../vaahextendflutter/base/base_stateful.dart';
import '../../vaahextendflutter/helpers/console.dart';
import '../../vaahextendflutter/services/api.dart';

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
      body: Center(
        child: ElevatedButton(
          onPressed: () async =>
              await Api.ajax(url: '/api/data', callback: callback),
          child: const Text('Parse Response'),
        ),
      ),
    );
  }
}

Future<void> callback(dynamic data, dynamic res) async {
  Console.info(data.toString());
}

