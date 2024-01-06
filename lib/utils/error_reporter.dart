import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/shades-of-purple.dart';
import 'package:matrix/matrix.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/platform_infos.dart';

class ErrorReporter {
  final BuildContext context;
  final String? message;

  const ErrorReporter(this.context, [this.message]);

  void onErrorCallback(Object error, [StackTrace? stackTrace]) async {
    Logs().e(message ?? 'Error caught', error, stackTrace);
    final text = '$error\n${stackTrace ?? ''}';
    final consent = await showAdaptiveDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: Text(L10n.of(context)!.reportErrorDescription),
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
          TextButton(
            onPressed: () => Navigator.of(context).pop<bool>(false),
            child: Text(L10n.of(context)!.close),
          ),
          TextButton(
            onPressed: () => Clipboard.setData(
              ClipboardData(text: text),
            ),
            child: Text(L10n.of(context)!.copy),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop<bool>(true),
            child: Text(L10n.of(context)!.report),
          ),
        ],
      ),
    );
    if (consent != true) return;
    final os = kIsWeb ? 'web' : Platform.operatingSystem;
    final version = await PlatformInfos.getVersion();
    final description = '''
- Operating system: $os
- Version: $version

### Exception
$error

### StackTrace
${stackTrace?.toString().split('\n').take(10).join('\n')}
''';
    launchUrl(
      AppConfig.newIssueUrl.resolveUri(
        Uri(
          queryParameters: {
            'title': '[BUG]: ${message ?? error.toString()}',
            'body': description,
          },
        ),
      ),
      mode: LaunchMode.externalApplication,
    );
  }
}
