import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' hide Key;
import 'package:flutter/services.dart';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

import '../platform_infos.dart';
import 'codec.dart';

class FlutterMatrixSembastDatabaseOld extends MatrixSembastDatabase {
  FlutterMatrixSembastDatabaseOld(
    String name, {
    SembastCodec codec,
    String path,
    DatabaseFactory dbFactory,
  }) : super(
          name,
          codec: codec,
          path: path,
          dbFactory: dbFactory,
        );

  static const String _cipherStorageKey = 'sembast_encryption_key';
  static const int _cipherStorageKeyLength = 512;

  static Future<FlutterMatrixSembastDatabaseOld> databaseBuilder(
      Client client) async {
    Logs().d('Open Sembast...');
    SembastCodec codec;
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

      codec = getEncryptSembastCodec(password: rawEncryptionKey);
    } on MissingPluginException catch (_) {
      Logs().i('Sembast encryption is not supported on this platform');
    }

    final db = FlutterMatrixSembastDatabaseOld(
      client.clientName,
      codec: codec,
      path: await _findDatabasePath(client),
      dbFactory: kIsWeb ? databaseFactoryWeb : databaseFactoryIo,
    );
    await db.open();
    Logs().d('Sembast is ready');
    return db;
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
