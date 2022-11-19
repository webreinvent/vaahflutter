import 'package:flutter/material.dart';
import 'package:team/view/pages/home.dart';
import 'package:team/view/pages/not_found.dart';
import 'package:team/view/pages/permission_denied.dart';

final Map<String, Route<dynamic> Function()> routes = {
  '/': HomePage.route,
  HomePage.routePath: HomePage.route,
  NotFoundPage.routePath: NotFoundPage.route,
  PermissionDeniedPage.routePath: PermissionDeniedPage.route,
};