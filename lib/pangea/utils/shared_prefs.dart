import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MyShared {
  static saveString(String key, String value) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString(key, value);
  }

  static Future<String?>? readString(String key) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? source = _prefs.getString(key);
    return source;
  }

  static saveJson(String key, Map value) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString(key, json.encode(value));
  }

  static Future<Map?>? readJson(String key) async {
    try {
      final SharedPreferences _prefs = await SharedPreferences.getInstance();
      String? source = _prefs.getString(key);

      if (source == null) {
        return null;
      }
      var decodedJson = json.decoder.convert(source);
      //var decodedJson = json.decode(source);
      return decodedJson;
    } catch (err) {
      return null;
    }
  }
}
