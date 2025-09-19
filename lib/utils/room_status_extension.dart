import 'package:flutter/widgets.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import '../config/app_config.dart';

extension RoomStatusExtension on Room {
  String getLocalizedTypingText(BuildContext context) {
    var typingText = '';
    final typingUsers = this.typingUsers;
    typingUsers.removeWhere((User u) => u.id == client.userID);

    if (AppConfig.hideTypingUsernames) {
      typingText = L10n.of(context).isTyping;
      if (typingUsers.first.id != directChatMatrixID) {
        typingText = L10n.of(context).numUsersTyping(typingUsers.length);
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
        typingUsers[1].calcDisplayname(),
      );
    } else if (typingUsers.length > 2) {
      typingText = L10n.of(context).userAndOthersAreTyping(
        typingUsers.first.calcDisplayname(),
        (typingUsers.length - 1),
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

  /// Gets the category of this room based on its tags
  String get tagCategory {
    // Use existing Matrix SDK functionality for favorites
    if (isFavourite) return 'favourite';

    // Check for low priority tag stored in account data
    try {
      final accountData = client.accountData['m.lowpriority.$id'];
      if (accountData?.content['lowpriority'] == true) return 'lowpriority';
    } catch (e) {
      // Ignore errors when reading account data
    }

    return 'normal';
  }

  /// Toggles favorite status and clears low priority if favorited
  Future<void> toggleFavorite() async {
    final willBeFavorite = !isFavourite;
    await setFavourite(willBeFavorite);
    if (willBeFavorite) {
      await setLowPriority(false);
    }
  }

  /// Sets or removes the low priority flag for this room
  Future<void> setLowPriority(bool isLowPriority) async {
    final key = 'm.lowpriority.$id';
    if (isLowPriority) {
      await setFavourite(false); // Clear favorite when setting low priority
      await client.setAccountData(client.userID!, key, {'lowpriority': true});
    } else {
      await client.setAccountData(client.userID!, key, {});
    }
  }

  /// Checks if this room has the low priority tag
  bool get isTaggedLowPriority {
    try {
      final accountData = client.accountData['m.lowpriority.$id'];
      return accountData?.content['lowpriority'] == true;
    } catch (e) {
      return false;
    }
  }
}
