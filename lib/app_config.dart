import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team/app_theme.dart';
import 'package:team/env.dart';
import 'package:team/routes/middleware.dart';
import 'package:team/routes/observer.dart';
import 'package:team/vaahextendflutter/tag/tag_panel.dart';

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
      navigatorObservers: <RouteObserver<ModalRoute<void>>>[routeObserver],
      onGenerateRoute: routeMiddleware,
      builder: (BuildContext context, Widget? child) {
        return TagPanelHost(
          navigatorKey: _navigatorKey,
          child: child!,
        );
      },
    );
  }
}
