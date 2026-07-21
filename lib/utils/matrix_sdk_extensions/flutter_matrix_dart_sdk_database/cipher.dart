// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'dart:convert';
import 'dart:math';

import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/client_manager.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrix/matrix.dart';

const _passwordStorageKey = 'database_password';

Future<String?> getDatabaseCipher() async {
  String? password;

  const iosOptions = IOSOptions(groupId: 'group.im.fluffychat.app');

  try {
    password = await FlutterSecureStorage(
      iOptions: iosOptions,
    ).read(key: _passwordStorageKey, iOptions: iosOptions);
    if (password != null) return password;

    if (PlatformInfos.isIOS) {
      final legacyPassword = await FlutterSecureStorage().read(
        key: _passwordStorageKey,
      );
      if (legacyPassword != null) {
        Logs().i('Migrate database key location on iOS...');
        await FlutterSecureStorage().delete(key: _passwordStorageKey);
        await FlutterSecureStorage(iOptions: iosOptions).write(
          key: _passwordStorageKey,
          value: legacyPassword,
          iOptions: iosOptions,
        );
        return legacyPassword;
      }
    }

    final rng = Random.secure();
    final list = Uint8List(32);
    list.setAll(0, Iterable.generate(list.length, (i) => rng.nextInt(256)));
    final newPassword = base64UrlEncode(list);
    await FlutterSecureStorage(
      iOptions: iosOptions,
    ).write(key: _passwordStorageKey, value: newPassword, iOptions: iosOptions);
    // workaround for if we just wrote to the key and it still doesn't exist
    password = await FlutterSecureStorage(
      iOptions: iosOptions,
    ).read(key: _passwordStorageKey, iOptions: iosOptions);
    if (password == null) throw MissingPluginException();
    return password;
  } on MissingPluginException catch (e) {
    FlutterSecureStorage(
      iOptions: iosOptions,
    ).delete(key: _passwordStorageKey, iOptions: iosOptions).catchError((_) {});
    Logs().w('Database encryption is not supported on this platform', e);
    _sendNoEncryptionWarning(e);
  } catch (e, s) {
    FlutterSecureStorage(
      iOptions: iosOptions,
    ).delete(key: _passwordStorageKey, iOptions: iosOptions).catchError((_) {});
    Logs().w('Unable to init database encryption', e, s);
    _sendNoEncryptionWarning(e);
  }
  return null;
}

Future<void> _sendNoEncryptionWarning(Object exception) async {
  final isStored = AppSettings.noEncryptionWarningShown.value;

  if (isStored == true) return;

  final l10n = await lookupL10n(PlatformDispatcher.instance.locale);
  ClientManager.sendInitNotification(
    l10n.noDatabaseEncryption,
    exception.toString(),
  );

  await AppSettings.noEncryptionWarningShown.setItem(true);
}
