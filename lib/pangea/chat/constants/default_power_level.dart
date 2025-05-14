Map<String, dynamic> defaultPowerLevels(String userID) => {
      "events": {
        "m.room.avatar": 50,
        "m.room.canonical_alias": 50,
        "m.room.encryption": 100,
        "m.room.history_visibility": 100,
        "m.room.name": 50,
        "m.room.power_levels": 100,
        "m.room.server_acl": 100,
        "m.room.tombstone": 100,
      },
      "users": {
        userID: 100,
      },
    };

Map<String, dynamic> restrictedPowerLevels(String userID) => {
      "events_default": 50,
      "events": {
        "m.room.avatar": 50,
        "m.room.canonical_alias": 50,
        "m.room.encryption": 100,
        "m.room.history_visibility": 100,
        "m.room.name": 50,
        "m.room.power_levels": 100,
        "m.room.server_acl": 100,
        "m.room.tombstone": 100,
      },
      "users": {
        userID: 100,
      },
    };
