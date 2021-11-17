import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' hide Key;
import 'package:flutter/services.dart';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../platform_infos.dart';

class FlutterFluffyBoxDatabase extends FluffyBoxDatabase {
  FlutterFluffyBoxDatabase(
    String name, {
    String path,
    Future<sqflite.Database> Function() openSqlDatabase,
  }) : super(
          name,
          openSqlDatabase: openSqlDatabase,
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
      'fluffybox_${client.clientName.replaceAll(' ', '_').toLowerCase()}',
      openSqlDatabase: () => _openSqlDatabase(client),
    );
    await db.open();
    Logs().d('FluffyBox is ready');
    return db;
  }

  static Future<sqflite.Database> _openSqlDatabase(Client client) async {
    final path = await _findDatabasePath(client);
    return await sqflite.openDatabase(path);
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
