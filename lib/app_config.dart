import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './routes/middleware.dart';
import './vaahextendflutter/app_theme.dart';
import './vaahextendflutter/env.dart';
import './vaahextendflutter/widgets/debug.dart';

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
      onGenerateRoute: routeMiddleware,
      builder: (BuildContext context, Widget? child) {
        return DebugWidget(
          navigatorKey: _navigatorKey,
          child: child!,
        );
      },
    );
  }
}
