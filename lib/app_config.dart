import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'env.dart';

import 'routes/routes.dart';
import 'app_theme.dart';
import 'vaahextendflutter/tag/tag_panel.dart';
import 'view/pages/home/home.dart';

final _navigatorKey = GlobalKey<NavigatorState>();

class AppConfig extends StatelessWidget {
  const AppConfig({super.key});

  @override
  Widget build(BuildContext context) {
    EnvironmentConfig env = EnvironmentConfig.getEnvConfig();
    return GetMaterialApp(
      title: env.appTitle,
      theme: ThemeData(
        primarySwatch: AppTheme.colors['primary'],
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
