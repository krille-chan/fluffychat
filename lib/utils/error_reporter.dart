import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/shades-of-purple.dart';
import 'package:http/http.dart' as http;
import 'package:matrix/matrix.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/adaptive_dialog_action.dart';

class ErrorReporter {
  final BuildContext? context;
  final String? message;

  const ErrorReporter(this.context, [this.message]);

  static const Set<Type> ingoredTypes = {
    IOException,
    http.ClientException,
    SocketException,
    TlsException,
    HandshakeException,
  };

  Future<File> _getTemporaryErrorLogFile() async {
    final tempDir = await getTemporaryDirectory();
    return File(path.join(tempDir.path, 'error_log.txt'));
  }

  Future<void> writeToTemporaryErrorLogFile(
    Object error, [
    StackTrace? stackTrace,
  ]) async {
    if (ingoredTypes.contains(error.runtimeType)) return;
    final file = await _getTemporaryErrorLogFile();
    if (await file.exists()) await file.delete();
    await file.writeAsString(
      '[${DateTime.now().toIso8601String()}] $message -  $error\n$stackTrace',
    );
  }

  Future<void> consumeTemporaryErrorLogFile() async {
    final file = await _getTemporaryErrorLogFile();
    if (!(await file.exists())) return;
    final content = await file.readAsString();
    _onErrorCallback(content);
    await file.delete();
  }

  void onErrorCallback(Object error, [StackTrace? stackTrace]) {
    if (ingoredTypes.contains(error.runtimeType)) return;
    Logs().e(message ?? 'Error caught', error, stackTrace);
    final text = '$error\n${stackTrace ?? ''}';
    return _onErrorCallback(text);
  }

  void _onErrorCallback(String text) async {
    await showAdaptiveDialog(
      context: context!,
      builder: (context) => AlertDialog.adaptive(
        title: Text(L10n.of(context).reportErrorDescription),
        content: SizedBox(
          height: 256,
          width: 256,
          child: SingleChildScrollView(
            child: HighlightView(
              text,
              language: 'sh',
              theme: shadesOfPurpleTheme,
            ),
          ),
        ),
        actions: [
          AdaptiveDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(L10n.of(context).close),
          ),
          AdaptiveDialogAction(
            onPressed: () => Clipboard.setData(
              ClipboardData(text: text),
            ),
            child: Text(L10n.of(context).copy),
          ),
          AdaptiveDialogAction(
            onPressed: () => launchUrl(
              AppConfig.newIssueUrl.resolveUri(
                Uri(queryParameters: {'template': 'bug_report.yaml'}),
              ),
              mode: LaunchMode.externalApplication,
            ),
            child: Text(L10n.of(context).report),
          ),
        ],
      ),
    );
  }
}
