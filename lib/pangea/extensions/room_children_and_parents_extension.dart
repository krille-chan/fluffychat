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
  Future<void> pangeaSetSpaceChild(
    String roomId, {
    bool? suggested,
  }) async {
    final Room? child = client.getRoomById(roomId);
    if (child == null) return;
    if (child.isSpace) {
      throw NestedSpaceError();
    }

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

  /// The number of child rooms to display for a given space.
  int get spaceChildCount => client.rooms
      .where(
        (r) => spaceChildren.any(
          (child) => r.id == child.roomId && !r.isAnalyticsRoom,
        ),
      )
      .length;
}

class NestedSpaceError extends Error {
  @override
  String toString() => 'Cannot add a space to another space';
}
