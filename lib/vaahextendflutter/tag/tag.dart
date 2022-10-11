import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../env.dart';
import '../services/screen_util.dart';

class TagWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsets? margin;
  final AlignmentGeometry? alignment;

  const TagWrapper({
    super.key,
    required this.child,
    this.margin,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    bool showEnvAndVersionTag = false;
    EnvController? envController;
    bool envControllerExists = Get.isRegistered<EnvController>();
    if (envControllerExists) {
      envController = Get.find<EnvController>();
      showEnvAndVersionTag = envController.config.showEnvAndVersionTag;
    }
    return showEnvAndVersionTag
        ? Stack(
            children: [
              child,
              wrapAlignment(
                alignment: alignment,
                child: Container(
                  margin: margin,
                  child: tagWidget(
                    color: Colors.red,
                    envType: envController!.config.envType,
                    version: envController.config.version,
                    build: envController.config.build,
                  ),
                ),
              ),
            ],
          )
        : child;
  }
}

Widget tagWidget({
  required Color color,
  required String envType,
  required String version,
  required String build,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.red,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      '$envType $version +$build',
      style: TextStyle(
        fontSize: 12.spExt,
        color: color,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget wrapAlignment({AlignmentGeometry? alignment, required Widget child}) {
  if (alignment != null) {
    return Align(
      alignment: alignment,
      child: child,
    );
  }
  return child;
}
