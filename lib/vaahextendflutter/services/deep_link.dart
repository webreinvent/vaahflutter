/// A decoded deep link payload.
///
/// Emitted on `RemoteNotifications.notificationDeepLinkStream` when an
/// OneSignal notification click carries a deep-link payload (`path`/`data`/
/// `auth` in the notification's additional data).
///
/// The consuming app decides what to do with these fields. [path] is the
/// requested route name and is untrusted input — the app must validate it
/// against its own route allowlist before navigating. [data] and [auth] are
/// the payload's content fields.
class DeepLink {
  /// The full link, **including the query string**, when the deep link has an
  /// originating URL. The query carries the payload (incl. `auth`), so do not
  /// log `uri` or forward it to analytics — use [origin] for anything that
  /// gets written down. Null when the deep link has no originating URL (an
  /// OneSignal notification click carries only the payload, not a link).
  final Uri? uri;

  /// The requested route name. Untrusted input — validate against the app's
  /// route allowlist before navigating.
  final String? path;

  /// The payload's content data.
  final Object? data;

  /// The payload's auth field. Treat as untrusted (see the class docs); pass
  /// opaque, short-lived, server-issued routing tokens, never credentials.
  final Object? auth;

  const DeepLink({this.uri, this.path, this.data, this.auth});

  /// The link origin (`scheme://host/path`), for logging. Never includes the
  /// query string, which carries the payload (incl. `auth`). Null when [uri]
  /// is null.
  String? get origin {
    final Uri? linkUri = uri;
    if (linkUri == null) return null;
    return '${linkUri.scheme}://${linkUri.host}${linkUri.path}';
  }
}
