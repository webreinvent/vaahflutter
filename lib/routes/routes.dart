import 'package:flutter/material.dart';

import '../view/pages/home/home.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  if (settings.name == '/') {
    return TeamHomePage.route();
  }
  return null;
}
