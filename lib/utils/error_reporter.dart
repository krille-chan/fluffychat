// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/adaptive_dialog_action.dart';
import 'package:fluffychat/widgets/fluffy_chat_app.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:matrix/matrix.dart';
import 'package:sentry/sentry.dart';

class ErrorReporter {
  final BuildContext? context;
  final String? message;

  const ErrorReporter(this.context, [this.message]);

  static const Set<String> ingoredTypes = {
    'IOException',
    'ClientException',
    'SocketException',
    'TlsException',
    'HandshakeException',
  };

  static void onFlutterError(Object error, [StackTrace? stackTrace]) =>
      _sendErrorReport(
        message: 'Flutter Error',
        error: error,
        stackTrace: stackTrace,
      );

  static bool _sentryInitialized = false;

  static Future<void> _sendErrorReport({
    required String message,
    required Object error,
    required StackTrace? stackTrace,
    bool? consent,
  }) async {
    consent ??= AppSettings.autoSendErrorReports.value;
    final dsn = AppSettings.sentryDns.value;
    if (AppSettings.autoSendErrorReports.value != true || dsn.isEmpty) {
      debugPrint('Exception caught but auto send crash reports is disabled.');
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
      return;
    }
    if (!_sentryInitialized) {
      await Sentry.init((options) => options.dsn = dsn);
      _sentryInitialized = true;
    }
    Logs().e('Sending crash report... ($message)', error, stackTrace);
    if (!kReleaseMode) {
      Logs().v('Sending crash report aborted. Only possible in release mode!');
      return;
    }
    await Sentry.captureException(
      error,
      stackTrace: stackTrace,
      message: SentryMessage(message),
    );
  }

  Future<void> onErrorCallback(Object error, [StackTrace? stackTrace]) async {
    if (ingoredTypes.contains(error.runtimeType.toString())) return;
    Logs().e(message ?? 'Error caught', error, stackTrace);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _onErrorCallback(error, stackTrace),
    );
  }

  Future<void> _onErrorCallback(Object error, [StackTrace? stackTrace]) async {
    final context =
        this.context ??
        FluffyChatApp.router.routerDelegate.navigatorKey.currentContext;
    final text = '$error\n${stackTrace ?? ''}';

    if (context == null || !context.mounted) {
      debugPrint(
        'Exception caught but we have no mounted BuildContext to display a dialog to the user!\n$text',
      );
      return;
    }
    showAdaptiveDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: Text(L10n.of(context).reportErrorDescription),
        content: SizedBox(
          height: 256,
          width: 256,
          child: SingleChildScrollView(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, fontFamily: 'RobotoMono'),
            ),
          ),
        ),
        actions: [
          AdaptiveDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(L10n.of(context).close),
          ),
          AdaptiveDialogAction(
            onPressed: () => Clipboard.setData(ClipboardData(text: text)),
            child: Text(L10n.of(context).copy),
          ),
          AdaptiveDialogAction(
            onPressed: () => showFutureLoadingDialog(
              context: context,
              future: () => _sendErrorReport(
                message: message ?? 'Error from Error Reporting Dialog',
                error: error,
                stackTrace: stackTrace,
                consent: true,
              ),
            ),
            child: Text(L10n.of(context).report),
          ),
        ],
      ),
    );
  }
}
