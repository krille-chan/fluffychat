import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:desktop_notifications/desktop_notifications.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:matrix/encryption/utils/key_verification.dart';
import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/custom_http_client.dart';
import 'package:fluffychat/utils/custom_image_resizer.dart';
import 'package:fluffychat/utils/init_with_restore.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/flutter_hive_collections_database.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'matrix_sdk_extensions/flutter_matrix_dart_sdk_database/builder.dart';

abstract class ClientManager {
  static const String clientNamespace = 'im.fluffychat.store.clients';
  static Future<List<Client>> getClients({
    bool initialize = true,
    required SharedPreferences store,
  }) async {
    if (PlatformInfos.isLinux) {
      Hive.init((await getApplicationSupportDirectory()).path);
    } else {
      await Hive.initFlutter();
    }
    final clientNames = <String>{};
    try {
      final clientNamesList = store.getStringList(clientNamespace) ?? [];
      clientNames.addAll(clientNamesList);
    } catch (e, s) {
      Logs().w('Client names in store are corrupted', e, s);
      await store.remove(clientNamespace);
    }
    if (clientNames.isEmpty) {
      clientNames.add(PlatformInfos.clientName);
      await store.setStringList(clientNamespace, clientNames.toList());
    }
    final clients = clientNames.map(createClient).toList();
    if (initialize) {
      await Future.wait(
        clients.map(
          (client) => client.initWithRestore(
            onMigration: () {
              final l10n = lookupL10n(PlatformDispatcher.instance.locale);
              sendInitNotification(
                l10n.databaseMigrationTitle,
                l10n.databaseMigrationBody,
              );
            },
          ).catchError(
            (e, s) => Logs().e('Unable to initialize client', e, s),
          ),
        ),
      );
    }
    if (clients.length > 1 && clients.any((c) => !c.isLogged())) {
      final loggedOutClients = clients.where((c) => !c.isLogged()).toList();
      for (final client in loggedOutClients) {
        Logs().w(
          'Multi account is enabled but client ${client.userID} is not logged in. Removing...',
        );
        clientNames.remove(client.clientName);
        clients.remove(client);
      }
      await store.setStringList(clientNamespace, clientNames.toList());
    }
    return clients;
  }

  static Future<void> addClientNameToStore(
    String clientName,
    SharedPreferences store,
  ) async {
    final clientNamesList = store.getStringList(clientNamespace) ?? [];
    clientNamesList.add(clientName);
    await store.setStringList(clientNamespace, clientNamesList);
  }

  static Future<void> removeClientNameFromStore(
    String clientName,
    SharedPreferences store,
  ) async {
    final clientNamesList = store.getStringList(clientNamespace) ?? [];
    clientNamesList.remove(clientName);
    await store.setStringList(clientNamespace, clientNamesList);
  }

  static NativeImplementations get nativeImplementations => kIsWeb
      ? const NativeImplementationsDummy()
      : NativeImplementationsIsolate(compute);

  static Client createClient(String clientName) {
    return Client(
      clientName,
      httpClient:
          PlatformInfos.isAndroid ? CustomHttpClient.createHTTPClient() : null,
      verificationMethods: {
        KeyVerificationMethod.numbers,
        if (kIsWeb || PlatformInfos.isMobile || PlatformInfos.isLinux)
          KeyVerificationMethod.emoji,
      },
      importantStateEvents: <String>{
        // To make room emotes work
        'im.ponies.room_emotes',
      },
      logLevel: kReleaseMode ? Level.warning : Level.verbose,
      databaseBuilder: flutterMatrixSdkDatabaseBuilder,
      legacyDatabaseBuilder: FlutterHiveCollectionsDatabase.databaseBuilder,
      supportedLoginTypes: {
        AuthenticationTypes.password,
        AuthenticationTypes.sso,
      },
      nativeImplementations: nativeImplementations,
      customImageResizer: PlatformInfos.isMobile ? customImageResizer : null,
      enableDehydratedDevices: true,
    );
  }

  static void sendInitNotification(String title, String body) async {
    if (kIsWeb) {
      html.Notification(
        title,
        body: body,
      );
      return;
    }
    if (Platform.isLinux) {
      await NotificationsClient().notify(
        title,
        body: body,
        appName: AppConfig.applicationName,
        hints: [
          NotificationHint.soundName('message-new-instant'),
        ],
      );
      return;
    }

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('notifications_icon'),
        iOS: DarwinInitializationSettings(),
      ),
    );

    flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'error_message',
          'Error Messages',
          importance: Importance.high,
          priority: Priority.max,
        ),
        iOS: DarwinNotificationDetails(sound: 'notification.caf'),
      ),
    );
  }
}
