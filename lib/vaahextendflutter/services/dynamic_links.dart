import 'dart:async';
import 'dart:convert';
import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'logging_library/logging_library.dart';

abstract class DynamicLinks {
  static final AppLinks _appLinks = AppLinks();
  static StreamSubscription<Uri>? _linkSubscription;

  static final StreamController<DeepLink> _dynamicLinksStreamController =
  StreamController<DeepLink>.broadcast();
  static final Stream<DeepLink> dynamicLinksStream = _dynamicLinksStreamController.stream;

  static void init() async {
    try {
      // 1. Handle the initial link if the app was opened from a cold start via a link
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleUri(initialUri);
      }

      // 2. Listen for incoming links while the app is in the background or foreground
      _linkSubscription = _appLinks.uriLinkStream.listen(
            (Uri uri) {
          _handleUri(uri);
        },
        onError: (error, stackTrace) {
          Log.exception(error, stackTrace: stackTrace, hint: "Error in AppLinks stream");
        },
      );
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace: stackTrace, hint: "Error initializing DynamicLinks");
    }
  }

  static void dispose() {
    _linkSubscription?.cancel();
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
      final String parameters = jsonEncode({"path": path, "data": data, "auth": auth});
      final Uri uri = Uri(
        scheme: 'https',
        host: domain,
        path: 'deep-link',
        queryParameters: {'payload': parameters},
      );
      final String generatedUrl = uri.toString();

      Log.info("Generated Link: $generatedUrl");
      return generatedUrl;
    } catch (error, stackTrace) {
      Log.exception(error, stackTrace: stackTrace, hint: "Error creating link!");
      return null;
    }
  }

  static void _handleUri(Uri uri) {
    try {
      final dynamic payload = _decodePayload(uri);

      _dynamicLinksStreamController.add(
        DeepLink(
          encoded: uri.toString(),
          decoded: "${uri.host}${uri.path}?payload=$payload",
        ),
      );

      Log.success({
        "encoded": uri.toString(),
        "decoded": "${uri.host}${uri.path}?payload=$payload",
      });

      if (payload != null && payload['path'] != null) {
        Get.to(
          payload['path'],
          arguments: <String, dynamic>{
            'data': payload['data'],
            'auth': payload['auth'],
          },
        );
      }
    } catch (error, stackTrace) {
      Log.exception(
        error,
        stackTrace: stackTrace,
        hint: "Error handling link! $uri",
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
        error,
        stackTrace: stackTrace,
        hint: "Error decoding payload! $link",
      );
      return null;
    }
  }
}

class DeepLink {
  final String encoded;
  final String decoded;

  const DeepLink({
    required this.encoded,
    required this.decoded,
  });
}