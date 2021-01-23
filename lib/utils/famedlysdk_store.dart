import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:core';
import './database/shared.dart';
import '../config/setting_keys.dart';
import 'package:random_string/random_string.dart';

Future<Database> getDatabase(Client client) async {
  while (_generateDatabaseLock) {
    await Future.delayed(Duration(milliseconds: 50));
  }
  _generateDatabaseLock = true;
  try {
    if (_db != null) return _db;
    final store = Store();
    var password = await store.getItem(SettingKeys.databasePassword);
    var newPassword = false;
    if (password == null || password.isEmpty) {
      newPassword = true;
      password = randomString(255);
    }
    _db = await constructDb(
      logStatements: false,
      filename: 'moor.sqlite',
      password: password,
    );
    if (newPassword) {
      await store.setItem(SettingKeys.databasePassword, password);
    }
    return _db;
  } finally {
    _generateDatabaseLock = false;
  }
}

Database _db;
bool _generateDatabaseLock = false;

class Store {
  LocalStorage storage;
  final FlutterSecureStorage secureStorage;

  Store()
      : secureStorage = PlatformInfos.isMobile ? FlutterSecureStorage() : null;

  Future<void> _setupLocalStorage() async {
    if (storage == null) {
      final directory = PlatformInfos.isBetaDesktop
          ? await getApplicationSupportDirectory()
          : (PlatformInfos.isWeb
              ? null
              : await getApplicationDocumentsDirectory());
      storage = LocalStorage('LocalStorage', directory?.path);
      await storage.ready;
    }
  }

  Future<String> getItem(String key) async {
    if (!PlatformInfos.isMobile) {
      await _setupLocalStorage();
      try {
        return await storage.getItem(key)?.toString();
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

  Future<bool> getItemBool(String key, [bool defaultValue]) async {
    final value = await getItem(key);
    if (value == null) {
      return defaultValue ?? false;
    }
    // we also check for '1' for legacy reasons, some booleans were stored that way
    return value == '1' || value.toLowerCase() == 'true';
  }

  Future<void> setItem(String key, String value) async {
    if (!PlatformInfos.isMobile) {
      await _setupLocalStorage();
      return await storage.setItem(key, value);
    }
    return await secureStorage.write(key: key, value: value);
  }

  Future<void> setItemBool(String key, bool value) async {
    await setItem(key, value.toString());
  }

  Future<void> deleteItem(String key) async {
    if (!PlatformInfos.isMobile) {
      await _setupLocalStorage();
      return await storage.deleteItem(key);
    }
    return await secureStorage.delete(key: key);
  }
}
