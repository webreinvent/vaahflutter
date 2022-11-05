import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team/routes/controller.dart';
import 'package:team/routes/routes.dart';
import 'package:team/view/pages/page_not_found.dart';
import 'package:team/view/pages/permission_denied.dart';

Route<dynamic>? routeMiddleware(RouteSettings route) {
  if (!routes.containsKey(route.name)) {
    return PageNotFound.route();
  }
  if (defaultPermissions.contains(route.name)) {
    return routes[route.name]!();
  }
  final bool userHasPermission = _checkRoutePermission(route.name as String);
  if (userHasPermission) {
    return routes[route.name]!();
  }
  return PermissionDenied.route();
}

bool _checkRoutePermission(String route) {
  RouteController routeController = Get.find<RouteController>();
  return routeController.checkRoutePermission(route);
}
