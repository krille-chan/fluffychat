import 'dart:async';
import 'dart:core';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';

import 'package:fluffychat/utils/platform_infos.dart';

// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  FlutterSecureStorage? secureStorage;

  LocalStorage? storage;
  static final _mutex = AsyncMutex();

  Future<void> _setupLocalStorage() async {
    if (PlatformInfos.isMobile) {
      if (PlatformInfos.isAndroid) {
        return DeviceInfoPlugin().androidInfo.then((info) {
          if ((info.version.sdkInt ?? 16) >= 19) {
            secureStorage = const FlutterSecureStorage();
          }
        });
      } else {
        secureStorage = const FlutterSecureStorage();
      }
    } else {
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
  }

  Future<String?> getItem(String key) async {
    final storage = this.storage;
    if (!PlatformInfos.isMobile && storage != null) {
      await _setupLocalStorage();
      try {
        return storage.getItem(key)?.toString();
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
    await _setupLocalStorage();
    if (!PlatformInfos.isMobile) {
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
