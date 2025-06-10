import 'package:flutter/material.dart';

import 'package:flutter_linkify/flutter_linkify.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/url_launcher.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/adaptive_dialog_action.dart';

enum OkCancelResult { ok, cancel }

Future<OkCancelResult?> showOkCancelAlertDialog({
  required BuildContext context,
  required String title,
  String? message,
  String? okLabel,
  String? cancelLabel,
  bool isDestructive = false,
  bool useRootNavigator = true,
}) =>
    showAdaptiveDialog<OkCancelResult>(
      context: context,
      useRootNavigator: useRootNavigator,
      builder: (context) => AlertDialog.adaptive(
        title: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 256),
          child: Text(title),
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 256),
          child: message == null
              ? null
              : SelectableLinkify(
                  text: message,
                  textScaleFactor: MediaQuery.textScalerOf(context).scale(1),
                  linkStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    decorationColor: Theme.of(context).colorScheme.primary,
                  ),
                  options: const LinkifyOptions(humanize: false),
                  onOpen: (url) => UrlLauncher(context, url.url).launchUrl(),
                ),
        ),
        actions: [
          AdaptiveDialogAction(
            onPressed: () => Navigator.of(context)
                .pop<OkCancelResult>(OkCancelResult.cancel),
            child: Text(cancelLabel ?? L10n.of(context).cancel),
          ),
          AdaptiveDialogAction(
            onPressed: () =>
                Navigator.of(context).pop<OkCancelResult>(OkCancelResult.ok),
            autofocus: true,
            child: Text(
              okLabel ?? L10n.of(context).ok,
              style: isDestructive
                  ? TextStyle(color: Theme.of(context).colorScheme.error)
                  : null,
            ),
          ),
        ],
      ),
    );

Future<OkCancelResult?> showOkAlertDialog({
  required BuildContext context,
  required String title,
  String? message,
  String? okLabel,
  bool useRootNavigator = true,
}) =>
    showAdaptiveDialog<OkCancelResult>(
      context: context,
      useRootNavigator: useRootNavigator,
      builder: (context) => AlertDialog.adaptive(
        title: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 256),
          child: Text(title),
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 256),
          child: message == null
              ? null
              : SelectableLinkify(
                  text: message,
                  textScaleFactor: MediaQuery.textScalerOf(context).scale(1),
                  linkStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    decorationColor: Theme.of(context).colorScheme.primary,
                  ),
                  options: const LinkifyOptions(humanize: false),
                  onOpen: (url) => UrlLauncher(context, url.url).launchUrl(),
                ),
        ),
        actions: [
          AdaptiveDialogAction(
            onPressed: () =>
                Navigator.of(context).pop<OkCancelResult>(OkCancelResult.ok),
            autofocus: true,
            child: Text(okLabel ?? L10n.of(context).close),
          ),
        ],
      ),
    );
