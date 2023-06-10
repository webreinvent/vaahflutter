import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'routes/middleware.dart';
import 'vaahextendflutter/app_theme.dart';
import 'vaahextendflutter/env.dart';
import 'vaahextendflutter/widgets/debug.dart';

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
      navigatorObservers: [
        SentryNavigatorObserver(),
      ],
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

class ErrorAppConfig extends StatelessWidget {
  const ErrorAppConfig({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: AppTheme.colors['primary'],
      ),
      home: Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('Something Went Wrong!'),
        ),
      ),
    );
  }
}
