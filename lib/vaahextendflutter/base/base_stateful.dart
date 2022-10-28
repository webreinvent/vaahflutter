import 'package:flutter/material.dart';

import '../helpers/responsive.dart';

abstract class BaseStateful<T extends StatefulWidget> extends State<T>
    with DynamicSize {
  // Context valid to create providers
  @mustCallSuper
  @protected
  void initDependencies(BuildContext context) {
    // eg. Connectivity controller (Which checks network connectivity)
  }

  @protected
  void afterFirstBuild(BuildContext context) {}

  @mustCallSuper
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      afterFirstBuild(context);
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @mustCallSuper
  @override
  Widget build(BuildContext context) {
    initDependencies(context);
    initDynamicSize(context);
    return const SizedBox();
  }
}
