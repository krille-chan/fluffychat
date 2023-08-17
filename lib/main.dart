import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/client_manager.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'config/setting_keys.dart';
import 'utils/background_push.dart';
import 'widgets/fluffy_chat_app.dart';
import 'widgets/lock_screen.dart';

void main() async {
  Logs().i('Welcome to FluffyChat');

  // Our background push shared isolate accesses flutter-internal things very early in the startup proccess
  // To make sure that the parts of flutter needed are started up already, we need to ensure that the
  // widget bindings are initialized already.
  WidgetsFlutterBinding.ensureInitialized();

  Logs().nativeColors = !PlatformInfos.isIOS;
  final clients = await ClientManager.getClients();

  // Preload first client
  final firstClient = clients.firstOrNull;
  await firstClient?.roomsLoading;
  await firstClient?.accountDataLoading;

  String? pin;
  if (PlatformInfos.isMobile) {
    for(client in clients) {
      BackgroundPush.clientOnly(clients);
    }
    try {
      pin =
          await const FlutterSecureStorage().read(key: SettingKeys.appLockKey);
    } catch (e, s) {
      Logs().d('Unable to read PIN from Secure storage', e, s);
    }
  }

  runApp(
    PlatformInfos.isMobile
        ? AppLock(
            builder: (args) => FluffyChatApp(clients: clients),
            lockScreen: const LockScreen(),
            enabled: pin?.isNotEmpty ?? false,
          )
        : FluffyChatApp(clients: clients),
  );
}
