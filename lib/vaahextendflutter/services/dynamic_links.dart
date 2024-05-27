import 'dart:async';
import 'dart:convert';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';

import 'logging_library/logging_library.dart';

abstract class DynamicLinks {
  static void init() async {
    // handle initial dynamic link
    final getInitialLink = await _firebaseDynamicLinks.getInitialLink();
    if (getInitialLink != null) {
      _handleLink(getInitialLink);
    }

    // listen/ subscribe to the links which comes later and handle them
    _firebaseDynamicLinks.onLink
        .listen(
          _handleLink,
        )
        .onError(
          (error, stackTrace) => Log.exception(error, stackTrace: stackTrace),
        );
  }

  static final FirebaseDynamicLinks _firebaseDynamicLinks = FirebaseDynamicLinks.instance;
  static final StreamController<DeepLink> _dynamicLinksStreamController =
      StreamController<DeepLink>.broadcast();
  static final Stream<DeepLink> dynamicLinksStream = _dynamicLinksStreamController.stream;

  static Future<ShortDynamicLink?> createLink({
    required String? path,
    required dynamic data,
    required dynamic auth,
  }) async {
    try {
      final String parameters = jsonEncode({"path": path, "data": data, "auth": auth});
      return await _firebaseDynamicLinks.buildShortLink(
        DynamicLinkParameters(
          link: Uri.parse("https://your.domain?payload=$parameters"),
          uriPrefix: "https://YOUR_FIREBASE_APP_DYNAMIC_LINK_PREFIX.page.link",
          androidParameters: const AndroidParameters(packageName: "your.package.name"),
          iosParameters: const IOSParameters(bundleId: "your.bundle.identifier"),
        ),
        shortLinkType: ShortDynamicLinkType.unguessable,
      );
    } catch (error, stackTrace) {
      Log.exception("Error creating dynamic link!", throwable: error, stackTrace: stackTrace);
      return null;
    }
  }

  static Future<void> _handleLink(PendingDynamicLinkData linkData) async {
    try {
      final Uri decodedLink = Uri.parse(Uri.decodeFull(linkData.link.toString()));
      final dynamic payload = _decodePayload(decodedLink);
      _dynamicLinksStreamController.add(
        DeepLink(
          encoded: linkData.link.toString(),
          decoded: "${linkData.link.host}${linkData.link.path}?payload=$payload",
        ),
      );
      Log.success(
        "Handle Deeplink",
        data: {
          "encoded": linkData.link.toString(),
          "decoded": "${linkData.link.host}${linkData.link.path}?payload=$payload",
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
        "Error handling dynamic link! ${linkData.asMap()}",
        throwable: error,
        stackTrace: stackTrace,
      );
    }
  }

  static dynamic _decodePayload(Uri link) {
    try {
      return jsonDecode(link.queryParameters['payload'].toString());
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
