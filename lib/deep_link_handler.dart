import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'routes/routes.dart';
import 'vaahextendflutter/services/dynamic_links.dart';
import 'vaahextendflutter/services/logging_library/logging_library.dart';

/// App-layer deep-link handling.
///
/// The [DynamicLinks] service only decodes links and emits them on
/// [DynamicLinks.dynamicLinksStream] — it never navigates. Deciding what to do
/// with a link is the app's job, and it must happen after `runApp`, when the
/// GetX router exists. A link's `path` is untrusted input, so we only navigate
/// to routes this app registers (see [routes]).
class DeepLinkNavigator {
  /// Subscribe to the deep-link stream and navigate on each link. Call this
  /// once, after the app is running (e.g. right after `BaseController.init`).
  static void listen() {
    DynamicLinks.dynamicLinksStream.listen(_onDeepLink);
  }

  static void _onDeepLink(DeepLink link) {
    // The GetX router only exists once the app's first frame has built.
    // Deferring to the next frame also covers the cold-start link the service
    // buffered before `runApp`.
    WidgetsBinding.instance.addPostFrameCallback((_) => _navigate(link));
  }

  static void _navigate(DeepLink link) {
    final String? path = link.path;
    if (path == null || path.isEmpty) return;

    // Allowlist: only navigate to routes this app registers. A link's `path`
    // is attacker-controlled, so anything unregistered is dropped rather than
    // sent to the not-found fallback.
    if (routes[path] == null) {
      // Log the link origin only — never the payload (incl. `auth`).
      Log.warning(
        "Deep link rejected: unknown route",
        data: {
          "origin": "${link.uri.scheme}://${link.uri.host}${link.uri.path}",
        },
      );
      return;
    }

    Get.toNamed(
      path,
      arguments: <String, dynamic>{'data': link.data, 'auth': link.auth},
    );
  }
}
