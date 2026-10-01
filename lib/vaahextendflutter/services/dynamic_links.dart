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
          Log.exception("Error in AppLinks stream", throwable: error, stackTrace: stackTrace);
        },
      );
    } catch (error, stackTrace) {
      Log.exception("Error initializing DynamicLinks", throwable: error, stackTrace: stackTrace);
    }
  }

  static void dispose() {
    _linkSubscription?.cancel();
    _dynamicLinksStreamController.close();
  }

  /// Note: Firebase short link generation (`buildShortLink`) no longer works.
  /// You can either generate standard web URLs pointing to your domain or use a
  /// third-party link-shortening API provider.
  static Future<String?> createLink({
    required String? path,
    required dynamic data,
    required dynamic auth,
  }) async {
    try {
      final String parameters = jsonEncode({"path": path, "data": data, "auth": auth});
      // Replace with your actual web domain configured for app links
      final String generatedUrl = "https://your.domain/deep-link?payload=$parameters";

      Log.info("Generated Link: $generatedUrl");
      return generatedUrl;
    } catch (error, stackTrace) {
      Log.exception("Error creating link!", throwable: error, stackTrace: stackTrace);
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

      Log.success(
        "Dynamic link received",
        data: {
          "encoded": uri.toString(),
          "decoded": "${uri.host}${uri.path}?payload=$payload",
        },
      );

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
        "Error handling link! $uri",
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
        "Error decoding payload! $link",
        throwable: error,
        stackTrace: stackTrace,
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