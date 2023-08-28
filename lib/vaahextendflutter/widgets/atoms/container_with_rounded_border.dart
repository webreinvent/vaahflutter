import 'package:flutter/material.dart';

import '../../helpers/constants.dart';

class ContainerWithRoundedBorder extends StatelessWidget {
  final EdgeInsets padding;
  final double? width;
  final double? height;
  final double borderRadius;
  final Color color;
  final Widget child;

  const ContainerWithRoundedBorder({
    super.key,
    this.padding = allPadding24,
    this.width,
    this.height,
    this.borderRadius = defaultPadding,
    this.color = Colors.white,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: color,
      ),
      child: child,
    );
  }
}
