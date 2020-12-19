import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:fluffychat/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:sentry/sentry.dart';

import 'famedlysdk_store.dart';
import '../config/setting_keys.dart';

abstract class SentryController {
  static Future<void> toggleSentryAction(BuildContext context) async {
    if (!AppConfig.enableSentry) return;
    final enableSentry = await showOkCancelAlertDialog(
          context: context,
          title: L10n.of(context).sendBugReports,
          message: L10n.of(context).sentryInfo,
          okLabel: L10n.of(context).ok,
          cancelLabel: L10n.of(context).no,
        ) ==
        OkCancelResult.ok;
    final storage = Store();
    await storage.setItem(SettingKeys.sentry, enableSentry.toString());
    // ignore: unawaited_futures
    FlushbarHelper.createSuccess(message: L10n.of(context).changesHaveBeenSaved)
        .show(context);
    return;
  }

  static Future<bool> getSentryStatus() async {
    if (!AppConfig.enableSentry) return false;
    final storage = Store();
    return await storage.getItemBool(SettingKeys.sentry);
  }

  static final sentry = SentryClient(dsn: AppConfig.sentryDns);

  static void captureException(error, stackTrace) async {
    Logs().e('Capture exception', error, stackTrace);
    if (!kDebugMode && await getSentryStatus()) {
      await sentry.captureException(
        exception: error,
        stackTrace: stackTrace,
      );
    }
  }
}
