part of "pangea_room_extension.dart";

extension RoomSettingsRoomExtension on Room {
  Future<void> _updateRoomCapacity(int newCapacity) =>
      client.setRoomStateWithKey(
        id,
        PangeaEventTypes.capacity,
        '',
        {'capacity': newCapacity},
      );

  int? get _capacity {
    final t = getState(PangeaEventTypes.capacity)?.content['capacity'];
    return t is int ? t : null;
  }

  PangeaRoomRules? get _pangeaRoomRules {
    try {
      final Map<String, dynamic>? content = pangeaRoomRulesStateEvent?.content;
      if (content != null) {
        final PangeaRoomRules roomRules = PangeaRoomRules.fromJson(content);
        return roomRules;
      }
      return null;
    } catch (err, s) {
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: "Error in pangeaRoomRules",
          data: {"room": toJson()},
        ),
      );
      ErrorHandler.logError(
        e: err,
        s: s,
        data: {
          "roomID": id,
        },
      );
      return null;
    }
  }

  PangeaRoomRules? get _firstRules =>
      pangeaRoomRules ??
      firstParentWithState(PangeaEventTypes.rules)?.pangeaRoomRules;

  IconData? get _roomTypeIcon {
    if (membership == Membership.invite) return Icons.add;
    if (isSpace) return Icons.school;
    if (isAnalyticsRoom) return Icons.analytics;
    if (isDirectChat) return Icons.forum;
    return Icons.group;
  }

  Text _nameAndRoomTypeIcon([TextStyle? textStyle]) => Text.rich(
        style: textStyle,
        TextSpan(
          children: [
            WidgetSpan(
              child: Icon(roomTypeIcon),
            ),
            TextSpan(
              text: '  $name',
            ),
          ],
        ),
      );

  BotOptionsModel? get _botOptions {
    if (isSpace) return null;
    final stateEvent = getState(PangeaEventTypes.botOptions);
    if (stateEvent == null) return null;
    return BotOptionsModel.fromJson(stateEvent.content);
  }

  Future<bool> _isSuggested() async {
    final List<Room> spaceParents = client.rooms
        .where(
          (room) =>
              room.isSpace &&
              room.spaceChildren.any(
                (sc) => sc.roomId == id,
              ),
        )
        .toList();

    for (final parent in spaceParents) {
      final suggested = await _isSuggestedInSpace(parent);
      if (!suggested) return false;
    }
    return true;
  }

  Future<void> _setSuggested(bool suggested) async {
    final List<Room> spaceParents = client.rooms
        .where(
          (room) =>
              room.isSpace &&
              room.spaceChildren.any(
                (sc) => sc.roomId == id,
              ),
        )
        .toList();
    for (final parent in spaceParents) {
      await _setSuggestedInSpace(suggested, parent);
    }
  }

  Future<bool> _isSuggestedInSpace(Room space) async {
    try {
      final Map<String, dynamic> resp =
          await client.getRoomStateWithKey(space.id, EventTypes.SpaceChild, id);
      return resp.containsKey('suggested') ? resp['suggested'] as bool : true;
    } catch (err) {
      ErrorHandler.logError(
        e: "Failed to fetch suggestion status of room $id in space ${space.id}",
        s: StackTrace.current,
        data: {
          "spaceID": space.id,
          "roomID": id,
        },
      );
      return true;
    }
  }

  Future<void> _setSuggestedInSpace(bool suggest, Room space) async {
    try {
      await space.pangeaSetSpaceChild(id, suggested: suggest);
    } catch (err) {
      ErrorHandler.logError(
        e: "Failed to set suggestion status of room $id in space ${space.id}",
        s: StackTrace.current,
        data: {
          "spaceID": space.id,
          "roomID": id,
          "suggest": suggest,
        },
      );
      return;
    }
  }
}
