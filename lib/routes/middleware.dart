import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../view/pages/home.dart';
import '../view/pages/permission_denied.dart';
import '../view/pages/something_went_wrong.dart';
import 'routes.dart';

List<String> defalutPermissions = [
  '/',
  TeamHomePage.routeName,
  SomethingWentWrong.routeName,
];

Route<dynamic>? routeMiddleware(RouteSettings route) {
  if (!routes.containsKey(route.name)) {
    return SomethingWentWrong.route();
  }
  // Fetch user permission from controller
  // -> controller connects with model
  // -> model connects with api/ service
  // -> api sends back resp, model translates, it
  // -> model sends back to controller
  // -> From that controller response middleware checks permission
  if (defalutPermissions.contains(route.name)) {
    // include user specific permissions in if condition
    return routes[route.name]!();
  }
  return PermissionDenied.route();
}
