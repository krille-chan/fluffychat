import 'dart:math';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/chat/constants/default_power_level.dart';
import 'package:fluffychat/pangea/common/constants/model_keys.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/spaces/constants/space_constants.dart';
import 'package:fluffychat/pangea/spaces/utils/space_code.dart';

extension SpacesClientExtension on Client {
  Future<String> createPangeaSpace({
    required String name,
    required String introChatName,
    required String announcementsChatName,
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

    await _addDefaultSpaceChats(
      space: space,
      introductionsName: introChatName,
      announcementsName: announcementsChatName,
    );
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
    Uri? introChatUploadURL;
    Uri? announcementsChatUploadURL;

    try {
      final random = Random();
      final introChatIconURL = SpaceConstants
          .introChatIcons[random.nextInt(SpaceConstants.introChatIcons.length)];
      final announcementsChatIconURL = SpaceConstants.announcementChatIcons[
          random.nextInt(SpaceConstants.announcementChatIcons.length)];

      final introResponse = await http.get(Uri.parse(introChatIconURL));
      final introChatIcon = introResponse.bodyBytes;
      final intoChatIconFilename = Uri.encodeComponent(
        Uri.parse(introChatIconURL).pathSegments.last,
      );
      introChatUploadURL = await uploadContent(
        introChatIcon,
        filename: intoChatIconFilename,
      );

      final announcementsResponse =
          await http.get(Uri.parse(announcementsChatIconURL));
      final announcementsChatIcon = announcementsResponse.bodyBytes;
      final announcementsChatIconFilename = Uri.encodeComponent(
        Uri.parse(announcementsChatIconURL).pathSegments.last,
      );
      announcementsChatUploadURL = await uploadContent(
        announcementsChatIcon,
        filename: announcementsChatIconFilename,
      );
    } catch (e, s) {
      ErrorHandler.logError(
        e: "Failed to upload space chat icons",
        s: s,
        data: {
          "error": e,
          "spaceId": space.id,
        },
      );
    }

    final introChatFuture = createRoom(
      preset: CreateRoomPreset.publicChat,
      visibility: Visibility.private,
      name: introductionsName,
      roomAliasName:
          "${SpaceConstants.introductionChatAlias}_${space.id.localpart}",
      initialState: [
        if (introChatUploadURL != null)
          StateEvent(
            type: EventTypes.RoomAvatar,
            content: {'url': introChatUploadURL.toString()},
          ),
        RoomDefaults.defaultPowerLevels(userID!),
        StateEvent(
          type: EventTypes.RoomJoinRules,
          content: {
            'join_rule': 'knock_restricted',
            'allow': [
              {
                "type": "m.room_membership",
                "room_id": space.id,
              }
            ],
          },
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
        if (announcementsChatUploadURL != null)
          StateEvent(
            type: EventTypes.RoomAvatar,
            content: {'url': announcementsChatUploadURL.toString()},
          ),
        RoomDefaults.restrictedPowerLevels(userID!),
        StateEvent(
          type: EventTypes.RoomJoinRules,
          content: {
            'join_rule': 'knock_restricted',
            'allow': [
              {
                "type": "m.room_membership",
                "room_id": space.id,
              }
            ],
          },
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

    for (final roomId in roomIds) {
      final room = getRoomById(roomId);
      if (room == null) {
        await waitForRoomInSync(roomId, join: true);
      }
    }

    final addIntroChatFuture = space.addToSpace(
      roomIds[0],
    );

    final addAnnouncementsChatFuture = space.addToSpace(
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
      RoomDefaults.defaultSpacePowerLevels(userID),
      StateEvent(
        type: EventTypes.RoomJoinRules,
        content: {
          ModelKey.joinRule: joinRules.toString().replaceAll('JoinRules.', ''),
          ModelKey.accessCode: joinCode,
        },
      ),
    ];
  }

  /// Keep the room's current join rule state event content (except for what's intentionally replaced)
  /// since space's access codes were stored there. Don't want to accidentally remove them.
  Future<void> pangeaSetJoinRules(
    String roomId,
    String joinRule, {
    List<Map<String, dynamic>>? allow,
  }) async {
    final room = getRoomById(roomId);
    if (room == null) {
      throw Exception('Room not found for user ID: $userID');
    }

    final currentJoinRule = room
            .getState(
              EventTypes.RoomJoinRules,
            )
            ?.content ??
        {};

    if (currentJoinRule[ModelKey.joinRule] == joinRule &&
        (currentJoinRule['allow'] == allow)) {
      return; // No change needed
    }

    currentJoinRule[ModelKey.joinRule] = joinRule;
    currentJoinRule['allow'] = allow;

    await setRoomStateWithKey(
      roomId,
      EventTypes.RoomJoinRules,
      '',
      currentJoinRule,
    );
  }

  Future<void> setSpaceChildAccess(String roomId) async {
    await pangeaSetJoinRules(
      roomId,
      'knock_restricted',
      allow: [
        {
          "type": "m.room_membership",
          "room_id": id,
        }
      ],
    );

    await setRoomVisibilityOnDirectory(
      roomId,
      visibility: Visibility.private,
    );
  }

  Future<void> resetSpaceChildAccess(String roomId) async {
    await pangeaSetJoinRules(
      roomId,
      JoinRules.knock.toString().replaceAll('JoinRules.', ''),
    );

    await setRoomVisibilityOnDirectory(
      roomId,
      visibility: Visibility.private,
    );
  }
}
