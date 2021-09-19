import 'dart:convert';

import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/foundation.dart';
import 'package:matrix/encryption/utils/key_verification.dart';
import 'package:matrix/matrix.dart';

import 'famedlysdk_store.dart';
import 'matrix_sdk_extensions.dart/flutter_matrix_hive_database.dart';

abstract class ClientManager {
  static const String clientNamespace = 'im.fluffychat.store.clients';
  static Future<List<Client>> getClients() async {
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
    if (clientNames.isEmpty) clientNames.add(PlatformInfos.clientName);
    final clients = clientNames.map(createClient).toList();
    await Future.wait(clients.map((client) => client
        .init()
        .catchError((e, s) => Logs().e('Unable to initialize client', e, s))));
    if (clients.length > 1 && clients.any((c) => !c.isLogged())) {
      final loggedOutClients = clients.where((c) => !c.isLogged()).toList();
      for (final client in loggedOutClients) {
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

  static Client createClient(String clientName) => Client(
        clientName,
        enableE2eeRecovery: true,
        verificationMethods: {
          KeyVerificationMethod.numbers,
          if (PlatformInfos.isMobile || PlatformInfos.isLinux)
            KeyVerificationMethod.emoji,
        },
        importantStateEvents: <String>{
          'im.ponies.room_emotes', // we want emotes to work properly
        },
        databaseBuilder: FlutterMatrixHiveStore.hiveDatabaseBuilder,
        supportedLoginTypes: {
          AuthenticationTypes.password,
          if (PlatformInfos.isMobile || PlatformInfos.isWeb)
            AuthenticationTypes.sso
        },
        compute: compute,
      );
}
