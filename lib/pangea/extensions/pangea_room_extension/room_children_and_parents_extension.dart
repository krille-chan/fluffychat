part of "pangea_room_extension.dart";

extension ChildrenAndParentsRoomExtension on Room {
  bool get _isSubspace => _pangeaSpaceParents.isNotEmpty;

  //note this only will return rooms that the user has joined or been invited to
  List<Room> get _joinedChildren {
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

  List<String> get _joinedChildrenRoomIds =>
      joinedChildren.map((child) => child.id).toList();

  Future<List<Room>> _getChildRooms() async {
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

  Future<void> _joinSpaceChild(String roomID) async {
    final Room? child = client.getRoomById(roomID);
    if (child == null) {
      await client.joinRoom(
        roomID,
        serverName: spaceChildren
            .firstWhereOrNull((child) => child.roomId == roomID)
            ?.via,
      );
      if (client.getRoomById(roomID) == null) {
        await client.waitForRoomInSync(roomID, join: true);
      }
      return;
    }

    if (![Membership.invite, Membership.join].contains(child.membership)) {
      final waitForRoom = client.waitForRoomInSync(
        roomID,
        join: true,
      );
      await child.join();
      await waitForRoom;
    }
  }

  //resolve somehow if multiple rooms have the state?
  //check logic
  Room? _firstParentWithState(String stateType) {
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

  List<Room> get _pangeaSpaceParents => client.rooms
      .where(
        (r) => r.isSpace,
      )
      .where(
        (space) => space.spaceChildren.any(
          (room) => room.roomId == id,
        ),
      )
      .toList();

  String _nameIncludingParents(BuildContext context) {
    String nameSoFar = getLocalizedDisplayname(MatrixLocals(L10n.of(context)!));
    Room currentRoom = this;
    if (!currentRoom._isSubspace) {
      return nameSoFar;
    }
    currentRoom = currentRoom.pangeaSpaceParents.first;
    var nameToAdd =
        currentRoom.getLocalizedDisplayname(MatrixLocals(L10n.of(context)!));
    nameToAdd =
        nameToAdd.length <= 10 ? nameToAdd : "${nameToAdd.substring(0, 10)}...";
    nameSoFar = '$nameToAdd > $nameSoFar';
    if (!currentRoom._isSubspace) {
      return nameSoFar;
    }
    return "... > $nameSoFar";
  }

  // gets all space children of a given space, down the
  // space tree.
  List<String> get _allSpaceChildRoomIds {
    final List<String> childIds = [];
    for (final child in spaceChildren) {
      if (child.roomId == null) continue;
      childIds.add(child.roomId!);
      final Room? room = client.getRoomById(child.roomId!);
      if (room != null && room.isSpace) {
        childIds.addAll(room._allSpaceChildRoomIds);
      }
    }
    return childIds;
  }

  // Checks if has permissions to add child chat
  // Or whether potential child space is ancestor of this
  bool _canAddAsParentOf(Room? child, {bool spaceMode = false}) {
    // don't add a room to itself
    if (id == child?.id) return false;
    spaceMode = child?.isSpace ?? spaceMode;

    // get the bool for adding chats to spaces
    final bool canAddChild =
        (child?.isRoomAdmin ?? true) && canSendEvent(EventTypes.SpaceChild);
    if (!spaceMode) return canAddChild;

    // if adding space to a space, check if the child is an ancestor
    // to prevent cycles
    final bool isCycle =
        child != null ? child._allSpaceChildRoomIds.contains(id) : false;
    return canAddChild && !isCycle;
  }

  /// Wrapper around call to setSpaceChild with added functionality
  /// to prevent adding one room to multiple spaces
  Future<void> _pangeaSetSpaceChild(
    String roomId, {
    bool? suggested,
  }) async {
    final Room? child = client.getRoomById(roomId);
    if (child != null) {
      final List<Room> spaceParents = child.pangeaSpaceParents;
      for (final Room parent in spaceParents) {
        try {
          await parent.removeSpaceChild(roomId);
        } catch (e) {
          ErrorHandler.logError(
            e: e,
            m: 'Failed to remove child from parent',
          );
        }
      }
      await setSpaceChild(roomId, suggested: suggested);
    }
  }

  /// A map of child suggestion status for a space.
  Map<String, bool> get _spaceChildSuggestionStatus {
    if (!isSpace) return {};
    final Map<String, bool> suggestionStatus = {};
    for (final child in spaceChildren) {
      suggestionStatus[child.roomId!] = child.suggested ?? true;
    }
    return suggestionStatus;
  }
}
