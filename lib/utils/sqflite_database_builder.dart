import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as ffi;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:universal_html/html.dart' as html;

import 'package:fluffychat/utils/platform_infos.dart';

Future<SqfliteDatabase> sqfliteDatabaseBuilder(Client client) async {
  Logs().d('Build SQFLite database...');
  if (kIsWeb) {
    html.window.navigator.storage?.persist();
    return SqfliteDatabase(
      await databaseFactoryFfiWeb.openDatabase(
        client.clientName,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: DbTablesExtension.create,
        ),
      ),
      fileStoragePath: null,
      maxFileSize: 0,
    );
  }
  final path = PlatformInfos.isMobile
      ? await getDatabasesPath()
      : (await getApplicationSupportDirectory()).path;
  const passwordStorageKey = 'database_password';
  String? password;
  Database? database;

  if (PlatformInfos.isDesktop) {
    database = await ffi.databaseFactoryFfi.openDatabase(
      '$path/${client.clientName}',
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: DbTablesExtension.create,
      ),
    );
  } else {
    try {
      const secureStorage = FlutterSecureStorage();
      final containsEncryptionKey =
          await secureStorage.read(key: passwordStorageKey) != null;
      if (!containsEncryptionKey) {
        // do not try to create a buggy secure storage for new Linux users
        if (Platform.isLinux) throw MissingPluginException();
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
    } catch (e, s) {
      const FlutterSecureStorage()
          .delete(key: passwordStorageKey)
          .catchError((_) {});
      Logs().w('Unable to init database encryption', e, s);
    }
    database = await openDatabase(
      '$path/${client.clientName}',
      version: 1,
      onCreate: DbTablesExtension.create,
      password: password,
    );
  }

  return SqfliteDatabase(
    database,
    fileStoragePath: await getTemporaryDirectory(),
    maxFileSize: 10 * 1024 * 1024,
  );
}
