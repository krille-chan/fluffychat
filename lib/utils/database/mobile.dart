import 'package:famedlysdk/famedlysdk.dart';
import 'package:encrypted_moor/encrypted_moor.dart';
import 'package:flutter/material.dart';

Database constructDb({bool logStatements = false, String filename = 'database.sqlite', String password = ''}) {
  debugPrint('[Moor] using encrypted moor');
  return Database(EncryptedExecutor(path: filename, password: password, logStatements: logStatements));
}

Future<String> getLocalstorage(String key) async {
  return null;
}
