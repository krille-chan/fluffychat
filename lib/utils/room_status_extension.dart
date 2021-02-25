import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'filtered_timeline_extension.dart';
import '../app_config.dart';
import 'date_time_extension.dart';

extension RoomStatusExtension on Room {
  Presence get directChatPresence => client.presences[directChatMatrixID];

  String getLocalizedStatus(BuildContext context) {
    if (isDirectChat) {
      if (directChatPresence != null &&
          directChatPresence.presence != null &&
          (directChatPresence.presence.lastActiveAgo != null ||
              directChatPresence.presence.currentlyActive != null)) {
        if (directChatPresence.presence.statusMsg?.isNotEmpty ?? false) {
          return directChatPresence.presence.statusMsg;
        }
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

  String getLocalizedTypingText(BuildContext context) {
    var typingText = '';
    var typingUsers = this.typingUsers;
    typingUsers.removeWhere((User u) => u.id == client.userID);

    if (AppConfig.hideTypingUsernames) {
      typingText = L10n.of(context).isTyping;
      if (typingUsers.first.id != directChatMatrixID) {
        typingText =
            L10n.of(context).numUsersTyping(typingUsers.length.toString());
      }
    } else if (typingUsers.length == 1) {
      typingText = L10n.of(context).isTyping;
      if (typingUsers.first.id != directChatMatrixID) {
        typingText =
            L10n.of(context).userIsTyping(typingUsers.first.calcDisplayname());
      }
    } else if (typingUsers.length == 2) {
      typingText = L10n.of(context).userAndUserAreTyping(
          typingUsers.first.calcDisplayname(),
          typingUsers[1].calcDisplayname());
    } else if (typingUsers.length > 2) {
      typingText = L10n.of(context).userAndOthersAreTyping(
          typingUsers.first.calcDisplayname(),
          (typingUsers.length - 1).toString());
    }
    return typingText;
  }

  String getLocalizedSeenByText(
    BuildContext context,
    Timeline timeline,
    List<Event> filteredEvents,
    Set<String> unfolded,
  ) {
    var seenByText = '';
    if (timeline.events.isNotEmpty) {
      final filteredEvents = timeline.getFilteredEvents(unfolded: unfolded);
      final lastReceipts = <User>{};
      // now we iterate the timeline events until we hit the first rendered event
      for (final event in timeline.events) {
        lastReceipts.addAll(event.receipts.map((r) => r.user));
        if (event.eventId == filteredEvents.first.eventId) {
          break;
        }
      }
      lastReceipts.removeWhere((user) =>
          user.id == client.userID || user.id == filteredEvents.first.senderId);
      if (lastReceipts.length == 1) {
        seenByText =
            L10n.of(context).seenByUser(lastReceipts.first.calcDisplayname());
      } else if (lastReceipts.length == 2) {
        seenByText = seenByText = L10n.of(context).seenByUserAndUser(
            lastReceipts.first.calcDisplayname(),
            lastReceipts.last.calcDisplayname());
      } else if (lastReceipts.length > 2) {
        seenByText = L10n.of(context).seenByUserAndCountOthers(
            lastReceipts.first.calcDisplayname(),
            (lastReceipts.length - 1).toString());
      }
    }
    return seenByText;
  }
}
