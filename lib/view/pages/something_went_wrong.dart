
import 'package:flutter/material.dart';

import '../../vaahextendflutter/base/base_stateful.dart';

class SomethingWentWrong extends StatefulWidget {
  static String routeName = '/something-went-wrong';
  
  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/something-went-wrong'),
      builder: (_) => const SomethingWentWrong(),
    );
  }

  const SomethingWentWrong({super.key});

  @override
  State<SomethingWentWrong> createState() => _SomethingWentWrongState();
}

class _SomethingWentWrongState extends BaseStateful<SomethingWentWrong> {

  @override
  void afterFirstBuild(BuildContext context) {
    super.afterFirstBuild(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Something Went Wrong'),
      ),
    );
  }
}
