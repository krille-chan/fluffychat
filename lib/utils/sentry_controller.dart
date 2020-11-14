import 'package:flushbar/flushbar_helper.dart';
import 'package:fluffychat/components/dialogs/simple_dialogs.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:sentry/sentry.dart';

import 'famedlysdk_store.dart';
import '../config/setting_keys.dart';

abstract class SentryController {
  static Future<void> toggleSentryAction(BuildContext context) async {
    final enableSentry = await SimpleDialogs(context).askConfirmation(
      titleText: L10n.of(context).sendBugReports,
      contentText: L10n.of(context).sentryInfo,
      confirmText: L10n.of(context).ok,
      cancelText: L10n.of(context).no,
    );
    final storage = Store();
    await storage.setItem(SettingKeys.sentry, enableSentry.toString());
    await FlushbarHelper.createSuccess(
            message: L10n.of(context).changesHaveBeenSaved)
        .show(context);
    return;
  }

  static Future<bool> getSentryStatus() async {
    final storage = Store();
    return await storage.getItemBool(SettingKeys.sentry);
  }

  static final sentry = SentryClient(dsn: AppConfig.sentryDsn);

  static void captureException(error, stackTrace) async {
    debugPrint(error.toString());
    debugPrint(stackTrace.toString());
    if (!kDebugMode && await getSentryStatus()) {
      await sentry.captureException(
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }
}
