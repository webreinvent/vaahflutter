import 'package:flutter/material.dart';

import '../view/pages/home/home.dart';


Map<String,  Route<void>> routes = {
  '/': TeamHomePage.route(),
};

Route<dynamic>? onGenerateRoute(RouteSettings route) {
  return routes[route.name];
}
