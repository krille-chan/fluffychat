import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/join_codes/knock_room_extension.dart';

/// Returns true when a push notification event is an accepted-knock invite —
/// i.e. an m.room.member invite targeting the current user in a room the user
/// previously knocked on.
///
/// Extracted as a pure function so it can be unit-tested without a Flutter
/// environment or a live Matrix client.
bool isKnockAcceptedInvite({
  required String eventType,
  required String? newMembership,
  required String? stateKey,
  required String? currentUserId,
  required bool hasKnocked,
}) {
  return eventType == EventTypes.RoomMember &&
      newMembership == 'invite' &&
      stateKey == currentUserId &&
      hasKnocked;
}

/// Convenience wrapper that reads [KnockTracker] state from a live [Client].
bool isKnockAcceptedInviteForClient({
  required Event event,
  required Client client,
}) {
  return isKnockAcceptedInvite(
    eventType: event.type,
    newMembership: event.content.tryGet<String>('membership'),
    stateKey: event.stateKey,
    currentUserId: client.userID,
    hasKnocked: client.hasEverKnockedRoom(event.room.id),
  );
}
