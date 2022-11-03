import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team/routes/controller.dart';

import '../view/pages/home.dart';
import '../view/pages/permission_denied.dart';
import '../view/pages/something_went_wrong.dart';
import 'routes.dart';

List<String> defalutPermissions = [
  '/',
  TeamHomePage.routeName,
];

Route<dynamic>? routeMiddleware(RouteSettings route) {
  if (!routes.containsKey(route.name)) {
    return SomethingWentWrong.route();
  }
  if (defalutPermissions.contains(route.name)) {
    return routes[route.name]!();
  }
  // Fetch user permission from controller
  // -> controller connects with model
  // -> model connects with api/ service
  // -> api sends back resp, model translates, it
  // -> model sends back to controller
  // -> From that controller response middleware checks permission
  final RouteController routeController = Get.put(
    RouteController(),
  );
  bool userHasPermission = routeController.checkRoutePermission(route.name as String);
  if (userHasPermission) {
    return routes[route.name]!();
  }
  return PermissionDenied.route();
}
