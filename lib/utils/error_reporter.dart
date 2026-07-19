// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/adaptive_dialog_action.dart';
import 'package:fluffychat/widgets/fluffy_chat_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:matrix/matrix.dart';
import 'package:sentry/sentry.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

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

  static void onFlutterError(
    Object error, [
    StackTrace? stackTrace,
  ]) => WidgetsBinding.instance.addPostFrameCallback((_) {
    if (AppSettings.autoSendErrorReports.value == false) {
      debugPrint('Exception caught but auto send error reports is disabled.');
      return;
    }
    final context =
        FluffyChatApp.router.routerDelegate.navigatorKey.currentContext;

    if (context == null || !context.mounted) {
      debugPrint(
        'Exception caught but we have no mounted BuildContext to display a dialog to the user!',
      );
      debugPrintStack(stackTrace: StackTrace.current);
      return;
    }

    if (AppSettings.autoSendErrorReports.value == true) {
      sendErrorReport(
        message: 'Flutter Error',
        error: error,
        stackTrace: stackTrace,
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
        persist: true,
        content: Column(
          mainAxisSize: .min,
          children: [
            Linkify(
              // TODO: Explain in Privacy Policy
              text: // TODO: Localize
                  'Absturzberichte automatisch mit den Entwicklern teilen? Erfahre mehr auf ${AppSettings.privacyPolicy.value} welche Daten dabei geteilt werden.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onInverseSurface,
              ),
              options: const LinkifyOptions(humanize: false),
              linkStyle: TextStyle(
                decoration: TextDecoration.underline,
                decorationColor: Theme.of(context).colorScheme.primaryContainer,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              onOpen: (url) => launchUrlString(url.url),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    AppSettings.autoSendErrorReports.setItem(true);
                    sendErrorReport(
                      message: 'Flutter Error',
                      error: error,
                      stackTrace: stackTrace,
                    );
                  }, // TODO: Also send to sentry
                  child: Text(
                    'Allow', // TODO: Localize
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    AppSettings.autoSendErrorReports.setItem(false);
                  },
                  child: Text(
                    'Deny', // TODO: Localize
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.errorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  });

  static bool _sentryInitialized = false;

  static Future<void> sendErrorReport({
    required String message,
    required Object error,
    required StackTrace? stackTrace,
    int level = 0,
  }) async {
    final dsn = String.fromEnvironment('sentry_dsn');
    if (dsn.isEmpty) {
      return ErrorReporter(null, message).onErrorCallback(error, stackTrace);
    }
    if (!_sentryInitialized) {
      await Sentry.init((options) => options.dsn = dsn);
      _sentryInitialized = true;
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
            onPressed: () {
              if (String.fromEnvironment('sentry_dsn').isNotEmpty) {
                sendErrorReport(
                  message: message ?? 'Error from Error Reporting Dialog',
                  error: error,
                  stackTrace: stackTrace,
                );
                return;
              }
              launchUrl(
                AppConfig.newIssueUrl.resolveUri(
                  Uri(queryParameters: {'template': 'bug_report.yaml'}),
                ),
                mode: LaunchMode.externalApplication,
              );
            },
            child: Text(L10n.of(context).report),
          ),
        ],
      ),
    );
  }
}
