import 'package:flutter/material.dart';
import 'package:get/get.dart';

<<<<<<< Updated upstream
import 'app/app.dart';
import 'controllers/base_controller.dart';
=======
<<<<<<< Updated upstream
import 'env.dart';
import 'vaahextendflutter/base/base_stateful.dart';
import 'vaahextendflutter/helpers/constants.dart';
import 'vaahextendflutter/log/console.dart';
import 'vaahextendflutter/tag/tag_panel.dart';
=======
import 'app_config.dart';
import 'controllers/base_controller.dart';
>>>>>>> Stashed changes
>>>>>>> Stashed changes

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
<<<<<<< Updated upstream
  BaseController baseController = Get.put(BaseController());
  await baseController.init();
  runApp(const TeamApp());
}
=======
<<<<<<< Updated upstream
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

final _navigatorKey = GlobalKey<NavigatorState>();

class TeamApp extends StatelessWidget {
  const TeamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebReinvent Team',
      theme: ThemeData(
        primarySwatch: kPrimaryColor,
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
  void initState() {
    envController = Get.find<EnvController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Webreinvent'),
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
=======
  BaseController baseController = Get.put(BaseController());
  await baseController.init();
  runApp(const AppConfig());
}
>>>>>>> Stashed changes
>>>>>>> Stashed changes
