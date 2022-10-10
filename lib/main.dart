import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'env.dart';
import 'vaahextendflutter/environment/env_helpers.dart';

void main() {
  String environment = getEnvFromCommandLine();
  final EnvController envController = Get.put(
    EnvController(
      environment,
    ),
  );
  if (envController.config.envType != 'prod') {
    print('>>>>> ${envController.config.envType}');
    print(
      '>>>>> ${envController.config.version}+${envController.config.build}',
    );
  }
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

class _TeamHomePageState extends State<TeamHomePage> {
  late EnvController envCtrl;

  @override
  void initState() {
    envCtrl = Get.find<EnvController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
            '${envCtrl.config.envType} ${envCtrl.config.version}+${envCtrl.config.build}'),
      ),
    );
  }
}
