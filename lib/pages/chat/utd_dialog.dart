// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/chat/event_info_dialog.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/adaptive_dialog_action.dart';
import 'package:fluffychat/widgets/bidi/material.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';

class UtdDialog extends StatelessWidget {
  final Event event;
  const UtdDialog(this.event, {super.key});

  static Future<void> show(BuildContext context, Event event) async {
    event.requestKey();
    final action = await showAdaptiveDialog<_UtdDialogAction>(
      barrierDismissible: true,
      context: context,
      builder: (_) => UtdDialog(event),
    );
    if (action == null) return;
    if (!context.mounted) return;

    switch (action) {
      case _UtdDialogAction.info:
        event.showInfoDialog(context);
      case _UtdDialogAction.redact:
        await showFutureLoadingDialog(
          context: context,
          future: () => event.redactEvent(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(L10n.of(context).whyIsThisMessageEncrypted),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 200),
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            child: SelectableText(
              event.calcLocalizedBodyFallback(MatrixLocals(L10n.of(context))),
            ),
          ),
        ),
      ),
      actions: [
        AdaptiveDialogAction(
          onPressed: () => Navigator.of(context).pop(_UtdDialogAction.info),
          child: Text(L10n.of(context).messageInfo),
        ),
        if (event.canRedact)
          AdaptiveDialogAction(
            onPressed: () => Navigator.of(context).pop(_UtdDialogAction.redact),
            child: Text(
              L10n.of(context).redactMessage,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        AdaptiveDialogAction(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(L10n.of(context).close),
        ),
      ],
    );
  }
}

enum _UtdDialogAction { info, redact }
