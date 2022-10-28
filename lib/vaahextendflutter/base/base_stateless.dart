import 'package:flutter/material.dart';

import '../helpers/responsive.dart';

abstract class BaseStateless extends StatelessWidget with DynamicSize {
  const BaseStateless({super.key});

  // Context valid to create controllers
  @mustCallSuper
  @protected
  void initDependencies(BuildContext context) {
    // eg. Connectivity controller
  }

  @protected
  void afterFirstBuild(BuildContext context) {}

  @mustCallSuper
  @override
  Widget build(BuildContext context) {
    initDependencies(context);
    initDynamicSize(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      afterFirstBuild(context);
    });
    return const SizedBox();
  }
}
