import 'package:flutter/material.dart';
import 'package:team/view/pages/something_went_wrong.dart';

import '../../vaahextendflutter/base/base_stateful.dart';

class TeamHomePage extends StatefulWidget {
  static const String routeName = '/home';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/'),
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
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, SomethingWentWrong.routeName),
          child: const Text(
            '404 Error page',
          ),
        ),
      ),
    );
  }
}
