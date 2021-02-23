import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'date_time_extension.dart';

extension PresenceExtension on Presence {
  String getLocalizedLastActiveAgo(BuildContext context) {
    if (presence.lastActiveAgo != null && presence.lastActiveAgo != 0) {
      return L10n.of(context).lastActiveAgo(DateTime.fromMillisecondsSinceEpoch(
              DateTime.now().millisecondsSinceEpoch - presence.lastActiveAgo)
          .localizedTimeShort(context));
    }
    return L10n.of(context).lastSeenLongTimeAgo;
  }

  String getLocalizedStatusMessage(BuildContext context) {
    if (presence.statusMsg?.isNotEmpty ?? false) {
      return presence.statusMsg;
    }
    if (presence.currentlyActive ?? false) {
      return L10n.of(context).currentlyActive;
    }
    return getLocalizedLastActiveAgo(context);
  }

  Color get color {
    switch (presence?.presence ?? PresenceType.offline) {
      case PresenceType.online:
        return Colors.green;
      case PresenceType.offline:
        return Colors.red;
      case PresenceType.unavailable:
      default:
        return Colors.grey;
    }
  }
}
