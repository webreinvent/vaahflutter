import 'dart:async';
import 'dart:convert';

import 'package:app_links/app_links.dart';

import 'logging_library/logging_library.dart';

/// Decodes app links (via [AppLinks]) and exposes them to the app.
///
/// This service is deliberately navigation-free: it only decodes a link into a
/// [DeepLink] and emits it on [dynamicLinksStream]. Deciding what to do with a
/// link (which route to open, with which arguments) is the app's job — so it
/// can run after `runApp`, when the router exists, and so the app owns its own
/// route allowlist. See the app's deep-link handler for the consuming side.
abstract class DynamicLinks {
  static final AppLinks _appLinks = AppLinks();
  static StreamSubscription<Uri>? _linkSubscription;

  // Single-subscription on purpose: the initial cold-start link is emitted
  // before the app subscribes (post-`runApp`), and a non-broadcast controller
  // buffers that event until the first listener attaches instead of dropping it.
  static final StreamController<DeepLink> _dynamicLinksStreamController =
      StreamController<DeepLink>();

  /// Links decoded by this service. The app listens to this and navigates.
  static Stream<DeepLink> get dynamicLinksStream =>
      _dynamicLinksStreamController.stream;

  /// Decodes the initial cold-start link (if any) and subscribes to incoming
  /// links. Both are emitted on [dynamicLinksStream]; this method never
  /// navigates.
  static Future<void> init() async {
    try {
      // 1. Emit the initial link if the app was opened from a cold start via a
      //    link. It is buffered on the stream until the app subscribes after
      //    `runApp`, so it is not lost.
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _emit(initialUri);
      }

      // 2. Listen for incoming links while the app is in the background or
      //    foreground.
      _linkSubscription ??= _appLinks.uriLinkStream.listen(
        _emit,
        onError: (error, stackTrace) {
          Log.exception(
            "Error in AppLinks stream",
            throwable: error,
            stackTrace: stackTrace,
          );
        },
      );
    } catch (error, stackTrace) {
      Log.exception(
        "Error initializing DynamicLinks",
        throwable: error,
        stackTrace: stackTrace,
      );
    }
  }

  static void dispose() {
    _linkSubscription?.cancel();
    _linkSubscription = null;
    _dynamicLinksStreamController.close();
  }

  /// Note: Firebase short link generation (`buildShortLink`) no longer works.
  /// You can either generate standard web URLs pointing to your domain or use a
  /// third-party link-shortening API provider.
  ///
  /// [domain] must be your real app-link host (the domain configured in your
  /// Android/iOS app-link manifest, e.g. `app.example.com`). The payload is
  /// JSON-encoded and then percent-encoded via [Uri.queryParameters] so it
  /// round-trips correctly through [Uri.queryParameters] on the receiving side
  /// (see [_decodePayload]).
  static Future<String?> createLink({
    required String domain,
    required String? path,
    required dynamic data,
    required dynamic auth,
  }) async {
    try {
      final String parameters = jsonEncode({
        "path": path,
        "data": data,
        "auth": auth,
      });
      final Uri uri = Uri(
        scheme: 'https',
        host: domain,
        path: 'deep-link',
        queryParameters: {'payload': parameters},
      );
      final String generatedUrl = uri.toString();

      // Log the link origin only — the query carries the payload (incl.
      // `auth`), which must not be written to console/Sentry/Firebase.
      Log.info("Generated Link: ${uri.scheme}://${uri.host}${uri.path}");
      return generatedUrl;
    } catch (error, stackTrace) {
      Log.exception(
        "Error creating link!",
        throwable: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Decodes [uri] and emits it on [dynamicLinksStream]. Never navigates — the
  /// app decides what to do with the link.
  static void _emit(Uri uri) {
    try {
      final dynamic payload = _decodePayload(uri);
      if (payload is! Map) return;

      final dynamic rawPath = payload['path'];

      _dynamicLinksStreamController.add(
        DeepLink(
          uri: uri,
          path: rawPath is String ? rawPath : null,
          data: payload['data'],
          auth: payload['auth'],
        ),
      );

      // Log the link origin only — the query carries the payload (incl.
      // `auth`), which must not be written to console/Sentry/Firebase.
      Log.success(
        "Dynamic link received",
        data: {"origin": "${uri.scheme}://${uri.host}${uri.path}"},
      );
    } catch (error, stackTrace) {
      Log.exception(
        "Error handling link!",
        throwable: error,
        stackTrace: stackTrace,
      );
    }
  }

  static dynamic _decodePayload(Uri link) {
    try {
      final String? payloadParam = link.queryParameters['payload'];
      if (payloadParam == null) return null;
      return jsonDecode(payloadParam);
    } catch (error, stackTrace) {
      Log.exception(
        "Error decoding payload!",
        throwable: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }
}

/// A decoded deep link, emitted on [DynamicLinks.dynamicLinksStream].
///
/// The service decodes a link into these fields; the app decides what to do
/// with them. [path] is the requested route name and is untrusted input — the
/// app must validate it against its own route allowlist before navigating.
/// [data] and [auth] are the payload's content fields.
class DeepLink {
  final Uri uri;
  final String? path;
  final dynamic data;
  final dynamic auth;

  const DeepLink({required this.uri, this.path, this.data, this.auth});
}
