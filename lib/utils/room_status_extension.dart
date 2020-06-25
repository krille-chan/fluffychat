import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:flutter/widgets.dart';

import 'date_time_extension.dart';

extension RoomStatusExtension on Room {
  Presence get directChatPresence => client.presences[directChatMatrixID];

  String getLocalizedStatus(BuildContext context) {
    if (isDirectChat) {
      if (directChatPresence != null &&
          directChatPresence.presence != null &&
          (directChatPresence.presence.lastActiveAgo != null ||
              directChatPresence.presence.currentlyActive != null)) {
        if (directChatPresence.presence.currentlyActive == true) {
          return L10n.of(context).currentlyActive;
        }
        if (directChatPresence.presence.lastActiveAgo == null) {
          return L10n.of(context).lastSeenLongTimeAgo;
        }
        final time = DateTime.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch -
                directChatPresence.presence.lastActiveAgo);
        return L10n.of(context).lastActiveAgo(time.localizedTimeShort(context));
      }
      return L10n.of(context).lastSeenLongTimeAgo;
    }
    return L10n.of(context).countParticipants(mJoinedMemberCount.toString());
  }
}
