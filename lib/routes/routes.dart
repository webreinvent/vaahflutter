import 'package:flutter/material.dart';

import '../view/pages/home.dart';
import '../view/pages/permission_denied.dart';
import '../view/pages/something_went_wrong.dart';

final Map<String, Route<dynamic> Function()> routes = {
  '/': TeamHomePage.route,
  TeamHomePage.routeName: TeamHomePage.route,
  SomethingWentWrong.routeName: SomethingWentWrong.route,
  PermissionDenied.routeName: PermissionDenied.route,
};