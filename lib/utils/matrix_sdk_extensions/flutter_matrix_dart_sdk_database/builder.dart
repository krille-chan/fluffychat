import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as ffi;
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:universal_html/html.dart' as html;

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/client_manager.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/flutter_hive_collections_database.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'cipher.dart';
import 'sqlite_ffi/stub.dart' if (dart.library.io) 'sqlite_ffi/io.dart';

Future<DatabaseApi> flutterMatrixSdkDatabaseBuilder(Client client) async {
  MatrixSdkDatabase? database;
  try {
    database = await _constructDatabase(client);
    await database.open();
    return database;
  } catch (e) {
    // Try to delete database so that it can created again on next init:
    database?.delete().catchError(
          (e, s) => Logs().w(
            'Unable to delete database, after failed construction',
            e,
            s,
          ),
        );

    // Send error notification:
    final l10n = lookupL10n(PlatformDispatcher.instance.locale);
    ClientManager.sendInitNotification(
      l10n.initAppError,
      l10n.databaseBuildErrorBody(
        AppConfig.newIssueUrl.toString(),
        e.toString(),
      ),
    );

    return FlutterHiveCollectionsDatabase.databaseBuilder(client);
  }
}

Future<MatrixSdkDatabase> _constructDatabase(Client client) async {
  if (kIsWeb) {
    html.window.navigator.storage?.persist();
    return MatrixSdkDatabase(client.clientName);
  }

  final password = await getDatabaseCipher();

  Database database;
  Directory? fileStoragePath;

  if (PlatformInfos.isDesktop) {
    final dbFactory = ffi.createDatabaseFactoryFfi(ffiInit: ffiInit);

    fileStoragePath = await getApplicationSupportDirectory();

    database = await dbFactory.openDatabase(
      '${fileStoragePath.path}/${client.clientName}',
      options: OpenDatabaseOptions(
        version: 1,
        // pass
        onConfigure:
            password == null ? null : (db) => _applySQLCipher(db, password),
      ),
    );
  } else {
    final path = await getApplicationSupportDirectory();
    final sqlFilePath = '$path/${client.clientName}.sqlite';

    // migrating from petty unreliable `getDatabasePath`
    // See : https://pub.dev/packages/sqflite_common_ffi#limitations
    await _migrateLegacyLocation(sqlFilePath, client.clientName);

    fileStoragePath = await getTemporaryDirectory();
    database = await openDatabase(
      sqlFilePath,
      password: password,
    );
  }

  return MatrixSdkDatabase(
    client.clientName,
    database: database,
    maxFileSize: 1024 * 1024 * 10,
    fileStoragePath: fileStoragePath,
    deleteFilesAfterDuration: const Duration(days: 30),
  );
}

Future<void> _migrateLegacyLocation(
  String sqlFilePath,
  String clientName,
) async {
  final oldPath = await getDatabasesPath();
  final oldFilePath = '$oldPath/$clientName.sqlite';
  if (oldFilePath == sqlFilePath) return;

  final maybeOldFile = File(oldFilePath);
  if (await maybeOldFile.exists()) {
    await maybeOldFile.copy(sqlFilePath);
    await maybeOldFile.delete();
  }
}

Future<void> _applySQLCipher(Database db, String cipher) =>
    db.rawQuery("PRAGMA KEY='$cipher'");
