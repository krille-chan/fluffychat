import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrix/matrix.dart';

const _passwordStorageKey = 'database_password';

Future<String> getDatabaseCipher() async {
  String? password;

  try {
    const secureStorage = FlutterSecureStorage();
    final containsEncryptionKey =
        await secureStorage.read(key: _passwordStorageKey) != null;
    if (!containsEncryptionKey) {
      final rng = Random.secure();
      final list = Uint8List(32);
      list.setAll(0, Iterable.generate(list.length, (i) => rng.nextInt(256)));
      final newPassword = base64UrlEncode(list);
      await secureStorage.write(
        key: _passwordStorageKey,
        value: newPassword,
      );
    }
    // workaround for if we just wrote to the key and it still doesn't exist
    password = await secureStorage.read(key: _passwordStorageKey);
    if (password == null) throw MissingPluginException();
  } on MissingPluginException catch (_) {
    const FlutterSecureStorage()
        .delete(key: _passwordStorageKey)
        .catchError((_) {});
    Logs().i('Database encryption is not supported on this platform');
  } catch (e, s) {
    const FlutterSecureStorage()
        .delete(key: _passwordStorageKey)
        .catchError((_) {});
    Logs().w('Unable to init database encryption', e, s);
  }

  // with the new database, we should no longer allow unencrypted storage
  // secure_storage now supports all platforms we support
  assert(password != null);

  return password!;
}
