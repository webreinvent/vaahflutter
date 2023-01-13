import 'package:flutter/material.dart';
import 'package:team/views/pages/home.dart';
import 'package:team/views/pages/not_found.dart';
import 'package:team/views/pages/permission_denied.dart';
import 'package:team/views/pages/ui/index.dart';

final Map<String, Route<dynamic> Function()> routes = {
  '/': HomePage.route,
  HomePage.routePath: HomePage.route,
  NotFoundPage.routePath: NotFoundPage.route,
  PermissionDeniedPage.routePath: PermissionDeniedPage.route,
  UIPage.routePath: UIPage.route,
};
