import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrix/matrix.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluffychat/config/setting_keys.dart';

const _passwordStorageKey = 'database_password';

Future<String?> getDatabaseCipher() async {
  String? password;

  try {
    // #Pangea
    // mogol/flutter_secure_storage#532
    // mogol/flutter_secure_storage#524
    // Pangea#
    const secureStorage = FlutterSecureStorage(
      // #Pangea
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
      // Pangea#
    );
    // #Pangea
    await secureStorage.read(key: _passwordStorageKey);
    // Pangea#
    final containsEncryptionKey =
        await secureStorage.read(key: _passwordStorageKey) != null;
    // #Pangea
    Sentry.addBreadcrumb(
      Breadcrumb(message: 'containsEncryptionKey: $containsEncryptionKey'),
    );
    // Pangea#
    if (!containsEncryptionKey) {
      final rng = Random.secure();
      final list = Uint8List(32);
      list.setAll(0, Iterable.generate(list.length, (i) => rng.nextInt(256)));
      final newPassword = base64UrlEncode(list);
      await secureStorage.write(
        key: _passwordStorageKey,
        value: newPassword,
      );
    }
    // workaround for if we just wrote to the key and it still doesn't exist
    password = await secureStorage.read(key: _passwordStorageKey);
    if (password == null) {
      throw MissingPluginException(
        // #Pangea
        "password is null after storing new password",
        // Pangea#
      );
    }
  } on MissingPluginException catch (e) {
    const FlutterSecureStorage()
        .delete(key: _passwordStorageKey)
        .catchError((_) {});
    Logs().w('Database encryption is not supported on this platform', e);
    // #Pangea
    Sentry.addBreadcrumb(
      Breadcrumb(
        message:
            'Database encryption is not supported on this platform. Error message: ${e.message}',
        data: {'exception': e},
      ),
    );
    // Pangea#
    _sendNoEncryptionWarning(e);
  } catch (e, s) {
    const FlutterSecureStorage()
        .delete(key: _passwordStorageKey)
        .catchError((_) {});
    Logs().w('Unable to init database encryption', e, s);
    // #Pangea
    Sentry.addBreadcrumb(
      Breadcrumb(
        message: 'Unable to init database encryption',
        data: {'exception': e, 'stackTrace': s},
      ),
    );
    // Pangea#
    _sendNoEncryptionWarning(e);
  }

  return password;
}

void _sendNoEncryptionWarning(Object exception) async {
  final store = await SharedPreferences.getInstance();
  final isStored = AppSettings.noEncryptionWarningShown.getItem(store);

  if (isStored == true) return;

  // #Pangea
  Sentry.addBreadcrumb(
    Breadcrumb(
      message: 'No database encryption',
      data: {'exception': exception},
    ),
  );
  // final l10n = await lookupL10n(PlatformDispatcher.instance.locale);
  // ClientManager.sendInitNotification(
  //   l10n.noDatabaseEncryption,
  //   exception.toString(),
  // );
  // Pangea#

  await AppSettings.noEncryptionWarningShown.setItem(store, true);
}
