part of "pangea_room_extension.dart";

extension ChildrenAndParentsRoomExtension on Room {
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
    if (currentRoom.pangeaSpaceParents.isEmpty) {
      return nameSoFar;
    }
    currentRoom = currentRoom.pangeaSpaceParents.first;
    var nameToAdd =
        currentRoom.getLocalizedDisplayname(MatrixLocals(L10n.of(context)!));
    nameToAdd =
        nameToAdd.length <= 10 ? nameToAdd : "${nameToAdd.substring(0, 10)}...";
    nameSoFar = '$nameToAdd > $nameSoFar';
    if (currentRoom.pangeaSpaceParents.isEmpty) {
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
  bool _canAddAsParentOf(Room? child) {
    if (child == null || !child.isSpace) {
      return _canIAddSpaceChild(child);
    }
    if (id == child.id) return false;
    return !child._allSpaceChildRoomIds.contains(id);
  }
}
