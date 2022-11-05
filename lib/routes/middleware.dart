import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team/routes/controller.dart';
import 'package:team/routes/routes.dart';
import 'package:team/vaahextendflutter/helpers/console.dart';
import 'package:team/view/pages/page_not_found.dart';
import 'package:team/view/pages/permission_denied.dart';

Route<dynamic>? routeMiddleware(RouteSettings route) {
  if (!routes.containsKey(route.name)) {
    return PageNotFound.route();
  }
  final bool userHasPermission = _checkRoutePermission(route.name as String);
  if (!defaultPermissions.contains(route.name) && !userHasPermission) {
    return PermissionDenied.route();
  }
  return routes[route.name]!();
}

bool _checkRoutePermission(String route) {
  if (!Get.isRegistered<RouteController>()) {
    Console.danger('RouteController is not initialized!');
    return false;
  }
  RouteController routeController = Get.find<RouteController>();
  return routeController.checkRoutePermission(route);
}
