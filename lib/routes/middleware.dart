import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:team/routes/routes.dart';
import 'package:team/view/pages/page_not_found.dart';

Route<dynamic>? routeMiddleware(RouteSettings route) {
  if (!routes.containsKey(route.name)) {
    return PageNotFound.route();
  }
  return routes[route.name]!();
}
