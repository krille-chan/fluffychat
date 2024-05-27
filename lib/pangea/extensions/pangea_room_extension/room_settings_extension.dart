part of "pangea_room_extension.dart";

extension PangeaRoom6 on Room {
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
      ErrorHandler.logError(e: err, s: s);
      return null;
    }
  }

  PangeaRoomRules? get _firstRules =>
      pangeaRoomRules ??
      firstParentWithState(PangeaEventTypes.rules)?.pangeaRoomRules;

  IconData? get _roomTypeIcon {
    if (membership == Membership.invite) return Icons.add;
    if (isPangeaClass) return Icons.school;
    if (isExchange) return Icons.connecting_airports;
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
    return BotOptionsModel.fromJson(
      getState(PangeaEventTypes.botOptions)?.content ?? {},
    );
  }

  Future<bool> _suggestedInSpace(Room space) async {
    try {
      final Map<String, dynamic> resp =
          await client.getRoomStateWithKey(space.id, EventTypes.spaceChild, id);
      return resp.containsKey('suggested') ? resp['suggested'] as bool : true;
    } catch (err) {
      ErrorHandler.logError(
        e: "Failed to fetch suggestion status of room $id in space ${space.id}",
        s: StackTrace.current,
      );
      return true;
    }
  }

  Future<void> _setSuggestedInSpace(bool suggest, Room space) async {
    try {
      await space.setSpaceChild(id, suggested: suggest);
    } catch (err) {
      ErrorHandler.logError(
        e: "Failed to set suggestion status of room $id in space ${space.id}",
        s: StackTrace.current,
      );
      return;
    }
  }
}
