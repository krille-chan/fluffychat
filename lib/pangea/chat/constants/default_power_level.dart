Map<String, dynamic> defaultPowerLevels(String userID) => {
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
    };

Map<String, dynamic> restrictedPowerLevels(String userID) => {
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
    };

Map<String, dynamic> defaultSpacePowerLevels(String userID) => {
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
    };
