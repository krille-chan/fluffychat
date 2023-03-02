import 'package:flutter/widgets.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import '../config/app_config.dart';
import 'date_time_extension.dart';

extension RoomStatusExtension on Room {
  CachedPresence? get directChatPresence =>
      client.presences[directChatMatrixID];

  String getLocalizedStatus(BuildContext context) {
    if (isDirectChat) {
      final directChatPresence = this.directChatPresence;
      if (directChatPresence != null &&
          (directChatPresence.lastActiveTimestamp != null ||
              directChatPresence.currentlyActive != null)) {
        if (directChatPresence.statusMsg?.isNotEmpty ?? false) {
          return directChatPresence.statusMsg!;
        }
        if (directChatPresence.currentlyActive == true) {
          return L10n.of(context)!.currentlyActive;
        }
        if (directChatPresence.lastActiveTimestamp == null) {
          return L10n.of(context)!.lastSeenLongTimeAgo;
        }
        final time = directChatPresence.lastActiveTimestamp!;
        return L10n.of(context)!
            .lastActiveAgo(time.localizedTimeShort(context));
      }
      return L10n.of(context)!.lastSeenLongTimeAgo;
    }
    return L10n.of(context)!
        .countParticipants(summary.mJoinedMemberCount.toString());
  }

  String getLocalizedTypingText(BuildContext context) {
    var typingText = '';
    final typingUsers = this.typingUsers;
    typingUsers.removeWhere((User u) => u.id == client.userID);

    if (AppConfig.hideTypingUsernames) {
      typingText = L10n.of(context)!.isTyping;
      if (typingUsers.first.id != directChatMatrixID) {
        typingText =
            L10n.of(context)!.numUsersTyping(typingUsers.length.toString());
      }
    } else if (typingUsers.length == 1) {
      typingText = L10n.of(context)!.isTyping;
      if (typingUsers.first.id != directChatMatrixID) {
        typingText =
            L10n.of(context)!.userIsTyping(typingUsers.first.calcDisplayname());
      }
    } else if (typingUsers.length == 2) {
      typingText = L10n.of(context)!.userAndUserAreTyping(
        typingUsers.first.calcDisplayname(),
        typingUsers[1].calcDisplayname(),
      );
    } else if (typingUsers.length > 2) {
      typingText = L10n.of(context)!.userAndOthersAreTyping(
        typingUsers.first.calcDisplayname(),
        (typingUsers.length - 1).toString(),
      );
    }
    return typingText;
  }

  List<User> getSeenByUsers(Timeline timeline, {String? eventId}) {
    if (timeline.events.isEmpty) return [];
    eventId ??= timeline.events.first.eventId;

    final lastReceipts = <User>{};
    // now we iterate the timeline events until we hit the first rendered event
    for (final event in timeline.events) {
      lastReceipts.addAll(event.receipts.map((r) => r.user));
      if (event.eventId == eventId) {
        break;
      }
    }
    lastReceipts.removeWhere(
      (user) =>
          user.id == client.userID || user.id == timeline.events.first.senderId,
    );
    return lastReceipts.toList();
  }
}
