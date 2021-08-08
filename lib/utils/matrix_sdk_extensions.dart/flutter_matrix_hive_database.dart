import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:matrix/matrix.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../platform_infos.dart';

class FlutterMatrixHiveStore extends FamedlySdkHiveDatabase {
  FlutterMatrixHiveStore(String name, {HiveCipher encryptionCipher})
      : super(
          name,
          encryptionCipher: encryptionCipher,
        );

  Box _customBox;
  String get _customBoxName => '$name.box.custom';

  static bool _hiveInitialized = false;
  static const String _hiveCipherStorageKey = 'hive_encryption_key';

  @override
  Future<void> open() async {
    await super.open();
    _customBox = await Hive.openBox(
      _customBoxName,
      encryptionCipher: encryptionCipher,
    );
    return;
  }

  @override
  Future<void> clear(int clientId) async {
    await super.clear(clientId);
    await _customBox.deleteAll(_customBox.keys);
    await _customBox.close();
  }

  dynamic get(dynamic key) => _customBox.get(key);
  Future<void> put(dynamic key, dynamic value) => _customBox.put(key, value);

  static Future<FamedlySdkHiveDatabase> hiveDatabaseBuilder(
      Client client) async {
    if (!kIsWeb && !_hiveInitialized) {
      Logs().i('Init Hive database...');
      if (PlatformInfos.isLinux) {
        Hive.init((await getApplicationSupportDirectory()).path);
      } else {
        await Hive.initFlutter();
      }
      _hiveInitialized = true;
    }
    HiveCipher hiverCipher;
    try {
      // Workaround for secure storage is calling Platform.operatingSystem on web
      if (kIsWeb) throw MissingPluginException();

      final secureStorage = const FlutterSecureStorage();
      final containsEncryptionKey =
          await secureStorage.containsKey(key: _hiveCipherStorageKey);
      if (!containsEncryptionKey) {
        final key = Hive.generateSecureKey();
        await secureStorage.write(
          key: _hiveCipherStorageKey,
          value: base64UrlEncode(key),
        );
      }

      // workaround for if we just wrote to the key and it still doesn't exist
      final rawEncryptionKey =
          await secureStorage.read(key: _hiveCipherStorageKey);
      if (rawEncryptionKey == null) throw MissingPluginException();

      final encryptionKey = base64Url.decode(rawEncryptionKey);
      hiverCipher = HiveAesCipher(encryptionKey);
    } on MissingPluginException catch (_) {
      Logs().i('Hive encryption is not supported on this platform');
    }
    final db = FlutterMatrixHiveStore(
      client.clientName,
      encryptionCipher: hiverCipher,
    );
    Logs().i('Open Hive database...');
    try {
      await db.open();
    } catch (e, s) {
      Logs().e('Unable to open Hive. Delete and try again...', e, s);
      await Hive.deleteFromDisk();
      await db.open();
    }
    Logs().i('Hive database is ready!');
    return db;
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
  Future<Uint8List> getFile(String mxcUri) async {
    if (!supportsFileStoring) return null;
    final tempDirectory = await _getFileStoreDirectory();
    final file = File('$tempDirectory/${Uri.encodeComponent(mxcUri)}');
    if (await file.exists() == false) return null;
    final bytes = await file.readAsBytes();
    return bytes;
  }

  @override
  Future storeFile(String mxcUri, Uint8List bytes, int time) async {
    if (!supportsFileStoring) return null;
    final tempDirectory = await _getFileStoreDirectory();
    final file = File('$tempDirectory/${Uri.encodeComponent(mxcUri)}');
    if (await file.exists()) return;
    await file.writeAsBytes(bytes);
    return;
  }
}
