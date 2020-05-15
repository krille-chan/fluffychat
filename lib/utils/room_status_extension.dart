import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:flutter/widgets.dart';

import 'date_time_extension.dart';

extension RoomStatusExtension on Room {
  Presence get directChatPresence => client.presences[directChatMatrixID];

  String getLocalizedStatus(BuildContext context) {
    if (isDirectChat) {
      if (directChatPresence != null) {
        if (directChatPresence.currentlyActive == true) {
          return L10n.of(context).currentlyActive;
        }
        return L10n.of(context)
            .lastActiveAgo(directChatPresence.time.localizedTimeShort(context));
      }
      return L10n.of(context).lastSeenLongTimeAgo;
    }
    return L10n.of(context).countParticipants(mJoinedMemberCount.toString());
  }
}
