part of "pangea_room_extension.dart";

extension RoomSettingsRoomExtension on Room {
  Future<void> updateRoomCapacity(int newCapacity) =>
      client.setRoomStateWithKey(
        id,
        PangeaEventTypes.capacity,
        '',
        {'capacity': newCapacity},
      );

  int? get capacity {
    final t = getState(PangeaEventTypes.capacity)?.content['capacity'];
    return t is int ? t : null;
  }

  IconData? get roomTypeIcon {
    if (membership == Membership.invite) return Icons.add;
    if (isSpace) return Icons.school;
    if (isAnalyticsRoom) return Icons.analytics;
    if (isDirectChat) return Icons.forum;
    return Icons.group;
  }

  Text nameAndRoomTypeIcon([TextStyle? textStyle]) => Text.rich(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
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

  BotOptionsModel? get botOptions {
    if (isSpace) return null;
    final stateEvent = getState(PangeaEventTypes.botOptions);
    if (stateEvent == null) return null;
    return BotOptionsModel.fromJson(stateEvent.content);
  }

  ActivityPlanModel? get activityPlan {
    final stateEvent = getState(PangeaEventTypes.activityPlan);
    if (stateEvent == null) return null;

    try {
      return ActivityPlanModel.fromJson(stateEvent.content);
    } catch (e, s) {
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "roomID": id,
          "stateEvent": stateEvent.content,
        },
      );
      return null;
    }
  }
}
