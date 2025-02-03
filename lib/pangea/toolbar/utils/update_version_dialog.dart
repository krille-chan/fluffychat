import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';

Future<bool> showUpdateVersionDialog({
  required Future Function() future,
  required BuildContext context,
}) async {
  try {
    await future();
    return true;
  } catch (err, s) {
    ErrorHandler.logError(
      e: err,
      s: s,
      data: {},
    );
    await showOkAlertDialog(
      context: context,
      title: L10n.of(context).oopsSomethingWentWrong,
      message: L10n.of(context).updatePhoneOS,
      okLabel: L10n.of(context).close,
    );
    return false;
  }
}
