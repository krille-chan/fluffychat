import 'dart:typed_data';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/chat/constants/default_power_level.dart';
import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/spaces/constants/space_constants.dart';
import 'package:fluffychat/pangea/spaces/utils/space_code.dart';

extension SpacesClientExtension on Client {
  Future<String> createPangeaSpace({
    required String name,
    Visibility visibility = Visibility.private,
    JoinRules joinRules = JoinRules.public,
    Uint8List? avatar,
    Uri? avatarUrl,
  }) async {
    final joinCode = await SpaceCodeUtil.generateSpaceCode(this);
    final roomId = await createRoom(
      creationContent: {'type': RoomCreationTypes.mSpace},
      visibility: visibility,
      name: name.trim(),
      powerLevelContentOverride: {'events_default': 100},
      initialState: [
        ..._spaceInitialState(
          userID!,
          joinCode,
          joinRules: joinRules,
        ),
        if (avatar != null)
          StateEvent(
            type: EventTypes.RoomAvatar,
            content: {'url': avatarUrl.toString()},
          ),
      ],
    );

    final space = await _waitForRoom(roomId);
    if (space == null) return roomId;

    await _addDefaultSpaceChats(space: space);
    return roomId;
  }

  Future<Room?> _waitForRoom(String roomId) async {
    final room = getRoomById(roomId);
    if (room != null) return room;
    await waitForRoomInSync(roomId, join: true).timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        throw Exception('Timeout fetching room after creation');
      },
    );
    return getRoomById(roomId);
  }

  Future<void> _addDefaultSpaceChats({
    required Room space,
    String introductionsName = "Introductions",
    String announcementsName = "Announcements",
  }) async {
    final introChatFuture = createRoom(
      preset: CreateRoomPreset.publicChat,
      visibility: Visibility.private,
      name: introductionsName,
      roomAliasName:
          "${SpaceConstants.introductionChatAlias}_${space.id.localpart}",
      initialState: [
        // if (avatar != null)
        //   StateEvent(
        //     type: EventTypes.RoomAvatar,
        //     content: {'url': avatarUrl.toString()},
        //   ),
        StateEvent(
          type: EventTypes.RoomPowerLevels,
          stateKey: '',
          content: defaultPowerLevels(userID!),
        ),
      ],
    );

    final announcementsChatFuture = createRoom(
      preset: CreateRoomPreset.publicChat,
      visibility: Visibility.private,
      name: announcementsName,
      roomAliasName:
          "${SpaceConstants.announcementsChatAlias}_${space.id.localpart}",
      initialState: [
        // if (avatar != null)
        //   StateEvent(
        //     type: EventTypes.RoomAvatar,
        //     content: {'url': avatarUrl.toString()},
        //   ),
        StateEvent(
          type: EventTypes.RoomPowerLevels,
          stateKey: '',
          content: restrictedPowerLevels(userID!),
        ),
      ],
    );

    final List<String> roomIds = await Future.wait([
      introChatFuture,
      announcementsChatFuture,
    ]);

    if (roomIds.length != 2) {
      throw Exception('Failed to create default space chats');
    }

    final addIntroChatFuture = space.pangeaSetSpaceChild(
      roomIds[0],
    );

    final addAnnouncementsChatFuture = space.pangeaSetSpaceChild(
      roomIds[1],
    );

    await Future.wait([
      addIntroChatFuture,
      addAnnouncementsChatFuture,
    ]);
  }

  List<StateEvent> _spaceInitialState(
    String userID,
    String joinCode, {
    required JoinRules joinRules,
  }) {
    return [
      StateEvent(
        type: EventTypes.RoomPowerLevels,
        stateKey: '',
        content: defaultSpacePowerLevels(userID),
      ),
      StateEvent(
        type: EventTypes.RoomJoinRules,
        content: {
          ModelKey.joinRule: joinRules.toString().replaceAll('JoinRules.', ''),
          ModelKey.accessCode: joinCode,
        },
      ),
    ];
  }
}
