import 'package:flutter/material.dart';
import 'package:team/vaahextendflutter/app_theme.dart';
import 'package:team/vaahextendflutter/base/base_stateful.dart';
import 'package:team/vaahextendflutter/helpers/constants.dart';

class UIPage extends StatefulWidget {
  static const String routePath = '/ui-page';

  static Route<void> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routePath),
      builder: (_) => const UIPage(),
    );
  }

  const UIPage({super.key});

  @override
  State<UIPage> createState() => _UIPageState();
}

class _UIPageState extends BaseStateful<UIPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppTheme.colors['black']?.shade100,
      appBar: AppBar(
        title: const Text('UI Page'),
      ),
      body: Padding(
        padding: horizontalPadding24,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [],
          ),
        ),
      ),
    );
  }
}
