import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/middleware.dart';
import 'vaahextendflutter/app_theme.dart';
import 'vaahextendflutter/env/env.dart';
import 'vaahextendflutter/services/logging_library/logging_library.dart';
import 'vaahextendflutter/widgets/debug.dart';

final _navigatorKey = GlobalKey<NavigatorState>();

class AppConfig extends StatelessWidget {
  const AppConfig({super.key});

  EnvironmentConfig get config => EnvironmentConfig.getConfig;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: config.appTitle,
      theme: ThemeData(
        primarySwatch: AppTheme.colors['primary'],
      ),
      navigatorObservers: Log.loggingServiceObserver,
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
