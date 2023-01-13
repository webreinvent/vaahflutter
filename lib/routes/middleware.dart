import 'package:flutter/material.dart';
import 'package:team/routes/routes.dart';
import 'package:team/views/pages/not_found.dart';

Route<dynamic>? routeMiddleware(RouteSettings route) {
  if (!routes.containsKey(route.name)) {
    return NotFoundPage.route();
  }
  return routes[route.name]!();
}
