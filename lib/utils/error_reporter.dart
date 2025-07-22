import 'package:code_highlight_view/code_highlight_view.dart';
import 'package:code_highlight_view/themes/shades-of-purple.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:matrix/matrix.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/adaptive_dialog_action.dart';

class ErrorReporter {
  final BuildContext context;
  final String? message;

  const ErrorReporter(this.context, [this.message]);

  void onErrorCallback(Object error, [StackTrace? stackTrace]) async {
    Logs().e(message ?? 'Error caught', error, stackTrace);
    final text = '$error\n${stackTrace ?? ''}';
    await showAdaptiveDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: Text(L10n.of(context).reportErrorDescription),
        content: SizedBox(
          height: 256,
          width: 256,
          child: SingleChildScrollView(
            child: CodeHighlightView(
              text,
              language: 'sh',
              theme: shadesOfPurpleTheme,
              textStyle: const TextStyle(
                fontFamily: 'RobotoMono',
                fontSize: 12,
              ),
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
