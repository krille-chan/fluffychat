import 'dart:async';
import 'dart:core';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';

import 'package:fluffychat/utils/platform_infos.dart';

// see https://github.com/mogol/flutter_secure_storage/issues/161#issuecomment-704578453
class AsyncMutex {
  Completer<void>? _completer;

  Future<void> lock() async {
    while (_completer != null) {
      await _completer!.future;
    }

    _completer = Completer<void>();
  }

  void unlock() {
    assert(_completer != null);
    final completer = _completer!;
    _completer = null;
    completer.complete();
  }
}

class Store {
  LocalStorage? storage;
  final FlutterSecureStorage? secureStorage;
  static final _mutex = AsyncMutex();

  Store()
      : secureStorage =
            PlatformInfos.isMobile ? const FlutterSecureStorage() : null;

  Future<void> _setupLocalStorage() async {
    if (storage == null) {
      final directory = PlatformInfos.isBetaDesktop
          ? await getApplicationSupportDirectory()
          : (PlatformInfos.isWeb
              ? null
              : await getApplicationDocumentsDirectory());
      storage = LocalStorage('LocalStorage', directory?.path);
      await storage!.ready;
    }
  }

  Future<String?> getItem(String key) async {
    if (!PlatformInfos.isMobile) {
      await _setupLocalStorage();
      try {
        return storage!.getItem(key)?.toString();
      } catch (_) {
        return null;
      }
    }
    try {
      await _mutex.lock();
      return await secureStorage!.read(key: key);
    } catch (_) {
      return null;
    } finally {
      _mutex.unlock();
    }
  }

  Future<bool?> getItemBool(String key, [bool? defaultValue]) async {
    final value = await getItem(key);
    if (value == null) {
      return defaultValue;
    }
    // we also check for '1' for legacy reasons, some booleans were stored that way
    return value == '1' || value.toLowerCase() == 'true';
  }

  Future<void> setItem(String key, String? value) async {
    if (!PlatformInfos.isMobile) {
      await _setupLocalStorage();
      return await storage!.setItem(key, value);
    }
    try {
      await _mutex.lock();
      return await secureStorage!.write(key: key, value: value);
    } finally {
      _mutex.unlock();
    }
  }

  Future<void> setItemBool(String key, bool value) async {
    await setItem(key, value.toString());
  }

  Future<void> deleteItem(String key) async {
    if (!PlatformInfos.isMobile) {
      await _setupLocalStorage();
      return await storage!.deleteItem(key);
    }
    try {
      await _mutex.lock();
      return await secureStorage!.delete(key: key);
    } finally {
      _mutex.unlock();
    }
  }
}
