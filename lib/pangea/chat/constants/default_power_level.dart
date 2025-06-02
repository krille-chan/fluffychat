import 'package:matrix/matrix.dart';

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

  static StateEvent defaultSpacePowerLevels(String userID) => StateEvent(
        type: EventTypes.RoomPowerLevels,
        stateKey: '',
        content: {
          "ban": 50,
          "kick": 50,
          "invite": 50,
          "redact": 50,
          "events": {
            "m.room.power_levels": 100,
            "m.room.join_rules": 100,
            "m.space.child": 50,
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
