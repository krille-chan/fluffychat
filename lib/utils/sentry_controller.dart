import 'package:bot_toast/bot_toast.dart';
import 'package:fluffychat/components/dialogs/simple_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:localstorage/localstorage.dart';

abstract class SentryController {
  static LocalStorage storage = LocalStorage('LocalStorage');
  static Future<void> toggleSentryAction(BuildContext context) async {
    final enableSentry = await SimpleDialogs(context).askConfirmation(
      titleText: L10n.of(context).sendBugReports,
      contentText: L10n.of(context).sentryInfo,
      confirmText: L10n.of(context).ok,
      cancelText: L10n.of(context).no,
    );
    await storage.ready;
    await storage.setItem('sentry', enableSentry);
    BotToast.showText(text: L10n.of(context).changesHaveBeenSaved);
    return;
  }

  static Future<bool> getSentryStatus() async {
    await storage.ready;
    return storage.getItem('sentry') as bool;
  }
}
