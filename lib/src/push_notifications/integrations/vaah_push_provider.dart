import '../../models/push_notifications/vaah_push_event.dart';
import '../../models/user/vaah_user.dart';

abstract class VaahPushProvider {
  const VaahPushProvider();

  String? get subscriptionId;
  Stream<VaahPushEvent> get receivedPushStream;
  Stream<VaahPushEvent> get openedPushStream;

  Future<void> grantConsent();

  Future<void> revokeConsent();

  Future<void> bindUser(VaahUser user);

  Future<void> unbindUser();

  Future<void> dispose();
}
