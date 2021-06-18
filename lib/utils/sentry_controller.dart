import 'package:matrix/matrix.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry/sentry.dart';

import 'famedlysdk_store.dart';
import '../config/setting_keys.dart';

abstract class SentryController {
  static Future<void> toggleSentryAction(
      BuildContext context, bool enableSentry) async {
    if (!AppConfig.enableSentry) return;
    final storage = Store();
    await storage.setItem(SettingKeys.sentry, enableSentry.toString());
    return;
  }

  static Future<bool> getSentryStatus() async {
    if (!AppConfig.enableSentry) return false;
    final storage = Store();
    return await storage.getItemBool(SettingKeys.sentry);
  }

  static final sentry = SentryClient(SentryOptions(dsn: AppConfig.sentryDns));

  static void captureException(error, stackTrace) async {
    Logs().e('Capture exception', error, stackTrace);
    if (!kDebugMode && await getSentryStatus()) {
      await sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
    }
  }
}
