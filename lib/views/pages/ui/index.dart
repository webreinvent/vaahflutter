import 'package:flutter/material.dart';

import '../../../vaahextendflutter/app_theme.dart';
import '../../../vaahextendflutter/helpers/constants.dart';
import 'components/buttons/buttons.dart';
import 'components/inputs/inputs.dart';
import 'components/themecolors.dart';

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

class _UIPageState extends State<UIPage> {
  @override
  Widget build(BuildContext context) {
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
            children: const [
              verticalMargin24,
              AppThemeColors(),
              verticalMargin24,
              AppInputs(),
              verticalMargin24,
              Buttons(),
              verticalMargin24,
            ],
          ),
        ),
      ),
    );
  }
}
