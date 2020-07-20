import 'dart:convert';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:async';
import 'dart:core';
import './database/shared.dart';
import 'package:olm/olm.dart' as olm; // needed for migration
import 'package:random_string/random_string.dart';

Future<Database> getDatabase(Client client) async {
  while (_generateDatabaseLock) {
    await Future.delayed(Duration(milliseconds: 50));
  }
  _generateDatabaseLock = true;
  try {
    if (_db != null) return _db;
    final store = Store();
    var password = await store.getItem('database-password');
    var needMigration = false;
    if (password == null || password.isEmpty) {
      needMigration = true;
      password = randomString(255);
    }
    _db = await constructDb(
      logStatements: false,
      filename: 'moor.sqlite',
      password: password,
    );
    if (needMigration) {
      await migrate(client.clientName, _db, store);
      await store.setItem('database-password', password);
    }
    return _db;
  } finally {
    _generateDatabaseLock = false;
  }
}

Database _db;
bool _generateDatabaseLock = false;

Future<void> migrate(String clientName, Database db, Store store) async {
  debugPrint('[Store] attempting old migration to moor...');
  final oldKeys = await store.getAllItems();
  if (oldKeys == null || oldKeys.isEmpty) {
    debugPrint('[Store] empty store!');
    return; // we are done!
  }
  final credentialsStr = oldKeys[clientName];
  if (credentialsStr == null || credentialsStr.isEmpty) {
    debugPrint('[Store] no credentials found!');
    return; // no credentials
  }
  final Map<String, dynamic> credentials = json.decode(credentialsStr);
  if (!credentials.containsKey('homeserver') ||
      !credentials.containsKey('token') ||
      !credentials.containsKey('userID')) {
    debugPrint('[Store] invalid credentials!');
    return; // invalid old store, we are done, too!
  }
  var clientId = 0;
  final oldClient = await db.getClient(clientName);
  if (oldClient == null) {
    clientId = await db.insertClient(
      clientName,
      credentials['homeserver'],
      credentials['token'],
      credentials['userID'],
      credentials['deviceID'],
      credentials['deviceName'],
      null,
      credentials['olmAccount'],
    );
  } else {
    clientId = oldClient.clientId;
    await db.updateClient(
      credentials['homeserver'],
      credentials['token'],
      credentials['userID'],
      credentials['deviceID'],
      credentials['deviceName'],
      null,
      credentials['olmAccount'],
      clientId,
    );
  }
  await db.clearCache(clientId);
  debugPrint('[Store] Inserted/updated client, clientId = ${clientId}');
  await db.transaction(() async {
    // alright, we stored / updated the client and have the account ID, time to import everything else!
    // user_device_keys and user_device_keys_key
    debugPrint('[Store] Migrating user device keys...');
    final deviceKeysListString = oldKeys['${clientName}.user_device_keys'];
    if (deviceKeysListString != null && deviceKeysListString.isNotEmpty) {
      Map<String, dynamic> rawUserDeviceKeys =
          json.decode(deviceKeysListString);
      for (final entry in rawUserDeviceKeys.entries) {
        final map = entry.value;
        await db.storeUserDeviceKeysInfo(
            clientId, map['user_id'], map['outdated']);
        for (final rawKey in map['device_keys'].entries) {
          final jsonVaue = rawKey.value;
          await db.storeUserDeviceKey(
              clientId,
              jsonVaue['user_id'],
              jsonVaue['device_id'],
              json.encode(jsonVaue),
              jsonVaue['verified'],
              jsonVaue['blocked']);
        }
      }
    }
    for (final entry in oldKeys.entries) {
      final key = entry.key;
      final value = entry.value;
      if (value == null || value.isEmpty) {
        continue;
      }
      // olm_sessions
      final olmSessionsMatch =
          RegExp(r'^\/clients\/([^\/]+)\/olm-sessions$').firstMatch(key);
      if (olmSessionsMatch != null) {
        if (olmSessionsMatch[1] != credentials['deviceID']) {
          continue;
        }
        debugPrint('[Store] migrating olm sessions...');
        final identityKey = json.decode(value);
        for (final olmKey in identityKey.entries) {
          final identKey = olmKey.key;
          final sessions = olmKey.value;
          for (final pickle in sessions) {
            var sess = olm.Session();
            sess.unpickle(credentials['userID'], pickle);
            await db.storeOlmSession(
                clientId, identKey, sess.session_id(), pickle, null);
            sess?.free();
          }
        }
      }
      // outbound_group_sessions
      final outboundGroupSessionsMatch = RegExp(
              r'^\/clients\/([^\/]+)\/rooms\/([^\/]+)\/outbound_group_session$')
          .firstMatch(key);
      if (outboundGroupSessionsMatch != null) {
        if (outboundGroupSessionsMatch[1] != credentials['deviceID']) {
          continue;
        }
        final pickle = value;
        final roomId = outboundGroupSessionsMatch[2];
        debugPrint(
            '[Store] Migrating outbound group sessions for room ${roomId}...');
        final devicesString = oldKeys[
            '/clients/${outboundGroupSessionsMatch[1]}/rooms/${roomId}/outbound_group_session_devices'];
        var devices = <String>[];
        if (devicesString != null) {
          devices = List<String>.from(json.decode(devicesString));
        }
        await db.storeOutboundGroupSession(
          clientId,
          roomId,
          pickle,
          json.encode(devices),
          DateTime.now(),
          0,
        );
      }
      // session_keys
      final sessionKeysMatch =
          RegExp(r'^\/clients\/([^\/]+)\/rooms\/([^\/]+)\/session_keys$')
              .firstMatch(key);
      if (sessionKeysMatch != null) {
        if (sessionKeysMatch[1] != credentials['deviceID']) {
          continue;
        }
        final roomId = sessionKeysMatch[2];
        debugPrint('[Store] Migrating session keys for room ${roomId}...');
        final map = json.decode(value);
        for (final entry in map.entries) {
          await db.storeInboundGroupSession(
              clientId,
              roomId,
              entry.key,
              entry.value['inboundGroupSession'],
              json.encode(entry.value['content']),
              json.encode(entry.value['indexes']));
        }
      }
    }
  });
}

class Store {
  final LocalStorage storage;
  final FlutterSecureStorage secureStorage;

  Store()
      : storage = LocalStorage('LocalStorage'),
        secureStorage = kIsWeb ? null : FlutterSecureStorage();

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

  Future<Map<String, dynamic>> getAllItems() async {
    if (kIsWeb) {
      try {
        final rawStorage = await getLocalstorage('LocalStorage');
        return json.decode(rawStorage);
      } catch (_) {
        return {};
      }
    }
    try {
      return await secureStorage.readAll();
    } catch (_) {
      return {};
    }
  }
}
