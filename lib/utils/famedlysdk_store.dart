import 'dart:core';

import 'package:matrix/matrix.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'legacy_famedlysdk_store.dart' as legacy;

class Store {
  SharedPreferences? _prefs;

  Future<void> _setupLocalStorage() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<String?> getItem(String key) async {
    await _setupLocalStorage();
    final legacyVal = await legacy.Store().getItem(key);
    if (legacyVal != null) {
      Logs().d('Found legacy preference for $key');
      await setItem(key, legacyVal);
      legacy.Store().deleteItem(key);
      return legacyVal;
    }
    return _prefs!.getString(key);
  }

  Future<bool> getItemBool(String key, [bool? defaultValue]) async {
    await _setupLocalStorage();
    final legacyVal = await legacy.Store().getItemBool(key);
    if (legacyVal != null) {
      Logs().d('Found legacy preference for $key');
      await setItemBool(key, legacyVal);
      legacy.Store().deleteItem(key);
      return legacyVal;
    }
    return _prefs!.getBool(key) ?? defaultValue ?? true;
  }

  Future<void> setItem(String key, String? value) async {
    await _setupLocalStorage();
    if (value == null) {
      await _prefs!.remove(key);
      return;
    }
    await _prefs!.setString(key, value);
    return;
  }

  Future<void> setItemBool(String key, bool value) async {
    await _setupLocalStorage();
    await _prefs!.setBool(key, value);
    return;
  }

  Future<void> deleteItem(String key) async {
    await _setupLocalStorage();
    await _prefs!.remove(key);
    return;
  }
}
