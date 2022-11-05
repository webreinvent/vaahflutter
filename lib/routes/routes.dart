import 'package:flutter/material.dart';
import 'package:team/view/pages/details.dart';
import 'package:team/view/pages/home.dart';
import 'package:team/view/pages/more_details.dart';
import 'package:team/view/pages/page_not_found.dart';
import 'package:team/view/pages/permission_denied.dart';

final Map<String, Route<dynamic> Function()> routes = {
  '/': TeamHomePage.route,
  TeamHomePage.routeName: TeamHomePage.route,
  PageNotFound.routeName: PageNotFound.route,
  PermissionDenied.routeName: PermissionDenied.route,
  DetailsPage.routeName: DetailsPage.route,
  MoreDetailsPage.routeName: MoreDetailsPage.route,
};

const List<String> defaultPermissions = [
  '/',
  TeamHomePage.routeName,
];
