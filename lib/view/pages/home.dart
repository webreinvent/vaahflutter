import 'package:flutter/material.dart';
import 'package:team/models/user.dart';
import 'package:team/vaahextendflutter/base/base_stateful.dart';
import 'package:team/vaahextendflutter/helpers/constants.dart';
import 'package:team/view/layouts/forgot_password.dart';

class TeamHomePage extends StatefulWidget {
  static const String routeName = '/home';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/home'),
      builder: (_) => const TeamHomePage(),
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
                User.signin('NA', 'NA');
              },
              child: const Text(
                'Login',
              ),
            ),
            horizontalMargin12,
            ElevatedButton(
              onPressed: () {
                User.signout();
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
