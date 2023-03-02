import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:matrix/encryption/utils/key_verification.dart';
import 'package:matrix/matrix.dart';
import 'package:path_provider/path_provider.dart';

import 'package:fluffychat/utils/custom_http_client.dart';
import 'package:fluffychat/utils/custom_image_resizer.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/flutter_hive_collections_database.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'famedlysdk_store.dart';

abstract class ClientManager {
  static const String clientNamespace = 'im.fluffychat.store.clients';
  static Future<List<Client>> getClients({bool initialize = true}) async {
    if (PlatformInfos.isLinux) {
      Hive.init((await getApplicationSupportDirectory()).path);
    } else {
      await Hive.initFlutter();
    }
    final clientNames = <String>{};
    try {
      final rawClientNames = await Store().getItem(clientNamespace);
      if (rawClientNames != null) {
        final clientNamesList =
            (jsonDecode(rawClientNames) as List).cast<String>();
        clientNames.addAll(clientNamesList);
      }
    } catch (e, s) {
      Logs().w('Client names in store are corrupted', e, s);
      await Store().deleteItem(clientNamespace);
    }
    if (clientNames.isEmpty) {
      clientNames.add(PlatformInfos.clientName);
      await Store().setItem(clientNamespace, jsonEncode(clientNames.toList()));
    }
    final clients = clientNames.map(createClient).toList();
    if (initialize) {
      await Future.wait(
        clients.map(
          (client) => client
              .init(
                waitForFirstSync: false,
                waitUntilLoadCompletedLoaded: false,
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
      await Store().setItem(clientNamespace, jsonEncode(clientNames.toList()));
    }
    return clients;
  }

  static Future<void> addClientNameToStore(String clientName) async {
    final clientNamesList = <String>[];
    final rawClientNames = await Store().getItem(clientNamespace);
    if (rawClientNames != null) {
      final stored = (jsonDecode(rawClientNames) as List).cast<String>();
      clientNamesList.addAll(stored);
    }
    clientNamesList.add(clientName);
    await Store().setItem(clientNamespace, jsonEncode(clientNamesList));
  }

  static Future<void> removeClientNameFromStore(String clientName) async {
    final clientNamesList = <String>[];
    final rawClientNames = await Store().getItem(clientNamespace);
    if (rawClientNames != null) {
      final stored = (jsonDecode(rawClientNames) as List).cast<String>();
      clientNamesList.addAll(stored);
    }
    clientNamesList.remove(clientName);
    await Store().setItem(clientNamespace, jsonEncode(clientNamesList));
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
        // To check which story room we can post in
        EventTypes.RoomPowerLevels,
      },
      logLevel: kReleaseMode ? Level.warning : Level.verbose,
      databaseBuilder: FlutterHiveCollectionsDatabase.databaseBuilder,
      supportedLoginTypes: {
        AuthenticationTypes.password,
        if (PlatformInfos.isMobile ||
            PlatformInfos.isWeb ||
            PlatformInfos.isMacOS)
          AuthenticationTypes.sso
      },
      nativeImplementations: nativeImplementations,
      customImageResizer: PlatformInfos.isMobile ? customImageResizer : null,
    );
  }
}
