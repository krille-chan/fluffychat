import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';

class ErrorReporter {
  final BuildContext context;
  final String? message;

  const ErrorReporter(this.context, [this.message]);

  void onErrorCallback(Object error, [StackTrace? stackTrace]) async {
    Logs().e(message ?? 'Error caught', error, stackTrace);
    final consent = await showOkCancelAlertDialog(
      context: context,
      title: error.toLocalizedString(context),
      message: L10n.of(context)!.reportErrorDescription,
      okLabel: L10n.of(context)!.report,
      cancelLabel: L10n.of(context)!.close,
    );
    if (consent != OkCancelResult.ok) return;
    final os = kIsWeb ? 'web' : Platform.operatingSystem;
    final version = await PlatformInfos.getVersion();
    final description = '''
- Operating system: $os
- Version: $version

### Exception
$error

### StackTrace
$stackTrace
''';
    launchUrl(
      AppConfig.newIssueUrl.resolveUri(
        Uri(
          queryParameters: {
            'issue[title]': '[BUG]: ${message ?? error.toString()}',
            'issue[description]': description,
          },
        ),
      ),
      mode: LaunchMode.externalApplication,
    );
  }
}
