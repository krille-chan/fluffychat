part of "pangea_room_extension.dart";

extension ChildrenAndParentsRoomExtension on Room {
  //note this only will return rooms that the user has joined or been invited to
  List<Room> get joinedChildren {
    if (!isSpace) return [];
    return spaceChildren
        .where((child) => child.roomId != null)
        .map(
          (child) => client.getRoomById(child.roomId!),
        )
        .where((child) => child != null)
        .cast<Room>()
        .where(
          (child) => child.membership == Membership.join,
        )
        .toList();
  }

  Future<List<Room>> getChildRooms() async {
    final List<Room> children = [];
    for (final child in spaceChildren) {
      if (child.roomId == null) continue;
      final Room? room = client.getRoomById(child.roomId!);
      if (room != null) {
        children.add(room);
      }
    }
    return children;
  }

  //resolve somehow if multiple rooms have the state?
  //check logic
  Room? firstParentWithState(String stateType) {
    if (![PangeaEventTypes.languageSettings, PangeaEventTypes.rules]
        .contains(stateType)) {
      return null;
    }

    for (final parent in pangeaSpaceParents) {
      if (parent.getState(stateType) != null) {
        return parent;
      }
    }
    for (final parent in pangeaSpaceParents) {
      final parentFirstRoom = parent.firstParentWithState(stateType);
      if (parentFirstRoom != null) return parentFirstRoom;
    }
    return null;
  }

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
  Future<void> pangeaSetSpaceChild(
    String roomId, {
    bool? suggested,
  }) async {
    final Room? child = client.getRoomById(roomId);
    if (child == null) return;
    if (child.isSpace) {
      throw NestedSpaceError();
    }

    final List<Room> spaceParents =
        ChildrenAndParentsRoomExtension(child).pangeaSpaceParents;
    for (final Room parent in spaceParents) {
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
      await setSpaceChild(roomId, suggested: suggested);
      await child.setJoinRules(JoinRules.public);
      await child.client.setRoomVisibilityOnDirectory(
        roomId,
        visibility: matrix.Visibility.private,
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

  /// A map of child suggestion status for a space.
  Map<String, bool> get spaceChildSuggestionStatus {
    if (!isSpace) return {};
    final Map<String, bool> suggestionStatus = {};
    for (final child in spaceChildren) {
      suggestionStatus[child.roomId!] = child.suggested ?? true;
    }
    return suggestionStatus;
  }
}

class NestedSpaceError extends Error {
  @override
  String toString() => 'Cannot add a space to another space';
}
