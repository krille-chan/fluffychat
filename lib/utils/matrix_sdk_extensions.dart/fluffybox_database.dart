import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' hide Key;
import 'package:flutter/services.dart';
import 'package:idb_shim/idb_browser.dart';
import 'package:idb_shim/idb.dart' hide Event;
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:idb_sqflite/idb_sqflite.dart';
import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';

import '../platform_infos.dart';

class FluffyBoxDatabase extends MatrixIndexedDatabase {
  FluffyBoxDatabase(
    String name, {
    String path,
    IdbFactory dbFactory,
  }) : super(
          name,
          path,
          factory: dbFactory,
        );

  static const String _cipherStorageKey = 'database_encryption_key';
  static const int _cipherStorageKeyLength = 512;

  static Future<FluffyBoxDatabase> databaseBuilder(Client client) async {
    Logs().d('Open FluffyBox...');
    try {
      // Workaround for secure storage is calling Platform.operatingSystem on web
      if (kIsWeb) throw MissingPluginException();

      const secureStorage = FlutterSecureStorage();
      final containsEncryptionKey =
          await secureStorage.containsKey(key: _cipherStorageKey);
      if (!containsEncryptionKey) {
        final key = SecureRandom(_cipherStorageKeyLength).base64;
        await secureStorage.write(
          key: _cipherStorageKey,
          value: key,
        );
      }

      // workaround for if we just wrote to the key and it still doesn't exist
      final rawEncryptionKey = await secureStorage.read(key: _cipherStorageKey);
      if (rawEncryptionKey == null) throw MissingPluginException();
    } on MissingPluginException catch (_) {
      Logs().i('FluffyBox encryption is not supported on this platform');
    }

    final db = FluffyBoxDatabase(
      'FluffyBox-${client.clientName}',
      path: await _findDatabasePath(client),
      dbFactory: factory,
    );
    await db.open();
    Logs().d('FluffyBox is ready');
    return db;
  }

  static IdbFactory get factory {
    if (kIsWeb) return idbFactoryBrowser;
    if (Platform.isAndroid || Platform.isIOS) {
      return getIdbFactorySqflite(sqflite.databaseFactory);
    }
    return idbFactoryNative;
  }

  static Future<String> _findDatabasePath(Client client) async {
    String path = client.clientName;
    if (!kIsWeb) {
      Directory directory;
      try {
        directory = await getApplicationSupportDirectory();
      } catch (_) {
        try {
          directory = await getLibraryDirectory();
        } catch (_) {
          directory = Directory.current;
        }
      }
      path = '${directory.path}${client.clientName}.db';
    }
    return path;
  }

  @override
  int get maxFileSize => supportsFileStoring ? 100 * 1024 * 1024 : 0;
  @override
  bool get supportsFileStoring => (PlatformInfos.isIOS ||
      PlatformInfos.isAndroid ||
      PlatformInfos.isDesktop);

  Future<String> _getFileStoreDirectory() async {
    try {
      try {
        return (await getApplicationSupportDirectory()).path;
      } catch (_) {
        return (await getApplicationDocumentsDirectory()).path;
      }
    } catch (_) {
      return (await getDownloadsDirectory()).path;
    }
  }

  @override
  Future<Uint8List> getFile(Uri mxcUri) async {
    if (!supportsFileStoring) return null;
    final tempDirectory = await _getFileStoreDirectory();
    final file =
        File('$tempDirectory/${Uri.encodeComponent(mxcUri.toString())}');
    if (await file.exists() == false) return null;
    final bytes = await file.readAsBytes();
    return bytes;
  }

  @override
  Future storeFile(Uri mxcUri, Uint8List bytes, int time) async {
    if (!supportsFileStoring) return null;
    final tempDirectory = await _getFileStoreDirectory();
    final file =
        File('$tempDirectory/${Uri.encodeComponent(mxcUri.toString())}');
    if (await file.exists()) return;
    await file.writeAsBytes(bytes);
    return;
  }
}
