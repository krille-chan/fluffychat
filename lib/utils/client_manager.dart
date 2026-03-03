import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:collection/collection.dart';
import 'package:desktop_notifications/desktop_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_vodozemac/flutter_vodozemac.dart' as vod;
import 'package:matrix/encryption/utils/key_verification.dart';
import 'package:matrix/matrix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;

import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/pangea/events/constants/pangea_event_types.dart';
import 'package:fluffychat/pangea/events/extensions/pangea_event_extension.dart';
import 'package:fluffychat/utils/custom_http_client.dart';
import 'package:fluffychat/utils/init_with_restore.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'matrix_sdk_extensions/flutter_matrix_dart_sdk_database/builder.dart';

abstract class ClientManager {
  static const String clientNamespace = 'im.fluffychat.store.clients';

  static Future<List<Client>> getClients({
    bool initialize = true,
    required SharedPreferences store,
  }) async {
    final clientNames = <String>{};
    try {
      final clientNamesList = store.getStringList(clientNamespace) ?? [];
      Logs().i('Found client names in store: $clientNamesList');
      clientNames.addAll(clientNamesList);
    } catch (e, s) {
      Logs().w('Client names in store are corrupted', e, s);
      await store.remove(clientNamespace);
    }
    if (clientNames.isEmpty) {
      Logs().i(
        'No client names found, adding default client name ${PlatformInfos.clientName}',
      );
      clientNames.add(PlatformInfos.clientName);
      await store.setStringList(clientNamespace, clientNames.toList());
    }
    final clients = await Future.wait(
      clientNames.map((name) => createClient(name, store)),
    );
    if (initialize) {
      await Future.wait(
        clients.map(
          (client) => client
              .initWithRestore(
                onMigration: () async {
                  // #Pangea
                  // final l10n = await lookupL10n(
                  //   PlatformDispatcher.instance.locale,
                  // );
                  // sendInitNotification(
                  //   l10n.databaseMigrationTitle,
                  //   l10n.databaseMigrationBody,
                  // );
                  // Pangea#
                },
              )
              .catchError(
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
    Logs().i('Adding client name $clientName to store');
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
      ? NativeImplementationsWebWorker(
          Uri.parse('native_executor.js'),
          timeout: const Duration(minutes: 1),
        )
      : NativeImplementationsIsolate(
          compute,
          vodozemacInit: () => vod.init(wasmPath: './assets/assets/vodozemac/'),
        );

  static Future<Client> createClient(
    String clientName,
    SharedPreferences store,
  ) async {
    final shareKeysWith = AppSettings.shareKeysWith.value;
    final enableSoftLogout = AppSettings.enableSoftLogout.value;

    return Client(
      clientName,
      httpClient: CustomHttpClient.createHTTPClient(),
      verificationMethods: {
        KeyVerificationMethod.numbers,
        if (kIsWeb || PlatformInfos.isMobile || PlatformInfos.isLinux)
          KeyVerificationMethod.emoji,
      },
      importantStateEvents: <String>{
        // To make room emotes work
        'im.ponies.room_emotes',
        // #Pangea
        // The things in this list will be loaded in the first sync, without having
        // to postLoad to confirm that these state events are completely loaded
        EventTypes.RoomPowerLevels,
        EventTypes.RoomJoinRules,
        PangeaEventTypes.botOptions,
        PangeaEventTypes.capacity,
        PangeaEventTypes.userSetLemmaInfo,
        PangeaEventTypes.activityPlan,
        PangeaEventTypes.activityRole,
        PangeaEventTypes.activitySummary,
        PangeaEventTypes.activityRoomIds,
        PangeaEventTypes.coursePlan,
        PangeaEventTypes.teacherMode,
        PangeaEventTypes.courseChatList,
        PangeaEventTypes.analyticsSettings,
        // Pangea#
      },
      logLevel: kReleaseMode ? Level.warning : Level.verbose,
      database: await flutterMatrixSdkDatabaseBuilder(clientName),
      supportedLoginTypes: {
        AuthenticationTypes.password,
        AuthenticationTypes.sso,
      },
      nativeImplementations: nativeImplementations,
      defaultNetworkRequestTimeout: const Duration(minutes: 30),
      enableDehydratedDevices: true,
      shareKeysWith:
          ShareKeysWith.values.singleWhereOrNull(
            (share) => share.name == shareKeysWith,
          ) ??
          ShareKeysWith.all,
      convertLinebreaksInFormatting: false,
      onSoftLogout: enableSoftLogout
          ? (client) => client.refreshAccessToken()
          : null,
      // #Pangea
      shouldReplaceRoomLastEvent: (_, event) => event.isVisibleLastEvent,
      enableLastEventRefresh: false,
      roomPreviewLastEvents: {
        PangeaEventTypes.botOptions,
        PangeaEventTypes.activityPlan,
        PangeaEventTypes.activitySummary,
        EventTypes.RoomMember,
      },
      // Pangea#
    );
  }

  static void sendInitNotification(String title, String body) async {
    if (kIsWeb) {
      html.Notification(title, body: body);
      return;
    }
    if (Platform.isLinux) {
      await NotificationsClient().notify(
        title,
        body: body,
        appName: AppSettings.applicationName.value,
        hints: [NotificationHint.soundName('message-new-instant')],
      );
      return;
    }

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        // #Pangea
        // android: AndroidInitializationSettings('notifications_icon'),
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        // Pangea#
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
