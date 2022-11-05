import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team/controllers/user_controller.dart';
import 'package:team/routes/observer.dart';
import 'package:team/vaahextendflutter/base/base_stateful.dart';
import 'package:team/vaahextendflutter/helpers/constants.dart';
import 'package:team/view/pages/details.dart';

class TeamHomePage extends StatefulWidget {
  static const String routeName = '/home';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/home'),
      builder: (_) => const RouteAwareWidget(
        name: '/home',
        child: TeamHomePage(),
      ),
    );
  }

  const TeamHomePage({super.key});

  @override
  State<TeamHomePage> createState() => _TeamHomePageState();
}

class _TeamHomePageState extends BaseStateful<TeamHomePage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, DetailsPage.routeName),
              child: const Text(
                'Route Details',
              ),
            ),
            horizontalMargin12,
            ElevatedButton(
              onPressed: () {
                UserController userController = Get.find<UserController>();
                userController.login('NA', 'NA');
              },
              child: const Text(
                'Login',
              ),
            ),
            horizontalMargin12,
            ElevatedButton(
              onPressed: () {
                UserController userController = Get.find<UserController>();
                userController.logout();
              },
              child: const Text(
                'Logout',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
