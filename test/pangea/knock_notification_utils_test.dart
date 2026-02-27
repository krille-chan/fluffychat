import 'package:flutter_test/flutter_test.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/join_codes/knock_notification_utils.dart';
import 'package:fluffychat/pangea/join_codes/knocked_rooms_model.dart';

void main() {
  const roomId = '!course:staging.pangea.chat';
  const userId = '@learner:staging.pangea.chat';
  const adminId = '@teacher:staging.pangea.chat';

  group('isKnockAcceptedInvite', () {
    test('returns true when all conditions match a knock-accepted invite', () {
      final model = KnockedRoomsModel(
        knockedRoomIds: [roomId],
        acceptedInviteRoomIds: [],
      );
      final result = isKnockAcceptedInvite(
        eventType: EventTypes.RoomMember,
        newMembership: 'invite',
        stateKey: userId,
        currentUserId: userId,
        hasKnocked: model.hasEverKnocked(roomId),
      );
      expect(result, isTrue);
    });

    test('returns false when event is not m.room.member', () {
      final model = KnockedRoomsModel(
        knockedRoomIds: [roomId],
        acceptedInviteRoomIds: [],
      );
      final result = isKnockAcceptedInvite(
        eventType: 'm.room.message',
        newMembership: 'invite',
        stateKey: userId,
        currentUserId: userId,
        hasKnocked: model.hasEverKnocked(roomId),
      );
      expect(result, isFalse);
    });

    test('returns false when membership is not invite (e.g. join)', () {
      final model = KnockedRoomsModel(
        knockedRoomIds: [roomId],
        acceptedInviteRoomIds: [],
      );
      final result = isKnockAcceptedInvite(
        eventType: EventTypes.RoomMember,
        newMembership: 'join',
        stateKey: userId,
        currentUserId: userId,
        hasKnocked: model.hasEverKnocked(roomId),
      );
      expect(result, isFalse);
    });

    test('returns false when membership is null', () {
      final model = KnockedRoomsModel(
        knockedRoomIds: [roomId],
        acceptedInviteRoomIds: [],
      );
      final result = isKnockAcceptedInvite(
        eventType: EventTypes.RoomMember,
        newMembership: null,
        stateKey: userId,
        currentUserId: userId,
        hasKnocked: model.hasEverKnocked(roomId),
      );
      expect(result, isFalse);
    });

    test(
      'returns false when invite targets a different user (not current user)',
      () {
        final model = KnockedRoomsModel(
          knockedRoomIds: [roomId],
          acceptedInviteRoomIds: [],
        );
        final result = isKnockAcceptedInvite(
          eventType: EventTypes.RoomMember,
          newMembership: 'invite',
          stateKey: adminId, // <-- someone else was invited
          currentUserId: userId,
          hasKnocked: model.hasEverKnocked(roomId),
        );
        expect(result, isFalse);
      },
    );

    test('returns false when stateKey is null', () {
      final model = KnockedRoomsModel(
        knockedRoomIds: [roomId],
        acceptedInviteRoomIds: [],
      );
      final result = isKnockAcceptedInvite(
        eventType: EventTypes.RoomMember,
        newMembership: 'invite',
        stateKey: null,
        currentUserId: userId,
        hasKnocked: model.hasEverKnocked(roomId),
      );
      expect(result, isFalse);
    });

    test('returns false when the room was not previously knocked on', () {
      final model = KnockedRoomsModel(
        knockedRoomIds: [], // <-- no prior knock recorded
        acceptedInviteRoomIds: [],
      );
      final result = isKnockAcceptedInvite(
        eventType: EventTypes.RoomMember,
        newMembership: 'invite',
        stateKey: userId,
        currentUserId: userId,
        hasKnocked: model.hasEverKnocked(roomId),
      );
      expect(result, isFalse);
    });

    test('returns false when a different room was knocked', () {
      final model = KnockedRoomsModel(
        knockedRoomIds: ['!other:staging.pangea.chat'],
        acceptedInviteRoomIds: [],
      );
      final result = isKnockAcceptedInvite(
        eventType: EventTypes.RoomMember,
        newMembership: 'invite',
        stateKey: userId,
        currentUserId: userId,
        hasKnocked: model.hasEverKnocked(roomId),
      );
      expect(result, isFalse);
    });

    test('handles multiple knocked rooms and matches the correct one', () {
      final model = KnockedRoomsModel(
        knockedRoomIds: [
          '!other1:staging.pangea.chat',
          roomId,
          '!other2:staging.pangea.chat',
        ],
        acceptedInviteRoomIds: [],
      );
      final result = isKnockAcceptedInvite(
        eventType: EventTypes.RoomMember,
        newMembership: 'invite',
        stateKey: userId,
        currentUserId: userId,
        hasKnocked: model.hasEverKnocked(roomId),
      );
      expect(result, isTrue);
    });
  });
}
