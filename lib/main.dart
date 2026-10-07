import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_config.dart';
import 'deep_link_handler.dart';
import 'routes/routes.dart';
import 'vaahextendflutter/base/base_controller.dart';
import 'vaahextendflutter/env/env.dart';
import 'vaahextendflutter/env/notification.dart';
import 'vaahextendflutter/services/dynamic_links.dart';
import 'vaahextendflutter/services/notification/push/services/remote.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BaseController baseController = Get.put(BaseController());
  await baseController.init(
    app: const AppConfig(),
    errorApp: const ErrorAppConfig(),
  ); // Pass main app as argument in init method

  // The app is running now (router exists); react to deep links. Both sources
  // carry an untrusted `path`, so both are gated on the same route allowlist:
  //   - app links (app_links), when deep links are enabled in the env;
  //   - OneSignal notification clicks, when remote push is configured.
  // Each source is omitted when disabled (a disabled source never emits), and
  // with no active source there is nothing to subscribe to.
  final bool deepLinksEnabled =
      EnvironmentConfig.getConfig.dynamicLinksEnabled;
  final PushNotificationsServiceType pushType =
      EnvironmentConfig.getConfig.pushNotificationsServiceType;
  final List<Stream<DeepLink>> deepLinkSources = <Stream<DeepLink>>[
    if (deepLinksEnabled) DynamicLinks.dynamicLinksStream,
    if (pushType == PushNotificationsServiceType.remote ||
        pushType == PushNotificationsServiceType.both)
      RemoteNotifications.notificationDeepLinkStream,
  ];
  if (deepLinkSources.isNotEmpty) {
    DeepLinkNavigator.listen(
      source: Stream<DeepLink>.multi((controller) {
        for (final Stream<DeepLink> source in deepLinkSources) {
          controller.addStream(source);
        }
      }),
      allowedRoutes: routes,
    );
  }
}
