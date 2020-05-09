import 'dart:convert';
import 'dart:typed_data';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:async';
import 'dart:core';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class Store extends StoreAPI {
  final Client client;
  final LocalStorage storage;
  final FlutterSecureStorage secureStorage;

  Store(this.client)
      : storage = LocalStorage('LocalStorage'),
        secureStorage = kIsWeb ? null : FlutterSecureStorage() {
    _init();
  }

  Future<dynamic> getItem(String key) async {
    if (kIsWeb) {
      await storage.ready;
      try {
        return await storage.getItem(key);
      } catch (_) {
        return null;
      }
    }
    try {
      return await secureStorage.read(key: key);
    } catch (_) {
      return null;
    }
  }

  Future<void> setItem(String key, String value) async {
    if (kIsWeb) {
      await storage.ready;
      return await storage.setItem(key, value);
    }
    if (value == null) {
      return await secureStorage.delete(key: key);
    } else {
      return await secureStorage.write(key: key, value: value);
    }
  }

  Future<Map<String, DeviceKeysList>> getUserDeviceKeys() async {
    final deviceKeysListString = await getItem(_UserDeviceKeysKey);
    if (deviceKeysListString == null) return {};
    Map<String, dynamic> rawUserDeviceKeys = json.decode(deviceKeysListString);
    Map<String, DeviceKeysList> userDeviceKeys = {};
    for (final entry in rawUserDeviceKeys.entries) {
      userDeviceKeys[entry.key] = DeviceKeysList.fromJson(entry.value);
    }
    return userDeviceKeys;
  }

  Future<void> storeUserDeviceKeys(
      Map<String, DeviceKeysList> userDeviceKeys) async {
    await setItem(_UserDeviceKeysKey, json.encode(userDeviceKeys));
  }

  String get _UserDeviceKeysKey => "${client.clientName}.user_device_keys";

  _init() async {
    final credentialsStr = await getItem(client.clientName);

    if (credentialsStr == null || credentialsStr.isEmpty) {
      client.onLoginStateChanged.add(LoginState.loggedOut);
      return;
    }
    debugPrint("[Matrix] Restoring account credentials");
    final Map<String, dynamic> credentials = json.decode(credentialsStr);
    if (credentials["homeserver"] == null ||
        credentials["token"] == null ||
        credentials["userID"] == null) {
      client.onLoginStateChanged.add(LoginState.loggedOut);
      return;
    }
    client.connect(
      newDeviceID: credentials["deviceID"],
      newDeviceName: credentials["deviceName"],
      newHomeserver: credentials["homeserver"],
      newMatrixVersions: List<String>.from(credentials["matrixVersions"] ?? []),
      newToken: credentials["token"],
      newUserID: credentials["userID"],
      newPrevBatch: kIsWeb
          ? null
          : (credentials["prev_batch"]?.isEmpty ?? true)
              ? null
              : credentials["prev_batch"],
      newOlmAccount: credentials["olmAccount"],
    );
  }

  Future<void> storeClient() async {
    final Map<String, dynamic> credentials = {
      "deviceID": client.deviceID,
      "deviceName": client.deviceName,
      "homeserver": client.homeserver,
      "matrixVersions": client.matrixVersions,
      "token": client.accessToken,
      "userID": client.userID,
      "olmAccount": client.pickledOlmAccount,
    };
    await setItem(client.clientName, json.encode(credentials));
    return;
  }

  Future<void> clear() => kIsWeb ? storage.clear() : secureStorage.deleteAll();
}

/// Responsible to store all data persistent and to query objects from the
/// database.
class ExtendedStore extends Store implements ExtendedStoreAPI {
  /// The maximum time that files are allowed to stay in the
  /// store. By default this is are 30 days.
  static const int MAX_FILE_STORING_TIME = 1 * 30 * 24 * 60 * 60 * 1000;

  @override
  final bool extended = true;

  ExtendedStore(Client client) : super(client);

  Database _db;
  var txn;

  /// SQLite database for all persistent data. It is recommended to extend this
  /// SDK instead of writing direct queries to the database.
  //Database get db => _db;

  @override
  _init() async {
    // Open the database and migrate if necessary.
    var databasePath = await getDatabasesPath();
    String path = p.join(databasePath, "FluffyMatrix.db");
    _db = await openDatabase(path, version: 20,
        onCreate: (Database db, int version) async {
      await createTables(db);
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      debugPrint(
          "[Store] Migrate database from version $oldVersion to $newVersion");
      if (oldVersion >= 18 && newVersion <= 20) {
        await createTables(db);
      } else if (oldVersion != newVersion) {
        // Look for an old entry in an old clients library
        List<Map> list = [];
        try {
          list = await db.rawQuery(
              "SELECT * FROM Clients WHERE client=?", [client.clientName]);
        } catch (_) {
          list = [];
        }
        client.prevBatch = null;
        await this.storePrevBatch(null);
        schemes.forEach((String name, String scheme) async {
          await db.execute("DROP TABLE IF EXISTS $name");
        });
        await createTables(db);

        if (list.length == 1) {
          debugPrint("[Store] Found old client from deprecated store");
          var clientList = list[0];
          _db = db;
          client.connect(
            newToken: clientList["token"],
            newHomeserver: clientList["homeserver"],
            newUserID: clientList["matrix_id"],
            newDeviceID: clientList["device_id"],
            newDeviceName: clientList["device_name"],
            newMatrixVersions:
                clientList["matrix_versions"].toString().split(","),
            newPrevBatch: null,
          );
          await db.execute("DROP TABLE IF EXISTS Clients");
          debugPrint(
              "[Store] Restore client credentials from deprecated database of ${client.userID}");
        }
      } else {
        client.onLoginStateChanged.add(LoginState.loggedOut);
      }
      return;
    });

    // Mark all pending events as failed.
    await _db.rawUpdate("UPDATE Events SET status=-1 WHERE status=0");

    // Delete all stored files which are older than [MAX_FILE_STORING_TIME]
    final int currentDeadline = DateTime.now().millisecondsSinceEpoch -
        ExtendedStore.MAX_FILE_STORING_TIME;
    await _db.rawDelete(
      "DELETE From Files WHERE saved_at<?",
      [currentDeadline],
    );

    super._init();
  }

  Future<void> setRoomPrevBatch(String roomId, String prevBatch) async {
    await txn.rawUpdate(
        "UPDATE Rooms SET prev_batch=? WHERE room_id=?", [roomId, prevBatch]);
    return;
  }

  Future<void> createTables(Database db) async {
    schemes.forEach((String name, String scheme) async {
      await db.execute(scheme);
    });
  }

  /// Clears all tables from the database.
  Future<void> clear() async {
    schemes.forEach((String name, String scheme) async {
      await _db.rawDelete("DELETE FROM $name");
    });
    await super.clear();
    return;
  }

  Future<void> transaction(Function queries) async {
    return _db.transaction((txnObj) async {
      txn = txnObj.batch();
      queries();
      await txn.commit(noResult: true);
    });
  }

  /// Will be automatically called on every synchronisation.
  Future<void> storePrevBatch(String prevBatch) async {
    final credentialsStr = await getItem(client.clientName);
    if (credentialsStr == null) return;
    final Map<String, dynamic> credentials = json.decode(credentialsStr);
    credentials["prev_batch"] = prevBatch;
    await setItem(client.clientName, json.encode(credentials));
  }

  Future<void> storeRoomPrevBatch(Room room) async {
    await _db.rawUpdate("UPDATE Rooms SET prev_batch=? WHERE room_id=?",
        [room.prev_batch, room.id]);
    return null;
  }

  /// Stores a RoomUpdate object in the database. Must be called inside of
  /// [transaction].
  Future<void> storeRoomUpdate(RoomUpdate roomUpdate) {
    if (txn == null) return null;
    // Insert the chat into the database if not exists
    if (roomUpdate.membership != Membership.leave) {
      txn.rawInsert(
          "INSERT OR IGNORE INTO Rooms " + "VALUES(?, ?, 0, 0, '', 0, 0, '') ",
          [roomUpdate.id, roomUpdate.membership.toString().split('.').last]);
    } else {
      txn.rawDelete("DELETE FROM Rooms WHERE room_id=? ", [roomUpdate.id]);
      return null;
    }

    // Update the notification counts and the limited timeline boolean and the summary
    String updateQuery =
        "UPDATE Rooms SET highlight_count=?, notification_count=?, membership=?";
    List<dynamic> updateArgs = [
      roomUpdate.highlight_count,
      roomUpdate.notification_count,
      roomUpdate.membership.toString().split('.').last
    ];
    if (roomUpdate.summary?.mJoinedMemberCount != null) {
      updateQuery += ", joined_member_count=?";
      updateArgs.add(roomUpdate.summary.mJoinedMemberCount);
    }
    if (roomUpdate.summary?.mInvitedMemberCount != null) {
      updateQuery += ", invited_member_count=?";
      updateArgs.add(roomUpdate.summary.mInvitedMemberCount);
    }
    if (roomUpdate.summary?.mHeroes != null) {
      updateQuery += ", heroes=?";
      updateArgs.add(roomUpdate.summary.mHeroes.join(","));
    }
    updateQuery += " WHERE room_id=?";
    updateArgs.add(roomUpdate.id);
    txn.rawUpdate(updateQuery, updateArgs);

    // Is the timeline limited? Then all previous messages should be
    // removed from the database!
    if (roomUpdate.limitedTimeline) {
      txn.rawDelete("DELETE FROM Events WHERE room_id=?", [roomUpdate.id]);
      txn.rawUpdate("UPDATE Rooms SET prev_batch=? WHERE room_id=?",
          [roomUpdate.prev_batch, roomUpdate.id]);
    }
    return null;
  }

  /// Stores an UserUpdate object in the database. Must be called inside of
  /// [transaction].
  Future<void> storeUserEventUpdate(UserUpdate userUpdate) {
    if (txn == null) return null;
    if (userUpdate.type == "account_data") {
      txn.rawInsert("INSERT OR REPLACE INTO AccountData VALUES(?, ?)", [
        userUpdate.eventType,
        json.encode(userUpdate.content["content"]),
      ]);
    } else if (userUpdate.type == "presence") {
      txn.rawInsert("INSERT OR REPLACE INTO Presences VALUES(?, ?, ?)", [
        userUpdate.eventType,
        userUpdate.content["sender"],
        json.encode(userUpdate.content["content"]),
      ]);
    }
    return null;
  }

  Future<dynamic> redactMessage(EventUpdate eventUpdate) async {
    List<Map<String, dynamic>> res = await _db.rawQuery(
        "SELECT * FROM Events WHERE event_id=?",
        [eventUpdate.content["redacts"]]);
    if (res.length == 1) {
      Event event = Event.fromJson(res[0], null);
      event.setRedactionEvent(Event.fromJson(eventUpdate.content, null));
      final int changes1 = await _db.rawUpdate(
        "UPDATE Events SET unsigned=?, content=?, prev_content=? WHERE event_id=?",
        [
          json.encode(event.unsigned ?? ""),
          json.encode(event.content ?? ""),
          json.encode(event.prevContent ?? ""),
          event.eventId,
        ],
      );
      final int changes2 = await _db.rawUpdate(
        "UPDATE RoomStates SET unsigned=?, content=?, prev_content=? WHERE event_id=?",
        [
          json.encode(event.unsigned ?? ""),
          json.encode(event.content ?? ""),
          json.encode(event.prevContent ?? ""),
          event.eventId,
        ],
      );
      if (changes1 == 1 && changes2 == 1) return true;
    }
    return false;
  }

  /// Stores an EventUpdate object in the database. Must be called inside of
  /// [transaction].
  Future<void> storeEventUpdate(EventUpdate eventUpdate) {
    if (txn == null || eventUpdate.type == "ephemeral") return null;
    Map<String, dynamic> eventContent = eventUpdate.content;
    String type = eventUpdate.type;
    String chatId = eventUpdate.roomID;

    // Get the state_key for m.room.member events
    String stateKey = "";
    if (eventContent["state_key"] is String) {
      stateKey = eventContent["state_key"];
    }

    if (eventUpdate.eventType == "m.room.redaction") {
      redactMessage(eventUpdate);
    }

    if (type == "timeline" || type == "history") {
      // calculate the status
      num status = 2;
      if (eventContent["status"] is num) status = eventContent["status"];

      // Save the event in the database
      if ((status == 1 || status == -1) &&
          eventContent["unsigned"] is Map<String, dynamic> &&
          eventContent["unsigned"]["transaction_id"] is String) {
        txn.rawUpdate(
            "UPDATE Events SET status=?, event_id=? WHERE event_id=?", [
          status,
          eventContent["event_id"],
          eventContent["unsigned"]["transaction_id"]
        ]);
      } else {
        txn.rawInsert(
            "INSERT OR REPLACE INTO Events VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            [
              eventContent["event_id"],
              chatId,
              eventContent["origin_server_ts"],
              eventContent["sender"],
              eventContent["type"],
              json.encode(eventContent["unsigned"] ?? ""),
              json.encode(eventContent["content"]),
              json.encode(eventContent["prevContent"]),
              eventContent["state_key"],
              status
            ]);
      }

      // Is there a transaction id? Then delete the event with this id.
      if (status != -1 &&
          eventUpdate.content.containsKey("unsigned") &&
          eventUpdate.content["unsigned"]["transaction_id"] is String) {
        txn.rawDelete("DELETE FROM Events WHERE event_id=?",
            [eventUpdate.content["unsigned"]["transaction_id"]]);
      }
    }

    if (type == "history") return null;

    if (type != "account_data") {
      final String now = DateTime.now().millisecondsSinceEpoch.toString();
      txn.rawInsert(
          "INSERT OR REPLACE INTO RoomStates VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)",
          [
            eventContent["event_id"] ?? now,
            chatId,
            eventContent["origin_server_ts"] ?? now,
            eventContent["sender"],
            stateKey,
            json.encode(eventContent["unsigned"] ?? ""),
            json.encode(eventContent["prev_content"] ?? ""),
            eventContent["type"],
            json.encode(eventContent["content"]),
          ]);
    } else if (type == "account_data") {
      txn.rawInsert("INSERT OR REPLACE INTO RoomAccountData VALUES(?, ?, ?)", [
        eventContent["type"],
        chatId,
        json.encode(eventContent["content"]),
      ]);
    }

    return null;
  }

  /// Returns a User object by a given Matrix ID and a Room.
  Future<User> getUser({String matrixID, Room room}) async {
    List<Map<String, dynamic>> res = await _db.rawQuery(
        "SELECT * FROM RoomStates WHERE state_key=? AND room_id=?",
        [matrixID, room.id]);
    if (res.length != 1) return null;
    return Event.fromJson(res[0], room).asUser;
  }

  /// Returns a list of events for the given room and sets all participants.
  Future<List<Event>> getEventList(Room room) async {
    List<Map<String, dynamic>> eventRes = await _db.rawQuery(
        "SELECT * " +
            " FROM Events " +
            " WHERE room_id=?" +
            " GROUP BY event_id " +
            " ORDER BY origin_server_ts DESC",
        [room.id]);

    List<Event> eventList = [];

    for (num i = 0; i < eventRes.length; i++) {
      eventList.add(Event.fromJson(eventRes[i], room));
    }

    return eventList;
  }

  /// Returns all rooms, the client is participating. Excludes left rooms.
  Future<List<Room>> getRoomList({bool onlyLeft = false}) async {
    List<Map<String, dynamic>> res = await _db.rawQuery("SELECT * " +
        " FROM Rooms" +
        " WHERE membership" +
        (onlyLeft ? "=" : "!=") +
        "'leave' " +
        " GROUP BY room_id ");
    List<Room> roomList = [];
    for (num i = 0; i < res.length; i++) {
      Room room = await Room.getRoomFromTableRow(
        res[i],
        client,
        states: getStatesFromRoomId(res[i]["room_id"]),
        roomAccountData: getAccountDataFromRoomId(res[i]["room_id"]),
      );
      roomList.add(room);
    }
    return roomList;
  }

  Future<List<Map<String, dynamic>>> getStatesFromRoomId(String id) async {
    return _db.rawQuery(
        "SELECT * FROM RoomStates WHERE room_id=? AND type IS NOT NULL", [id]);
  }

  Future<List<Map<String, dynamic>>> getAccountDataFromRoomId(String id) async {
    return _db.rawQuery("SELECT * FROM RoomAccountData WHERE room_id=?", [id]);
  }

  Future<void> resetNotificationCount(String roomID) async {
    await _db.rawDelete(
        "UPDATE Rooms SET notification_count=0, highlight_count=0 WHERE room_id=?",
        [roomID]);
    return;
  }

  Future<void> forgetRoom(String roomID) async {
    await _db.rawDelete("DELETE FROM Rooms WHERE room_id=?", [roomID]);
    await _db.rawDelete("DELETE FROM Events WHERE room_id=?", [roomID]);
    await _db.rawDelete("DELETE FROM RoomStates WHERE room_id=?", [roomID]);
    await _db
        .rawDelete("DELETE FROM RoomAccountData WHERE room_id=?", [roomID]);
    return;
  }

  /// Searches for the event in the store.
  Future<Event> getEventById(String eventID, Room room) async {
    List<Map<String, dynamic>> res = await _db.rawQuery(
        "SELECT * FROM Events WHERE event_id=? AND room_id=?",
        [eventID, room.id]);
    if (res.isEmpty) return null;
    return Event.fromJson(res[0], room);
  }

  Future<Map<String, AccountData>> getAccountData() async {
    Map<String, AccountData> newAccountData = {};
    List<Map<String, dynamic>> rawAccountData =
        await _db.rawQuery("SELECT * FROM AccountData");
    for (int i = 0; i < rawAccountData.length; i++) {
      newAccountData[rawAccountData[i]["type"]] =
          AccountData.fromJson(rawAccountData[i]);
    }
    return newAccountData;
  }

  Future<Map<String, Presence>> getPresences() async {
    Map<String, Presence> newPresences = {};
    List<Map<String, dynamic>> rawPresences =
        await _db.rawQuery("SELECT * FROM Presences");
    for (int i = 0; i < rawPresences.length; i++) {
      Map<String, dynamic> rawPresence = {
        "sender": rawPresences[i]["sender"],
        "content": json.decode(rawPresences[i]["content"]),
      };
      newPresences[rawPresences[i]["sender"]] = Presence.fromJson(rawPresence);
    }
    return newPresences;
  }

  Future removeEvent(String eventId) async {
    assert(eventId != "");
    await _db.rawDelete("DELETE FROM Events WHERE event_id=?", [eventId]);
    return;
  }

  Future<void> storeFile(Uint8List bytes, String mxcUri) async {
    await _db.rawInsert(
      "INSERT OR REPLACE INTO Files VALUES(?, ?, ?)",
      [mxcUri, bytes, DateTime.now().millisecondsSinceEpoch],
    );
    return;
  }

  Future<Uint8List> getFile(String mxcUri) async {
    List<Map<String, dynamic>> res = await _db.rawQuery(
      "SELECT * FROM Files WHERE mxc_uri=?",
      [mxcUri],
    );
    if (res.isEmpty) return null;
    return res.first["bytes"];
  }

  static final Map<String, String> schemes = {
    /// The database scheme for the Room class.
    'Rooms': 'CREATE TABLE IF NOT EXISTS Rooms(' +
        'room_id TEXT PRIMARY KEY, ' +
        'membership TEXT, ' +
        'highlight_count INTEGER, ' +
        'notification_count INTEGER, ' +
        'prev_batch TEXT, ' +
        'joined_member_count INTEGER, ' +
        'invited_member_count INTEGER, ' +
        'heroes TEXT, ' +
        'UNIQUE(room_id))',

    /// The database scheme for the TimelineEvent class.
    'Events': 'CREATE TABLE IF NOT EXISTS Events(' +
        'event_id TEXT PRIMARY KEY, ' +
        'room_id TEXT, ' +
        'origin_server_ts INTEGER, ' +
        'sender TEXT, ' +
        'type TEXT, ' +
        'unsigned TEXT, ' +
        'content TEXT, ' +
        'prev_content TEXT, ' +
        'state_key TEXT, ' +
        "status INTEGER, " +
        'UNIQUE(event_id))',

    /// The database scheme for room states.
    'RoomStates': 'CREATE TABLE IF NOT EXISTS RoomStates(' +
        'event_id TEXT PRIMARY KEY, ' +
        'room_id TEXT, ' +
        'origin_server_ts INTEGER, ' +
        'sender TEXT, ' +
        'state_key TEXT, ' +
        'unsigned TEXT, ' +
        'prev_content TEXT, ' +
        'type TEXT, ' +
        'content TEXT, ' +
        'UNIQUE(room_id,state_key,type))',

    /// The database scheme for room states.
    'AccountData': 'CREATE TABLE IF NOT EXISTS AccountData(' +
        'type TEXT PRIMARY KEY, ' +
        'content TEXT, ' +
        'UNIQUE(type))',

    /// The database scheme for room states.
    'RoomAccountData': 'CREATE TABLE IF NOT EXISTS RoomAccountData(' +
        'type TEXT, ' +
        'room_id TEXT, ' +
        'content TEXT, ' +
        'UNIQUE(type,room_id))',

    /// The database scheme for room states.
    'Presences': 'CREATE TABLE IF NOT EXISTS Presences(' +
        'type TEXT PRIMARY KEY, ' +
        'sender TEXT, ' +
        'content TEXT, ' +
        'UNIQUE(sender))',

    /// The database scheme for room states.
    'Files': 'CREATE TABLE IF NOT EXISTS Files(' +
        'mxc_uri TEXT PRIMARY KEY, ' +
        'bytes BLOB, ' +
        'saved_at INTEGER, ' +
        'UNIQUE(mxc_uri))',
  };

  @override
  int get maxFileSize => 1 * 1024 * 1024;
}
