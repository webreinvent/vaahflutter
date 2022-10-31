
import 'package:flutter/material.dart';

import '../../vaahextendflutter/base/base_stateless.dart';

class SomethingWentWrong extends BaseStateless {
  static const String routeName = '/something-went-wrong';
  
  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/something-went-wrong'),
      builder: (_) => const SomethingWentWrong(),
    );
  }

  const SomethingWentWrong({super.key});

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
