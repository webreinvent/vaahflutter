
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/routes.dart';
import '../theme.dart';
import '../vaahextendflutter/tag/tag_panel.dart';
import '../view/pages/home/home.dart';

final _navigatorKey = GlobalKey<NavigatorState>();

class TeamApp extends StatelessWidget {
  const TeamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'WebReinvent Team',
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
