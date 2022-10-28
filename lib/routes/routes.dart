import 'package:flutter/material.dart';

import '../view/pages/home/home.dart';

<<<<<<< Updated upstream
Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  if (settings.name == '/') {
    return TeamHomePage.route();
  }
  return null;
=======

Map<String,  Route<void>> routes = {
  '/': TeamHomePage.route(),
};

Route<dynamic>? onGenerateRoute(RouteSettings route) {
  return routes[route.name];
>>>>>>> Stashed changes
}
