import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'date_time_extension.dart';

extension PresenceExtension on Presence {
  bool get isUserStatus => presence?.statusMsg?.isNotEmpty ?? false;

  String getLocalizedStatusMessage(BuildContext context) {
    if (presence.statusMsg?.isNotEmpty ?? false) {
      return presence.statusMsg;
    }
    if (presence.lastActiveAgo != null ?? presence.lastActiveAgo != 0) {
      return L10n.of(context).lastActiveAgo(
          DateTime.fromMillisecondsSinceEpoch(presence.lastActiveAgo)
              .localizedTimeShort(context));
    }
    if (presence.currentlyActive) {
      return L10n.of(context).currentlyActive;
    }
    return L10n.of(context).lastSeenLongTimeAgo;
  }
}
