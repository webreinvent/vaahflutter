import 'package:flutter/material.dart';

import '../views/pages/not_found.dart';
import './routes.dart';

Route<dynamic>? routeMiddleware(RouteSettings route) {
  if (!routes.containsKey(route.name)) {
    return NotFoundPage.route();
  }
  return routes[route.name]!();
}
