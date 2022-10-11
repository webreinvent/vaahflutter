import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'env.dart';
import 'vaahextendflutter/log/console.dart';
import 'vaahextendflutter/base/base_stateful.dart';
import 'vaahextendflutter/tag/tag.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  String environment =
      const String.fromEnvironment('environment', defaultValue: 'default');
  final EnvController envController = Get.put(
    EnvController(
      environment,
    ),
  );
  Console.info('>>>>> ${envController.config.envType}');
  Console.info(
    '>>>>> ${envController.config.version}+${envController.config.build}',
  );
  runApp(const TeamApp());
}

class TeamApp extends StatelessWidget {
  const TeamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebReinvent Team',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TeamHomePage(),
    );
  }
}

class TeamHomePage extends StatefulWidget {
  const TeamHomePage({super.key});

  @override
  State<TeamHomePage> createState() => _TeamHomePageState();
}

class _TeamHomePageState extends BaseStateful<TeamHomePage> {
  late EnvController envController;

  @override
  void initState() {
    envController = Get.find<EnvController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(),
      body: const TagWrapper(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.all(10),
        child: Center(
          child: Text('Webreinvent'),
        ),
      ),
    );
  }
}
