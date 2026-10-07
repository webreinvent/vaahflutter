import 'dart:async';
import 'dart:convert';

import 'package:app_links/app_links.dart';

import 'logging_library/logging_library.dart';

/// The link origin (`scheme://host/path`), used only in log lines. Defined once
/// so the format can't drift between the service and the app-layer handler.
/// Never includes the query string — it carries the payload (incl. `auth`),
/// which must not be written to logs.
String _linkOrigin(Uri uri) => '${uri.scheme}://${uri.host}${uri.path}';

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
  // Not final so [dispose] can recreate it, keeping the service re-initializable.
  static StreamController<DeepLink> _dynamicLinksStreamController =
      StreamController<DeepLink>();

  /// Links decoded by this service. The app listens to this and navigates.
  static Stream<DeepLink> get dynamicLinksStream =>
      _dynamicLinksStreamController.stream;

  /// Decodes the initial cold-start link (if any) and subscribes to incoming
  /// links. Both are emitted on [dynamicLinksStream]; this method never
  /// navigates. A no-op if already initialized.
  static Future<void> init() async {
    // Guard against double-init (tests, hot restart): a second call would
    // otherwise re-emit the initial link and leak a second subscription.
    if (_linkSubscription != null) return;
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
      _linkSubscription = _appLinks.uriLinkStream.listen(
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

  /// Tears down the stream subscription and closes the link stream. Recreates
  /// the controller so [init] can be called again (tests, hot restart) without
  /// hitting a closed-controller StateError.
  ///
  /// Note: this replaces [dynamicLinksStream] with a brand-new controller, so
  /// any listener still holding the previous stream is orphaned and must
  /// cancel + re-subscribe to keep receiving links. A full re-init is therefore
  /// consumer-side: stop the old listener, call [dispose], call [init], then
  /// subscribe to the fresh [dynamicLinksStream] again.
  static void dispose() {
    _linkSubscription?.cancel();
    _linkSubscription = null;
    _dynamicLinksStreamController.close();
    _dynamicLinksStreamController = StreamController<DeepLink>();
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
  ///
  /// **Threat model — treat `auth` as untrusted.** The payload (including
  /// `auth`) is carried in the URL's query string, so it is persisted in OS
  /// link logs, browser history, analytics, and referrer headers, and is
  /// trivially shareable. Do not put long-lived credentials or tokens in
  /// `auth`; pass an opaque, short-lived, server-issued routing token instead,
  /// and have the target page exchange it for real credentials over TLS via
  /// `Api`. The consuming page must validate the token and never treat `auth`
  /// as an authenticated identity.
  static Future<String?> createLink({
    required String domain,
    String? path,
    dynamic data,
    dynamic auth,
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
      Log.info("Generated Link: ${_linkOrigin(uri)}");
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
      if (payload is! Map) {
        // A link with no `payload` query param is a plain (non-deep) link —
        // expected, not an error. Only warn when a payload is present but
        // isn't a JSON object (e.g. a bare string or number): a malformed
        // deep link. Log the origin only — never the payload (incl. `auth`).
        if (uri.queryParameters.containsKey('payload')) {
          Log.warning(
            "Deep link payload is not a JSON object; ignoring",
            data: {"origin": _linkOrigin(uri)},
          );
        }
        return;
      }

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
        data: {"origin": _linkOrigin(uri)},
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

  /// The link origin (`scheme://host/path`), for logging. Never includes the
  /// query string, which carries the payload (incl. `auth`).
  String get origin => _linkOrigin(uri);
}
