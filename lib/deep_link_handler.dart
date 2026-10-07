import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'vaahextendflutter/services/dynamic_links.dart';
import 'vaahextendflutter/services/logging_library/logging_library.dart';

/// App-layer deep-link handling.
///
/// The [DynamicLinks] service only decodes links and emits them on
/// [DynamicLinks.dynamicLinksStream] — it never navigates. Deciding what to do
/// with a link is the app's job, and it must happen after `runApp`, when the
/// GetX router exists. A link's `path` is untrusted input, so we only navigate
/// to routes this app registers (the [allowedRoutes] allowlist).
///
/// This class is given its [source] and [allowedRoutes] rather than importing
/// the app's route table itself: it stays a pure navigation policy, and the
/// navigation + allowlist logic can be exercised in tests without the platform
/// link channel or the rest of the app.
abstract class DeepLinkNavigator {
  static StreamSubscription<DeepLink>? _sub;
  static Map<String, Route<dynamic> Function()> _allowedRoutes = const {};

  // The navigation action. Defaults to GetX's named-route navigation; injectable
  // in tests so the allowlist + argument logic can be asserted without a live
  // GetX router (contextless `Get.toNamed` is fiddly to drive in widget tests).
  static void Function(String path, {Object? arguments}) _navigateTo =
      _defaultNavigateTo;

  static void _defaultNavigateTo(String path, {Object? arguments}) {
    Get.toNamed(path, arguments: arguments);
  }

  /// Subscribe to [source] and navigate on each link, restricted to
  /// [allowedRoutes]. Call this once, after the app is running (e.g. right
  /// after `BaseController.init`), passing the live service stream and the
  /// app's registered routes.
  ///
  /// Idempotent: if a subscription is already active it is left in place and
  /// only [allowedRoutes] is updated. This is what makes a double `listen()`
  /// safe — re-listening the single-subscription [source] would otherwise
  /// throw "Stream has already been listened to". To switch to a different
  /// [source], call [dispose] first.
  static void listen({
    required Stream<DeepLink> source,
    required Map<String, Route<dynamic> Function()> allowedRoutes,
    void Function(String path, {Object? arguments})? navigateTo,
  }) {
    _allowedRoutes = allowedRoutes;
    _navigateTo = navigateTo ?? _defaultNavigateTo;
    if (_sub != null) return;
    _sub = source.listen(_onDeepLink);
  }

  /// Cancel the active subscription, if any. Call before re-subscribing to a
  /// different [source] (e.g. on hot restart) or to stop reacting to links.
  ///
  /// `DynamicLinks.dispose()` replaces the stream controller, so a full
  /// re-init is: [dispose] → `DynamicLinks.dispose()` → `DynamicLinks.init()`
  /// → [listen]. Skipping [dispose] leaves [listen] on the old (closed)
  /// stream, and the navigator silently stops reacting to new links.
  static void dispose() {
    _sub?.cancel();
    _sub = null;
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
    if (_allowedRoutes[path] == null) {
      // Log the link origin only — never the payload (incl. `auth`).
      Log.warning(
        "Deep link rejected: unknown route",
        data: {
          "origin": "${link.uri.scheme}://${link.uri.host}${link.uri.path}",
        },
      );
      return;
    }

    _navigateTo(
      path,
      arguments: <String, dynamic>{'data': link.data, 'auth': link.auth},
    );
  }
}
