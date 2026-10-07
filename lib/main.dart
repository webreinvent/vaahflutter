import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_config.dart';
import 'deep_link_handler.dart';
import 'routes/routes.dart';
import 'vaahextendflutter/base/base_controller.dart';
import 'vaahextendflutter/services/dynamic_links.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BaseController baseController = Get.put(BaseController());
  await baseController.init(
    app: const AppConfig(),
    errorApp: const ErrorAppConfig(),
  ); // Pass main app as argument in init method

  // The app is running now (router exists); react to deep links — both the
  // cold-start link the service buffered and any that arrive live. Only routes
  // the app registers are reachable; a link's `path` is untrusted input.
  DeepLinkNavigator.listen(
    source: DynamicLinks.dynamicLinksStream,
    allowedRoutes: routes,
  );
}
