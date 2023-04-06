import 'dart:async';
import 'dart:convert';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';

import './logging_library/logging_library.dart';

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
  static final StreamController<PendingDynamicLinkData> _dynamicLinksStreamController =
      StreamController<PendingDynamicLinkData>.broadcast();
  static final Stream<PendingDynamicLinkData> dynamicLinksStream =
      _dynamicLinksStreamController.stream;

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
      Log.exception(error, stackTrace: stackTrace, hint: "Error creating dynamic link!");
      return null;
    }
  }

  static Future<void> _handleLink(PendingDynamicLinkData linkData) async {
    try {
      final dynamic payload = jsonDecode(linkData.link.queryParameters['payload'].toString());
      _dynamicLinksStreamController.add(linkData);
      if (payload != null && payload['path'] != null) {
        Get.offAllNamed(
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
        hint: "Error handling dynamic link! ${linkData.asMap()}",
      );
    }
  }
}