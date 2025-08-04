part of "pangea_room_extension.dart";

extension ChildrenAndParentsRoomExtension on Room {
  List<Room> get pangeaSpaceParents => client.rooms
      .where(
        (r) => r.isSpace,
      )
      .where(
        (space) => space.spaceChildren.any(
          (room) => room.roomId == id,
        ),
      )
      .toList();

  /// Wrapper around call to setSpaceChild with added functionality
  /// to prevent adding one room to multiple spaces, and resets the
  /// subspace's JoinRules and Visibility to defaults.
  Future<void> addToSpace(
    String roomId, {
    bool? suggested,
  }) async {
    final Room? child = client.getRoomById(roomId);
    if (child == null) return;

    for (final Room parent in pangeaSpaceParents) {
      try {
        await parent.removeSpaceChild(roomId);
      } catch (e) {
        ErrorHandler.logError(
          e: e,
          m: 'Failed to remove child from parent',
          data: {
            "roomID": roomId,
            "parentID": parent.id,
          },
        );
      }
    }

    try {
      await _trySetSpaceChild(
        roomId,
        suggested: suggested,
      );
    } catch (err, stack) {
      ErrorHandler.logError(
        e: err,
        s: stack,
        data: {
          "roomID": roomId,
          "childID": child.id,
          "suggested": suggested,
        },
      );
    }
  }

  Future<void> _trySetSpaceChild(
    String roomId, {
    bool? suggested,
    int retries = 0,
  }) async {
    final Room? child = client.getRoomById(roomId);
    if (child == null) return;

    try {
      await setSpaceChild(roomId, suggested: suggested);
    } catch (err) {
      retries++;
      if (retries < 3) {
        await Future.delayed(const Duration(seconds: 1));
        return _trySetSpaceChild(
          roomId,
          suggested: suggested,
          retries: retries,
        );
      } else {
        rethrow;
      }
    }
  }

  /// A map of child suggestion status for a space.
  Map<String, bool> get spaceChildSuggestionStatus {
    if (!isSpace) return {};
    final Map<String, bool> suggestionStatus = {};
    for (final child in spaceChildren) {
      suggestionStatus[child.roomId!] = child.suggested ?? true;
    }
    return suggestionStatus;
  }

  /// The number of child rooms to display for a given space.
  int get spaceChildCount => client.rooms
      .where(
        (r) => spaceChildren.any(
          (child) => r.id == child.roomId && !r.isHiddenRoom,
        ),
      )
      .length;

  Future<void> addSubspace(BuildContext context) async {
    if (!isSpace) return;
    final names = await showTextInputDialog(
      context: context,
      title: L10n.of(context).createNewSpace,
      hintText: L10n.of(context).spaceName,
      minLines: 1,
      maxLines: 1,
      maxLength: 64,
      validator: (text) {
        if (text.isEmpty) {
          return L10n.of(context).pleaseChoose;
        }
        return null;
      },
      okLabel: L10n.of(context).create,
      cancelLabel: L10n.of(context).cancel,
    );
    if (names == null) return;
    await showFutureLoadingDialog(
      context: context,
      future: () async {
        await postLoad();
        final resp = await client.createRoom(
          name: names,
          visibility: RoomDefaults.spaceChildVisibility,
          creationContent: {'type': 'm.space'},
          initialState: [
            RoomDefaults.defaultSpacePowerLevels(client.userID!),
            await client.pangeaJoinRules(
              'knock_restricted',
              allow: [
                {
                  "type": "m.room_membership",
                  "room_id": id,
                }
              ],
            ),
          ],
        );
        await addToSpace(resp);
      },
    );
  }
}
