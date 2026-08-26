// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/adaptive_dialog_action.dart';
import 'package:fluffychat/widgets/fluffy_chat_app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:material_ui/material_ui.dart';
import 'package:matrix/matrix.dart';
import 'package:universal_html/universal_html.dart' as html;
import 'package:url_launcher/url_launcher.dart';

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

  static void onFlutterError(Object error, [StackTrace? stackTrace]) {
    if (AppSettings.autoSendErrorReports.value != true) {
      debugPrint('Exception caught but auto send crash reports is disabled.');
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
      return;
    }
    final hash = (stackTrace ?? error).hashCode.toString();
    if (AppSettings.knownErrorHashes.value.contains(hash)) return;
    AppSettings.knownErrorHashes.setItem([
      ...AppSettings.knownErrorHashes.value,
      hash,
    ]);
    ErrorReporter(null, 'Flutter error').onErrorCallback(error, stackTrace);
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
            onPressed: () async {
              final existingIssueUrl = stackTrace == null
                  ? null
                  : await _searchIssue(
                      (error.toString() + stackTrace.toString()).hashCode
                          .toString(),
                    );
              if (existingIssueUrl != null) {
                launchUrl(existingIssueUrl);
                return;
              }
              launchUrl(
                AppConfig.newIssueUrl.resolveUri(
                  Uri(
                    queryParameters: {
                      'template': 'bug_report.yml',
                      'title':
                          '[Error ${stackTrace.hashCode}] ${message ?? error}',
                      'bug-description': error.toString(),
                      'stacktrace': stackTrace?.toString(),
                      'app-version': await PlatformInfos.getVersion(),
                      'platform': switch (defaultTargetPlatform) {
                        TargetPlatform.android => 'Android',
                        TargetPlatform.fuchsia => 'Other',
                        TargetPlatform.iOS => 'iOS',
                        TargetPlatform.linux => 'Linux',
                        TargetPlatform.macOS => 'macOS (Self-compiled)',
                        TargetPlatform.windows => 'Windows (Self-compiled)',
                      },
                      'platform-info': kIsWeb
                          ? html.window.navigator.userAgent
                          : jsonEncode(
                              (await DeviceInfoPlugin().deviceInfo).data,
                            ),
                    },
                  ),
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

  Future<Uri?> _searchIssue(String hash) async {
    final result = await http.get(
      Uri(
        scheme: 'https',
        host: 'api.github.com',
        path: '/search/issues',
        query: 'q=repo:krille-chan/fluffychat+is:issue+$hash',
      ),
    );
    try {
      final jsonResult =
          jsonDecode(utf8.decode(result.bodyBytes)) as Map<String, Object?>;
      final uriString = jsonResult
          .tryGetList<Map<String, Object?>>('items')
          ?.firstOrNull
          ?.tryGet<String>('html_url');
      if (uriString == null) return null;
      return Uri.tryParse(uriString);
    } catch (e, s) {
      Logs().w('Unable to search for existing issues on GitHub', e, s);
      return null;
    }
  }
}
