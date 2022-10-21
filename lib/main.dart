import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/base_controller.dart';
import 'env.dart';
import 'vaahextendflutter/base/base_stateful.dart';
import 'vaahextendflutter/services/rest_api/demo/demo_ui.dart';
import 'vaahextendflutter/tag/tag.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BaseController baseController = Get.put(BaseController());
  await baseController.init();
  runApp(const TeamApp());
}

class TeamApp extends StatelessWidget {
  const TeamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'WebReinvent Team',
      theme: ThemeData(
        primarySwatch: kPrimaryColor,
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
  void afterFirstBuild(BuildContext context) {
    envController = Get.find<EnvController>();
    super.afterFirstBuild(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: kWarningColor,
      appBar: AppBar(),
      body: const TagWrapper(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.all(10),
        child: Center(
          child: DemoUI(),
        ),
      ),
    );
  }
}
