import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/base_controller.dart';
import 'env.dart';
import 'vaahextendflutter/base/base_stateful.dart';
import 'vaahextendflutter/tag/tag.dart';
import 'view/widgets/demo/demo_ui.dart';
import 'vaahextendflutter/base/base_stateful.dart';
import 'vaahextendflutter/helpers/constants.dart';
import 'vaahextendflutter/log/console.dart';
import 'vaahextendflutter/tag/tag_panel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BaseController baseController = Get.put(BaseController());
  await baseController.init();
  runApp(const TeamApp());
}

final _navigatorKey = GlobalKey<NavigatorState>();

class TeamApp extends StatelessWidget {
  const TeamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'WebReinvent Team',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateInitialRoutes: (String initialRoute) {
        return [TeamHomePage.route()];
      },
      onGenerateRoute: onGenerateRoute,
      builder: (BuildContext context, Widget? child) {
        return TagPanelHost(
          navigatorKey: _navigatorKey,
          child: child!,
        );
      },
    );
  }
}

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
      backgroundColor: dangerColor,
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

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  if (settings.name == '/') {
    return TeamHomePage.route();
  }
  return null;
}
