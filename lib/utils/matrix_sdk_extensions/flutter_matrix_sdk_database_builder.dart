import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as ffi;
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:universal_html/html.dart' as html;

import 'package:fluffychat/utils/platform_infos.dart';

Future<MatrixSdkDatabase> flutterMatrixSdkDatabaseBuilder(Client client) async {
  final database = await _constructDatabase(client);
  await database.open();
  return database;
}

Future<MatrixSdkDatabase> _constructDatabase(Client client) async {
  if (kIsWeb) {
    html.window.navigator.storage?.persist();
    return MatrixSdkDatabase(client.clientName);
  }
  if (PlatformInfos.isDesktop) {
    final path = await getApplicationSupportDirectory();
    return MatrixSdkDatabase(
      client.clientName,
      database: await ffi.databaseFactoryFfi.openDatabase(
        '$path/${client.clientName}',
      ),
      maxFileSize: 1024 * 1024 * 10,
      fileStoragePath: path,
      deleteFilesAfterDuration: const Duration(days: 30),
    );
  }

  final path = await getDatabasesPath();
  const passwordStorageKey = 'database_password';
  String? password;

  try {
    // Workaround for secure storage is calling Platform.operatingSystem on web
    if (kIsWeb) throw MissingPluginException();

    const secureStorage = FlutterSecureStorage();
    final containsEncryptionKey =
        await secureStorage.read(key: passwordStorageKey) != null;
    if (!containsEncryptionKey) {
      final rng = Random.secure();
      final list = Uint8List(32);
      list.setAll(0, Iterable.generate(list.length, (i) => rng.nextInt(256)));
      final newPassword = base64UrlEncode(list);
      await secureStorage.write(
        key: passwordStorageKey,
        value: newPassword,
      );
    }
    // workaround for if we just wrote to the key and it still doesn't exist
    password = await secureStorage.read(key: passwordStorageKey);
    if (password == null) throw MissingPluginException();
  } on MissingPluginException catch (_) {
    const FlutterSecureStorage()
        .delete(key: passwordStorageKey)
        .catchError((_) {});
    Logs().i('Database encryption is not supported on this platform');
  } catch (e, s) {
    const FlutterSecureStorage()
        .delete(key: passwordStorageKey)
        .catchError((_) {});
    Logs().w('Unable to init database encryption', e, s);
  }

  return MatrixSdkDatabase(
    client.clientName,
    database: await openDatabase(
      '$path/${client.clientName}',
      password: password,
    ),
    maxFileSize: 1024 * 1024 * 10,
    fileStoragePath: await getTemporaryDirectory(),
    deleteFilesAfterDuration: const Duration(days: 30),
  );
}
