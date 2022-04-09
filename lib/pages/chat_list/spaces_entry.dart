import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions.dart/client_stories_extension.dart';
import '../../widgets/matrix.dart';

// This is not necessarily a Space, but an abstract categorization of a room.
// More to the point, it's a selectable entry that *could* be a Space.
// Note that view code is in spaces_bottom_bar.dart because of type-specific UI.
// So only really generic functions (so far, anything ChatList cares about) go here.
// If getRoom returns something non-null, then it gets the avatar and such of a Space.
// Otherwise it gets to look like All Rooms. Future work impending.
abstract class SpacesEntry {
  const SpacesEntry();

  // Gets the (translated) name of this entry.
  String getName(BuildContext context);
  // Gets an icon for this entry (avoided if a space is given)
  Icon getIcon(bool active) => active
      ? const Icon(CupertinoIcons.chat_bubble_2_fill)
      : const Icon(CupertinoIcons.chat_bubble_2);
  // If this is a specific Room, returns the space Room for various purposes.
  Room? getSpace(BuildContext context) => null;
  // Gets a list of rooms - this is done as part of _ChatListViewBodyState to get the full list of rooms visible from this SpacesEntry.
  List<Room> getRooms(BuildContext context);
  // Checks that this entry is still valid.
  bool stillValid(BuildContext context) => true;
  // Returns true if the Stories header should be shown.
  bool shouldShowStoriesHeader(BuildContext context) => false;
}

// Common room validity checks
bool _roomCheckCommon(Room room, BuildContext context) {
  if (room.isSpace && room.membership == Membership.join && !room.isUnread) {
    return false;
  }
  if (room.getState(EventTypes.RoomCreate)?.content.tryGet<String>('type') ==
      ClientStoriesExtension.storiesRoomType) {
    return false;
  }
  return true;
}

bool _roomInsideSpace(Room room, Room space) {
  if (space.spaceChildren.any((child) => child.roomId == room.id)) {
    return true;
  }
  if (room.spaceParents.any((parent) => parent.roomId == space.id)) {
    return true;
  }
  return false;
}

// "All rooms" entry.
class AllRoomsSpacesEntry extends SpacesEntry {
  static final AllRoomsSpacesEntry _value = AllRoomsSpacesEntry._();
  AllRoomsSpacesEntry._();
  factory AllRoomsSpacesEntry() {
    return _value;
  }

  @override
  String getName(BuildContext context) => L10n.of(context)!.allChats;

  @override
  List<Room> getRooms(BuildContext context) {
    return Matrix.of(context)
        .client
        .rooms
        .where((room) => _roomCheckCommon(room, context))
        .toList();
  }

  @override
  bool shouldShowStoriesHeader(BuildContext context) => true;
}

// "Direct Chats" entry.
class DirectChatsSpacesEntry extends SpacesEntry {
  static final DirectChatsSpacesEntry _value = DirectChatsSpacesEntry._();
  DirectChatsSpacesEntry._();
  factory DirectChatsSpacesEntry() {
    return _value;
  }

  @override
  String getName(BuildContext context) => L10n.of(context)!.directChats;

  @override
  List<Room> getRooms(BuildContext context) {
    return Matrix.of(context)
        .client
        .rooms
        .where((room) => room.isDirectChat && _roomCheckCommon(room, context))
        .toList();
  }

  @override
  bool shouldShowStoriesHeader(BuildContext context) => true;
}

// "Groups" entry.
class GroupsSpacesEntry extends SpacesEntry {
  static final GroupsSpacesEntry _value = GroupsSpacesEntry._();
  GroupsSpacesEntry._();
  factory GroupsSpacesEntry() {
    return _value;
  }

  @override
  String getName(BuildContext context) => L10n.of(context)!.groups;

  @override
  Icon getIcon(bool active) =>
      active ? const Icon(Icons.group) : const Icon(Icons.group_outlined);

  @override
  List<Room> getRooms(BuildContext context) {
    final rooms = Matrix.of(context).client.rooms;
    // Needs to match ChatList's definition of a space.
    final spaces = rooms.where((room) => room.isSpace).toList();
    return rooms
        .where((room) =>
            (!room.isDirectChat) &&
            _roomCheckCommon(room, context) &&
            separatedGroup(room, spaces))
        .toList();
  }

  bool separatedGroup(Room room, List<Room> spaces) {
    return !spaces.any((space) => _roomInsideSpace(room, space));
  }
}

// All rooms associated with a specific space.
class SpaceSpacesEntry extends SpacesEntry {
  final Room space;
  const SpaceSpacesEntry(this.space);

  @override
  String getName(BuildContext context) => space.displayname;

  @override
  Room? getSpace(BuildContext context) => space;

  @override
  List<Room> getRooms(BuildContext context) {
    return Matrix.of(context)
        .client
        .rooms
        .where((room) => roomCheck(room, context))
        .toList();
  }

  bool roomCheck(Room room, BuildContext context) {
    if (!_roomCheckCommon(room, context)) {
      return false;
    }
    if (_roomInsideSpace(room, space)) {
      return true;
    }
    if (AppConfig.showDirectChatsInSpaces) {
      if (room.isDirectChat &&
          room.summary.mHeroes != null &&
          room.summary.mHeroes!.any((userId) {
            final user = space.getState(EventTypes.RoomMember, userId)?.asUser;
            return user != null && user.membership == Membership.join;
          })) {
        return true;
      }
    }
    return false;
  }

  @override
  bool stillValid(BuildContext context) =>
      Matrix.of(context).client.getRoomById(space.id) != null;
}

// Produces a "rough equivalence" for maintaining the current spaces index.
bool spacesEntryRoughEquivalence(SpacesEntry a, SpacesEntry b) {
  if ((a is SpaceSpacesEntry) && (b is SpaceSpacesEntry)) {
    return a.space.id == b.space.id;
  }
  return a == b;
}
