import 'package:flutter/material.dart';
import 'package:team/vaahextendflutter/base/base_stateless.dart';

class PageNotFound extends BaseStateless {
  static const String routeName = '/page-not-found';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/page-not-found'),
      builder: (_) => const PageNotFound(),
    );
  }

  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Page Not Found!'),
      ),
    );
  }
}
