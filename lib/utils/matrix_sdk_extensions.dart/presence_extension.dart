import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import '../date_time_extension.dart';

extension PresenceExtension on CachedPresence {
  String getLocalizedLastActiveAgo(BuildContext context) {
    final lastActiveTimestamp = this.lastActiveTimestamp;
    if (lastActiveTimestamp != null) {
      return L10n.of(context)!
          .lastActiveAgo(lastActiveTimestamp.localizedTimeShort(context));
    }
    return L10n.of(context)!.lastSeenLongTimeAgo;
  }

  String getLocalizedStatusMessage(BuildContext context) {
    final statusMsg = this.statusMsg;
    if (statusMsg != null && statusMsg.isNotEmpty) {
      return statusMsg;
    }
    if (currentlyActive ?? false) {
      return L10n.of(context)!.currentlyActive;
    }
    return getLocalizedLastActiveAgo(context);
  }

  Color get color {
    switch (presence) {
      case PresenceType.online:
        return Colors.green;
      case PresenceType.offline:
        return Colors.grey;
      case PresenceType.unavailable:
      default:
        return Colors.red;
    }
  }
}
