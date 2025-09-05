import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';

class RoomDefaults {
  static StateEvent defaultPowerLevels(String userID) => StateEvent(
        type: EventTypes.RoomPowerLevels,
        stateKey: '',
        content: {
          "ban": 50,
          "kick": 50,
          "invite": 50,
          "redact": 50,
          "events": {
            PangeaEventTypes.activityPlan: 0,
            PangeaEventTypes.activityRole: 0,
            PangeaEventTypes.activitySummary: 0,
            "m.room.power_levels": 100,
            "m.room.pinned_events": 50,
          },
          "events_default": 0,
          "state_default": 50,
          "users": {
            userID: 100,
          },
          "users_default": 0,
          "notifications": {
            "room": 50,
          },
        },
      );

  static StateEvent restrictedPowerLevels(String userID) => StateEvent(
        type: EventTypes.RoomPowerLevels,
        stateKey: '',
        content: {
          "ban": 50,
          "kick": 50,
          "invite": 50,
          "redact": 50,
          "events": {
            PangeaEventTypes.activityPlan: 50,
            PangeaEventTypes.activityRole: 0,
            PangeaEventTypes.activitySummary: 0,
            "m.room.power_levels": 100,
            "m.room.pinned_events": 50,
          },
          "events_default": 50,
          "state_default": 50,
          "users": {
            userID: 100,
          },
          "users_default": 0,
          "notifications": {
            "room": 50,
          },
        },
      );

  static StateEvent defaultSpacePowerLevels(
    String userID, {
    int spaceChild = 50,
  }) =>
      StateEvent(
        type: EventTypes.RoomPowerLevels,
        stateKey: '',
        content: {
          "ban": 50,
          "kick": 50,
          "invite": 50,
          "redact": 50,
          "events": {
            PangeaEventTypes.courseUser: 100,
            "m.room.power_levels": 100,
            "m.room.join_rules": 100,
            "m.space.child": spaceChild,
          },
          "events_default": 0,
          "state_default": 50,
          "users": {
            userID: 100,
          },
          "users_default": 0,
          "notifications": {
            "room": 50,
          },
        },
      );

  static Visibility spaceChildVisibility = Visibility.private;
}
