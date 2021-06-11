import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:famedlysdk/src/utils/crypto/encrypted_file.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class FlutterFamedlySdkHiveDatabase extends FamedlySdkHiveDatabase {
  FlutterFamedlySdkHiveDatabase(String name, {HiveCipher encryptionCipher})
      : super(
          name,
          encryptionCipher: encryptionCipher,
        ) {
    _clearOldFiles();
    Hive.registerAdapter(EncryptedFileAdapter());
  }

  static bool _hiveInitialized = false;
  static const String _hiveCipherStorageKey = 'hive_encryption_key';

  static Future<FamedlySdkHiveDatabase> hiveDatabaseBuilder(
      Client client) async {
    if (!kIsWeb && !_hiveInitialized) {
      Logs().i('Init Hive database...');
      await Hive.initFlutter();
      _hiveInitialized = true;
    }
    HiveCipher hiverCipher;
    try {
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

      final encryptionKey = base64Url.decode(
        await secureStorage.read(key: _hiveCipherStorageKey),
      );
      hiverCipher = HiveAesCipher(encryptionKey);
    } on MissingPluginException catch (_) {
      Logs()
          .i('Hive encryption is not supported on ${Platform.operatingSystem}');
    }
    final db = FamedlySdkHiveDatabase(
      client.clientName,
      encryptionCipher: hiverCipher,
    );
    Logs().i('Open Hive database...');
    await db.open();
    Logs().i('Hive database is ready!');
    return db;
  }

  @override
  int get maxFileSize => PlatformInfos.isMobile ? 100 * 1024 * 1024 : 0;
  @override
  bool get supportsFileStoring => PlatformInfos.isMobile;

  LazyBox<EncryptedFile> _fileEncryptionKeysBox;
  static const String __fileEncryptionKeysBoxName = 'box.file_encryption_keys';

  @override
  Future<void> open() async {
    await super.open();
    _fileEncryptionKeysBox ??= await Hive.openLazyBox<EncryptedFile>(
      __fileEncryptionKeysBoxName,
      encryptionCipher: encryptionCipher,
    );
  }

  @override
  Future<Uint8List> getFile(String mxcUri) async {
    if (!PlatformInfos.isMobile) return null;
    final tempDirectory = (await getTemporaryDirectory()).path;
    final file = File('$tempDirectory/$mxcUri');
    if (await file.exists() == false) return null;
    final bytes = await file.readAsBytes();
    final encryptedFile = await _fileEncryptionKeysBox.get(mxcUri);
    encryptedFile.data = bytes;
    return await decryptFile(encryptedFile);
  }

  @override
  Future storeFile(String mxcUri, Uint8List bytes, int time) async {
    if (!PlatformInfos.isMobile) return null;
    final tempDirectory = (await getTemporaryDirectory()).path;
    final file = File('$tempDirectory/$mxcUri');
    if (await file.exists()) return;
    final encryptedFile = await encryptFile(bytes);
    await _fileEncryptionKeysBox.put(mxcUri, encryptedFile);
    await file.writeAsBytes(encryptedFile.data);
    return;
  }

  static const int _maxAllowedFileAge = 1000 * 60 * 60 * 24 * 30;

  @override
  Future<void> clear(int clientId) async {
    await super.clear(clientId);
    await _clearOldFiles(true);
  }

  Future<void> _clearOldFiles([bool clearAll = false]) async {
    if (!PlatformInfos.isMobile) return null;
    final tempDirectory = (await getTemporaryDirectory());
    final entities = tempDirectory.listSync();
    for (final entity in entities) {
      final file = File(entity.path);
      final createdAt = await file.lastModified();
      final age = DateTime.now().millisecondsSinceEpoch -
          createdAt.millisecondsSinceEpoch;
      if (clearAll || age > _maxAllowedFileAge) {
        final mxcUri = file.path.split('/').last;
        Logs().v('Delete old cashed file: $mxcUri');
        await file.delete();
        await _fileEncryptionKeysBox.delete(mxcUri);
      }
    }
  }
}

class EncryptedFileAdapter extends TypeAdapter<EncryptedFile> {
  @override
  final typeId = 0;

  @override
  EncryptedFile read(BinaryReader reader) {
    final map = reader.read();
    return EncryptedFile(k: map['k'], iv: map['iv'], sha256: map['sha256']);
  }

  @override
  void write(BinaryWriter writer, EncryptedFile obj) {
    writer.write({'k': obj.k, 'iv': obj.iv, 'sha256': obj.sha256});
  }
}
