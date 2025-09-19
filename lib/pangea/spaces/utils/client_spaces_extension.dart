import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/chat/constants/default_power_level.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/extensions/join_rule_extension.dart';
import 'package:fluffychat/pangea/extensions/pangea_room_extension.dart';
import 'package:fluffychat/pangea/spaces/constants/space_constants.dart';

extension SpacesClientExtension on Client {
  Future<String> createPangeaSpace({
    required String name,
    required String introChatName,
    required String announcementsChatName,
    String? topic,
    Visibility visibility = Visibility.private,
    JoinRules joinRules = JoinRules.public,
    String? avatarUrl,
    List<StateEvent>? initialState,
    int spaceChild = 50,
  }) async {
    final roomId = await createRoom(
      creationContent: {'type': RoomCreationTypes.mSpace},
      visibility: visibility,
      name: name.trim(),
      topic: topic?.trim(),
      powerLevelContentOverride: {'events_default': 100},
      initialState: [
        RoomDefaults.defaultSpacePowerLevels(
          userID!,
          spaceChild: spaceChild,
        ),
        await pangeaJoinRules(
          joinRules.toString().replaceAll('JoinRules.', ''),
        ),
        if (avatarUrl != null)
          StateEvent(
            type: EventTypes.RoomAvatar,
            content: {'url': avatarUrl},
          ),
        if (initialState != null) ...initialState,
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
        await pangeaJoinRules(
          'knock_restricted',
          allow: [
            {
              "type": "m.room_membership",
              "room_id": space.id,
            }
          ],
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
        await pangeaJoinRules(
          'knock_restricted',
          allow: [
            {
              "type": "m.room_membership",
              "room_id": space.id,
            }
          ],
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
}
