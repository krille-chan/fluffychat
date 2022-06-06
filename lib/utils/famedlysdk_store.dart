import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';

class Store {
  SharedPreferences? _prefs;

  Future<void> _setupLocalStorage() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<String?> getItem(String key) async {
    await _setupLocalStorage();
    return _prefs!.getString(key);
  }

  Future<bool> getItemBool(String key, [bool? defaultValue]) async {
    await _setupLocalStorage();
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
