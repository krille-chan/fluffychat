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

  List<SpaceChild> get _childrenAndGrandChildren {
    if (!isSpace) return [];
    final List<SpaceChild> kids = [];
    for (final child in spaceChildren) {
      kids.add(child);
      if (child.roomId != null) {
        final Room? childRoom = client.getRoomById(child.roomId!);
        if (childRoom != null && childRoom.isSpace) {
          kids.addAll(childRoom.spaceChildren);
        }
      }
    }
    return kids.where((element) => element.roomId != null).toList();
  }

  //this assumes that a user has been invited to all group chats in a space
  //it is a janky workaround for determining whether a spacechild is a direct chat
  //since the spaceChild object doesn't contain this info. this info is only accessible
  //when the user has joined or been invited to the room. direct chats included in
  //a space show up in spaceChildren but the user has not been invited to them.
  List<String> get _childrenAndGrandChildrenDirectChatIds {
    final List<String> nonDirectChatRoomIds = childrenAndGrandChildren
        .where((child) => child.roomId != null)
        .map((e) => client.getRoomById(e.roomId!))
        .where((r) => r != null && !r.isDirectChat)
        .map((e) => e!.id)
        .toList();

    return childrenAndGrandChildren
        .where(
          (child) =>
              child.roomId != null &&
              !nonDirectChatRoomIds.contains(child.roomId),
        )
        .map((e) => e.roomId)
        .cast<String>()
        .toList();

    // return childrenAndGrandChildren
    //     .where((element) => element.roomId != null)
    //     .where(
    //       (child) {
    //         final room = client.getRoomById(child.roomId!);
    //         return room == null || room.isDirectChat;
    //       },
    //     )
    //     .map((e) => e.roomId)
    //     .cast<String>()
    //     .toList();
  }

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
    if (![PangeaEventTypes.classSettings, PangeaEventTypes.rules]
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

  /// find any parents and return the rooms
  List<Room> get _immediateClassParents => pangeaSpaceParents
      .where(
        (element) => element.isPangeaClass,
      )
      .toList();

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
    if (currentRoom.immediateClassParents.isEmpty) {
      return nameSoFar;
    }
    currentRoom = currentRoom.immediateClassParents.first;
    var nameToAdd =
        currentRoom.getLocalizedDisplayname(MatrixLocals(L10n.of(context)!));
    nameToAdd =
        nameToAdd.length <= 10 ? nameToAdd : "${nameToAdd.substring(0, 10)}...";
    nameSoFar = '$nameToAdd > $nameSoFar';
    if (currentRoom.immediateClassParents.isEmpty) {
      return nameSoFar;
    }
    return "... > $nameSoFar";
  }
}
