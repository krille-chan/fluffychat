import 'package:flutter/cupertino.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/matrix_sdk_extensions/matrix_locals.dart';

extension ClientStoriesExtension on Client {
  static const String storiesRoomType = 'msc3588.stories.stories-room';
  static const String storiesBlockListType = 'msc3588.stories.block-list';

  static const int lifeTimeInHours = 24;
  static const int maxPostsPerStory = 20;

  List<User> get contacts => rooms
      .where((room) => room.isDirectChat)
      .map(
        (room) =>
            room.unsafeGetUserFromMemoryOrFallback(room.directChatMatrixID!),
      )
      .toList();

  List<Room> get storiesRooms =>
      rooms.where((room) => room.isStoryRoom).toList();

  Future<List<User>> getUndecidedContactsForStories(Room? storiesRoom) async {
    if (storiesRoom == null) return contacts;
    final invitedContacts =
        (await storiesRoom.requestParticipants()).map((user) => user.id);
    final decidedContacts = storiesBlockList.toSet()..addAll(invitedContacts);
    return contacts
        .where((contact) => !decidedContacts.contains(contact.id))
        .toList();
  }

  List<String> get storiesBlockList =>
      accountData[storiesBlockListType]?.content.tryGetList<String>('users') ??
      [];

  Future<void> setStoriesBlockList(List<String> users) => setAccountData(
        userID!,
        storiesBlockListType,
        {'users': users},
      );

  Future<Room> createStoriesRoom([List<String>? invite]) async {
    final roomId = await createRoom(
      creationContent: {"type": "msc3588.stories.stories-room"},
      preset: CreateRoomPreset.privateChat,
      powerLevelContentOverride: {"events_default": 100},
      name: 'Stories from ${userID!.localpart}',
      topic:
          'This is a room for stories sharing, not unlike the similarly named features in other messaging networks. For best experience please use FluffyChat or minesTrix. Feature development can be followed on: https://github.com/matrix-org/matrix-doc/pull/3588',
      initialState: [
        StateEvent(
          type: EventTypes.Encryption,
          stateKey: '',
          content: {
            'algorithm': 'm.megolm.v1.aes-sha2',
          },
        ),
        StateEvent(
          type: 'm.room.retention',
          stateKey: '',
          content: {
            'min_lifetime': 86400000,
            'max_lifetime': 86400000,
          },
        ),
      ],
      invite: invite,
    );
    if (getRoomById(roomId) == null) {
      // Wait for room actually appears in sync
      await onSync.stream
          .firstWhere((sync) => sync.rooms?.join?.containsKey(roomId) ?? false);
    }
    return getRoomById(roomId)!;
  }

  Future<Room?> getStoriesRoom(BuildContext context) async {
    final candidates = rooms.where(
      (room) =>
          room
                  .getState(EventTypes.RoomCreate)
                  ?.content
                  .tryGet<String>('type') ==
              storiesRoomType &&
          room.ownPowerLevel >= 100,
    );
    if (candidates.isEmpty) return null;
    if (candidates.length == 1) return candidates.single;
    return await showModalActionSheet<Room>(
      context: context,
      actions: candidates
          .map(
            (room) => SheetAction(
              label: room.getLocalizedDisplayname(
                MatrixLocals(L10n.of(context)!),
              ),
              key: room,
            ),
          )
          .toList(),
    );
  }
}

extension StoryRoom on Room {
  bool get isStoryRoom =>
      getState(EventTypes.RoomCreate)?.content.tryGet<String>('type') ==
      ClientStoriesExtension.storiesRoomType;
}
