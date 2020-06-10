import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'date_time_extension.dart';

extension PresenceExtension on Presence {
  String getLocalizedStatusMessage(BuildContext context) {
    if (presence.statusMsg?.isNotEmpty ?? false) {
      return presence.statusMsg;
    }
    return L10n.of(context).lastActiveAgo(
        DateTime.fromMillisecondsSinceEpoch(presence.lastActiveAgo)
            .localizedTimeShort(context));
  }
}
