/*
 * Copyright (c) 2019 Zender & Kurtz GbR.
 *
 * Authors:
 *   Christian Pauly <krille@famedly.com>
 *   Marcel Radzio <mtrnord@famedly.com>
 *
 * This file is part of famedlysdk_store_sqflite.
 *
 * famedlysdk_store_sqflite is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * famedlysdk_store_sqflite is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with famedlysdk_store_sqflite.  If not, see <http://www.gnu.org/licenses/>.
 */

library famedlysdk_store_sqflite;

import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Responsible to store all data persistent and to query objects from the
/// database.
class Store extends StoreAPI {
  final Client client;

  Store(this.client) {
    _init();
  }

  Database _db;

  /// SQLite database for all persistent data. It is recommended to extend this
  /// SDK instead of writing direct queries to the database.
  //Database get db => _db;

  _init() async {
    var databasePath = await getDatabasesPath();
    String path = p.join(databasePath, "FluffyMatrix.db");
    _db = await openDatabase(path, version: 15,
        onCreate: (Database db, int version) async {
      await createTables(db);
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      print("[Store] Migrate databse from version $oldVersion to $newVersion");
      if (oldVersion != newVersion) {
        schemes.forEach((String name, String scheme) async {
          if (name != "Clients") await db.execute("DROP TABLE IF EXISTS $name");
        });
        await createTables(db);
        await db.rawUpdate("UPDATE Clients SET prev_batch='' WHERE client=?",
            [client.clientName]);
      }
    });

    await _db.rawUpdate("UPDATE Events SET status=-1 WHERE status=0");

    List<Map> list = await _db
        .rawQuery("SELECT * FROM Clients WHERE client=?", [client.clientName]);
    if (list.length == 1) {
      var clientList = list[0];
      print("[Store] Previous batch: '${clientList["prev_batch"].toString()}'");
      client.connect(
        newToken: clientList["token"],
        newHomeserver: clientList["homeserver"],
        newUserID: clientList["matrix_id"],
        newDeviceID: clientList["device_id"],
        newDeviceName: clientList["device_name"],
        newLazyLoadMembers: clientList["lazy_load_members"] == 1,
        newMatrixVersions: clientList["matrix_versions"].toString().split(","),
        newPrevBatch: clientList["prev_batch"].toString().isEmpty
            ? null
            : clientList["prev_batch"],
      );
      if (client.debug) {
        print("[Store] Restore client credentials of ${client.userID}");
      }
    } else {
      client.onLoginStateChanged.add(LoginState.loggedOut);
    }
  }

  Future<void> createTables(Database db) async {
    schemes.forEach((String name, String scheme) async {
      await db.execute(scheme);
    });
  }

  Future<String> queryPrevBatch() async {
    List<Map> list = await txn.rawQuery(
        "SELECT prev_batch FROM Clients WHERE client=?", [client.clientName]);
    return list[0]["prev_batch"];
  }

  /// Will be automatically called when the client is logged in successfully.
  Future<void> storeClient() async {
    await _db
        .rawInsert('INSERT OR IGNORE INTO Clients VALUES(?,?,?,?,?,?,?,?,?)', [
      client.clientName,
      client.accessToken,
      client.homeserver,
      client.userID,
      client.deviceID,
      client.deviceName,
      client.prevBatch,
      client.matrixVersions.join(","),
      client.lazyLoadMembers,
    ]);
    return;
  }

  /// Clears all tables from the database.
  Future<void> clear() async {
    await _db
        .rawDelete("DELETE FROM Clients WHERE client=?", [client.clientName]);
    schemes.forEach((String name, String scheme) async {
      if (name != "Clients") await _db.rawDelete("DELETE FROM $name");
    });
    return;
  }

  Future<void> transaction(Function queries) async {
    return _db.transaction((txnObj) async {
      txn = txnObj.batch();
      queries();
      await txn.commit(noResult: true);
    });
  }

  /// Will be automatically called on every synchronisation. Must be called inside of
  //  /// [transaction].
  void storePrevBatch(String prevBatch) {
    txn.rawUpdate("UPDATE Clients SET prev_batch=? WHERE client=?",
        [prevBatch, client.clientName]);
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

    if (type != "account_data" && eventUpdate.content["event_id"] != null ||
        eventUpdate.content["state_key"] != null) {
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

  /// Loads all Users in the database to provide a contact list
  /// except users who are in the Room with the ID [exceptRoomID].
  Future<List<User>> loadContacts({String exceptRoomID = ""}) async {
    List<Map<String, dynamic>> res = await _db.rawQuery(
        "SELECT * FROM RoomStates WHERE state_key LIKE '@%:%' AND state_key!=? AND room_id!=? GROUP BY state_key ORDER BY state_key",
        [client.userID, exceptRoomID]);
    List<User> userList = [];
    for (int i = 0; i < res.length; i++) {
      userList.add(Event.fromJson(res[i], Room(id: "", client: client)).asUser);
    }
    return userList;
  }

  /// Returns all users of a room by a given [roomID].
  Future<List<User>> loadParticipants(Room room) async {
    List<Map<String, dynamic>> res = await _db.rawQuery(
        "SELECT * " +
            " FROM RoomStates " +
            " WHERE room_id=? " +
            " AND type='m.room.member'",
        [room.id]);

    List<User> participants = [];

    for (num i = 0; i < res.length; i++) {
      participants.add(Event.fromJson(res[i], room).asUser);
    }

    return participants;
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

  /// Returns a room without events and participants.
  @deprecated
  Future<Room> getRoomById(String id) async {
    List<Map<String, dynamic>> res =
        await _db.rawQuery("SELECT * FROM Rooms WHERE room_id=?", [id]);
    if (res.length != 1) return null;
    return Room.getRoomFromTableRow(res[0], client,
        roomAccountData: getAccountDataFromRoomId(id),
        states: getStatesFromRoomId(id));
  }

  Future<List<Map<String, dynamic>>> getStatesFromRoomId(String id) async {
    return _db.rawQuery("SELECT * FROM RoomStates WHERE room_id=?", [id]);
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
      newPresences[rawPresences[i]["type"]] = Presence.fromJson(rawPresence);
    }
    return newPresences;
  }

  Future removeEvent(String eventId) async {
    assert(eventId != "");
    await _db.rawDelete("DELETE FROM Events WHERE event_id=?", [eventId]);
    return;
  }

  Future forgetNotification(String roomID) async {
    assert(roomID != "");
    await _db
        .rawDelete("DELETE FROM NotificationsCache WHERE chat_id=?", [roomID]);
    return;
  }

  Future addNotification(String roomID, String eventId, int uniqueID) async {
    assert(roomID != "");
    assert(eventId != "");
    await _db.rawInsert(
        "INSERT OR REPLACE INTO NotificationsCache(id, chat_id, event_id) VALUES (?, ?, ?)",
        [uniqueID, roomID, eventId]);
    // Make sure we got the same unique ID everywhere
    await _db.rawUpdate("UPDATE NotificationsCache SET id=? WHERE chat_id=?",
        [uniqueID, roomID]);
    return;
  }

  Future<List<Map<String, dynamic>>> getNotificationByRoom(
      String roomId) async {
    assert(roomId != "");
    List<Map<String, dynamic>> res = await _db
        .rawQuery("SELECT * FROM NotificationsCache WHERE chat_id=?", [roomId]);
    if (res.isEmpty) return null;
    return res;
  }

  static final Map<String, String> schemes = {
    /// The database scheme for the Client class.
    "Clients": 'CREATE TABLE IF NOT EXISTS Clients(' +
        'client TEXT PRIMARY KEY, ' +
        'token TEXT, ' +
        'homeserver TEXT, ' +
        'matrix_id TEXT, ' +
        'device_id TEXT, ' +
        'device_name TEXT, ' +
        'prev_batch TEXT, ' +
        'matrix_versions TEXT, ' +
        'lazy_load_members INTEGER, ' +
        'UNIQUE(client))',

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

    /// The database scheme for the NotificationsCache class.
    "NotificationsCache": 'CREATE TABLE IF NOT EXISTS NotificationsCache(' +
        'id int, ' +
        'chat_id TEXT, ' + // The chat id
        'event_id TEXT, ' + // The matrix id of the Event
        'UNIQUE(event_id))',
  };
}
