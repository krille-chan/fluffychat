import 'package:get_storage/get_storage.dart';

import 'package:fluffychat/pangea/common/constants/local.key.dart';
import 'package:fluffychat/pangea/subscription/models/base_subscription_info.dart';

class SubscriptionManagementRepo {
  static final GetStorage _cache = GetStorage("subscription_storage");

  static AvailableSubscriptionsInfo? getAvailableSubscriptionsInfo() {
    final entry = _cache.read(PLocalKey.availableSubscriptionInfo);
    if (entry == null) return null;
    try {
      return AvailableSubscriptionsInfo.fromJson(entry);
    } catch (e) {
      _cache.remove(PLocalKey.availableSubscriptionInfo);
      return null;
    }
  }

  static Future<void> setAvailableSubscriptionsInfo(
    AvailableSubscriptionsInfo info,
  ) async {
    await _cache.write(
      PLocalKey.availableSubscriptionInfo,
      info.toJson(),
    );
  }

  static bool getBeganWebPayment() {
    return _cache.read(PLocalKey.beganWebPayment) ?? false;
  }

  static Future<void> setBeganWebPayment() async {
    await _cache.write(PLocalKey.beganWebPayment, true);
  }

  static Future<void> removeBeganWebPayment() async {
    await _cache.remove(PLocalKey.beganWebPayment);
  }

  static bool getDismissedPaywall() {
    final entry = _cache.read(PLocalKey.dismissedPaywall);
    if (entry == null) return false;
    try {
      final dismissed = DateTime.parse(entry);
      final nextValidShowtime = dismissed.add(
        Duration(hours: 1 * _getPaywallBackoff()),
      );
      return DateTime.now().isBefore(nextValidShowtime);
    } catch (e) {
      _cache.remove(PLocalKey.dismissedPaywall);
      return false;
    }
  }

  static Future<void> setDismissedPaywall() async {
    await _cache.write(
      PLocalKey.dismissedPaywall,
      DateTime.now().toIso8601String(),
    );
    await _incrementPaywallBackoff();
  }

  static int _getPaywallBackoff() {
    return _cache.read(PLocalKey.paywallBackoff) ?? 0;
  }

  static Future<void> _incrementPaywallBackoff() async {
    final int backoff = _getPaywallBackoff() + 1;
    await _cache.write(PLocalKey.paywallBackoff, backoff);
  }
}
