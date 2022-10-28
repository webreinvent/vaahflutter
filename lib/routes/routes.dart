import 'package:flutter/material.dart';

import '../view/pages/home.dart';
import '../view/pages/something_went_wrong.dart';


Map<String,  Route<void>> routes = {
  '/': TeamHomePage.route(),
  SomethingWentWrong.routeName: SomethingWentWrong.route(),
};

Route<dynamic>? onGenerateRoute(RouteSettings route) {
  return routes[route.name] ?? SomethingWentWrong.route();
}
