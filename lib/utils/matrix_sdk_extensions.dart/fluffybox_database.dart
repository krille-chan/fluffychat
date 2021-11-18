//@dart=2.12

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' hide Key;
import 'package:flutter/services.dart';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as ffi;
import 'package:sqflite_sqlcipher/sqflite.dart' as sqflite;

class FlutterFluffyBoxDatabase extends FluffyBoxDatabase {
  FlutterFluffyBoxDatabase(
    String name, {
    Future<sqflite.Database> Function()? openSqlDatabase,
  }) : super(
          name,
          openSqlDatabase: openSqlDatabase,
        );

  static const String _cipherStorageKey = 'database_encryption_key';
  static const int _cipherStorageKeyLength = 512;

  static Future<FluffyBoxDatabase> databaseBuilder(Client client) async {
    Logs().d('Open FluffyBox...');
    String? password;
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      try {
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
        password = await secureStorage.read(key: _cipherStorageKey);
        if (password == null) throw MissingPluginException();
      } on MissingPluginException catch (_) {
        Logs().i('FluffyBox encryption is not supported on this platform');
      }
    }

    final db = FluffyBoxDatabase(
      'fluffybox_${client.clientName.replaceAll(' ', '_').toLowerCase()}',
      openSqlDatabase: kIsWeb ? null : () => _openSqlDatabase(client, password),
    );
    await db.open();
    Logs().d('FluffyBox is ready');
    return db;
  }

  static Future<sqflite.Database> _openSqlDatabase(
    Client client,
    String? password,
  ) async {
    final path = await _findDatabasePath(client);
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final db = await sqflite.openDatabase(
          path,
          password: password,
          onConfigure: (db) async {
            await db.execute('PRAGMA page_size = 8192');
            await db.execute('PRAGMA cache_size = 16384');
            await db.execute('PRAGMA temp_store = MEMORY');
            await db.rawQuery('PRAGMA journal_mode = WAL');
          },
        );
        return db;
      }
      final db = await ffi.databaseFactoryFfi.openDatabase(path);
      return db;
    } catch (_) {
      File(path).delete();
      rethrow;
    }
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
      path =
          '${directory.path}${client.clientName.replaceAll(' ', '-')}.sqflite';
    }
    return path;
  }

  @override
  int get maxFileSize => supportsFileStoring ? 100 * 1024 * 1024 : 0;
  @override
  bool get supportsFileStoring => !kIsWeb;

  Future<String> _getFileStoreDirectory() async {
    try {
      try {
        return (await getApplicationSupportDirectory()).path;
      } catch (_) {
        return (await getApplicationDocumentsDirectory()).path;
      }
    } catch (_) {
      return (await getDownloadsDirectory())!.path;
    }
  }

  @override
  Future<Uint8List?> getFile(Uri mxcUri) async {
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
