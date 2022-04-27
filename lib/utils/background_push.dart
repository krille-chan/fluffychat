/*
 *   Famedly
 *   Copyright (C) 2020, 2021 Famedly GmbH
 *   Copyright (C) 2021 Fluffychat
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU Affero General Public License as
 *   published by the Free Software Foundation, either version 3 of the
 *   License, or (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   GNU Affero General Public License for more details.
 *
 *   You should have received a copy of the GNU Affero General Public License
 *   along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:matrix/matrix.dart';
import 'package:unifiedpush/unifiedpush.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/utils/matrix_sdk_extensions.dart/client_stories_extension.dart';
import 'package:fluffychat/utils/push_helper.dart';
import '../config/app_config.dart';
import '../config/setting_keys.dart';
import 'famedlysdk_store.dart';
import 'platform_infos.dart';

class NoTokenException implements Exception {
  String get cause => 'Cannot get firebase token';
}

class BackgroundPush {
  static BackgroundPush? _instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Client client;
  BuildContext? context;
  GlobalKey<VRouterState>? router;
  void Function(String errorMsg, {Uri? link})? onFcmError;
  L10n? l10n;
  Store? _store;
  Store get store => _store ??= Store();
  Future<void> loadLocale() async {
    // inspired by _lookupL10n in .dart_tool/flutter_gen/gen_l10n/l10n.dart
    l10n ??= (context != null ? L10n.of(context!) : null) ??
        (await L10n.delegate.load(window.locale));
  }

  final pendingTests = <String, Completer<void>>{};

  DateTime? lastReceivedPush;

  bool upAction = false;

  BackgroundPush._(this.client, {this.onFcmError}) {
    onLogin ??=
        client.onLoginStateChanged.stream.listen(handleLoginStateChanged);
    onRoomSync ??= client.onSync.stream
        .where((s) => s.hasRoomUpdate)
        .listen((s) => _onClearingPush(getFromServer: false));
    if (Platform.isAndroid) {
      UnifiedPush.initialize(
        onNewEndpoint: _newUpEndpoint,
        onRegistrationFailed: _upUnregistered,
        onUnregistered: _upUnregistered,
        onMessage: _onUpMessage,
      );
    }
  }

  factory BackgroundPush.clientOnly(Client client) {
    _instance ??= BackgroundPush._(client);
    return _instance!;
  }

  factory BackgroundPush(
      Client _client, BuildContext _context, GlobalKey<VRouterState>? router,
      {final void Function(String errorMsg, {Uri? link})? onFcmError}) {
    final instance = BackgroundPush.clientOnly(_client);
    instance.context = _context;
    // ignore: prefer_initializing_formals
    instance.router = router;
    // ignore: prefer_initializing_formals
    instance.onFcmError = onFcmError;
    instance.fullInit();
    return instance;
  }

  Future<void> fullInit() => setupPush();

  void handleLoginStateChanged(_) => setupPush();

  StreamSubscription<LoginState>? onLogin;
  StreamSubscription<SyncUpdate>? onRoomSync;

  Future<void> setupPusher({
    String? gatewayUrl,
    String? token,
    Set<String?>? oldTokens,
    bool useDeviceSpecificAppId = false,
  }) async {
    print('Setup pusher $gatewayUrl $token');
    final clientName = PlatformInfos.clientName;
    oldTokens ??= <String>{};
    final pushers = await (client.getPushers().catchError((e) {
          Logs().w('[Push] Unable to request pushers', e);
          return <Pusher>[];
        })) ??
        [];
    var setNewPusher = false;
    // Just the plain app id, we add the .data_message suffix later
    var appId = AppConfig.pushNotificationsAppId;
    // we need the deviceAppId to remove potential legacy UP pusher
    var deviceAppId = '$appId.${client.deviceID}';
    // appId may only be up to 64 chars as per spec
    if (deviceAppId.length > 64) {
      deviceAppId = deviceAppId.substring(0, 64);
    }
    if (!useDeviceSpecificAppId && PlatformInfos.isAndroid) {
      appId += '.data_message';
    }
    final thisAppId = useDeviceSpecificAppId ? deviceAppId : appId;
    if (gatewayUrl != null && token != null) {
      final currentPushers = pushers.where((pusher) => pusher.pushkey == token);
      if (currentPushers.length == 1 &&
          currentPushers.first.kind == 'http' &&
          currentPushers.first.appId == thisAppId &&
          currentPushers.first.appDisplayName == clientName &&
          currentPushers.first.deviceDisplayName == client.deviceName &&
          currentPushers.first.lang == 'en' &&
          currentPushers.first.data.url.toString() == gatewayUrl &&
          currentPushers.first.data.format ==
              AppConfig.pushNotificationsPusherFormat) {
        Logs().i('[Push] Pusher already set');
      } else {
        Logs().i('Need to set new pusher');
        oldTokens.add(token);
        if (client.isLogged()) {
          setNewPusher = true;
        }
      }
    } else {
      Logs().w('[Push] Missing required push credentials');
    }
    for (final pusher in pushers) {
      if ((token != null &&
              pusher.pushkey != token &&
              deviceAppId == pusher.appId) ||
          oldTokens.contains(pusher.pushkey)) {
        try {
          await client.deletePusher(pusher);
          Logs().i('[Push] Removed legacy pusher for this device');
        } catch (err) {
          Logs().w('[Push] Failed to remove old pusher', err);
        }
      }
    }
    if (setNewPusher) {
      try {
        await client.postPusher(
          Pusher(
            pushkey: token!,
            appId: thisAppId,
            appDisplayName: clientName,
            deviceDisplayName: client.deviceName!,
            lang: 'en',
            data: PusherData(
              url: Uri.parse(gatewayUrl!),
              format: AppConfig.pushNotificationsPusherFormat,
            ),
            kind: 'http',
          ),
          append: false,
        );
      } catch (e, s) {
        Logs().e('[Push] Unable to set pushers', e, s);
      }
    }
  }

  bool _wentToRoomOnStartup = false;

  Future<void> setupPush() async {
    Logs().d("SetupPush");
    if (client.loginState != LoginState.loggedIn ||
        !PlatformInfos.isMobile ||
        context == null) {
      return;
    }
    // Do not setup unifiedpush if this has been initialized by
    // an unifiedpush action
    if (upAction) {
      return;
    }
    if (!PlatformInfos.isIOS &&
        (await UnifiedPush.getDistributors()).isNotEmpty) {
      await setupUp();
    }

    // ignore: unawaited_futures
    _flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails()
        .then((details) {
      if (details == null ||
          !details.didNotificationLaunchApp ||
          _wentToRoomOnStartup ||
          router == null) {
        return;
      }
      _wentToRoomOnStartup = true;
      goToRoom(details.payload);
    });
  }

  Future<void> goToRoom(String? roomId) async {
    try {
      Logs().v('[Push] Attempting to go to room $roomId...');
      if (router == null || roomId == null) {
        return;
      }
      await client.roomsLoading;
      await client.accountDataLoading;
      final isStory = client
              .getRoomById(roomId)
              ?.getState(EventTypes.RoomCreate)
              ?.content
              .tryGet<String>('type') ==
          ClientStoriesExtension.storiesRoomType;
      router!.currentState!.toSegments([isStory ? 'stories' : 'rooms', roomId]);
    } catch (e, s) {
      Logs().e('[Push] Failed to open room', e, s);
    }
  }

  Future<void> setupUp() async {
    await UnifiedPush.registerAppWithDialog(context!);
  }

  Future<void> _newUpEndpoint(String newEndpoint, String i) async {
    print('New UP endpoint');
    upAction = true;
    if (newEndpoint.isEmpty) {
      await _upUnregistered(i);
      return;
    }
    var endpoint =
        'https://matrix.gateway.unifiedpush.org/_matrix/push/v1/notify';
    try {
      const matrixGatewayPath = '/_matrix/push/v1/notify';
      if (Uri.parse(newEndpoint).path == matrixGatewayPath) {
        endpoint = newEndpoint.split('?').first;
      } else {
        final url = Uri.parse(newEndpoint)
            .replace(
              path: matrixGatewayPath,
              query: '',
            )
            .toString()
            .split('?')
            .first;
        final res = json
            .decode(utf8.decode((await http.get(Uri.parse(url))).bodyBytes));
        if (res['gateway'] == 'matrix' ||
            (res['unifiedpush'] is Map &&
                res['unifiedpush']['gateway'] == 'matrix')) {
          endpoint = url;
        }
      }
    } catch (e) {
      Logs().i(
          '[Push] No self-hosted unified push gateway present: ' + newEndpoint);
    }
    Logs().i('[Push] UnifiedPush using endpoint ' + endpoint);
    await setupPusher(
      gatewayUrl: endpoint,
      token: Uri.tryParse(newEndpoint)?.queryParameters['token'],
      useDeviceSpecificAppId: false,
    );
    await store.setItem(SettingKeys.unifiedPushEndpoint, newEndpoint);
    await store.setItemBool(SettingKeys.unifiedPushRegistered, true);
  }

  Future<void> _upUnregistered(String i) async {
    upAction = true;
    Logs().i('[Push] Removing UnifiedPush endpoint...');
    final oldEndpoint = await store.getItem(SettingKeys.unifiedPushEndpoint);
    await store.setItemBool(SettingKeys.unifiedPushRegistered, false);
    await store.deleteItem(SettingKeys.unifiedPushEndpoint);
    if (oldEndpoint?.isNotEmpty ?? false) {
      // remove the old pusher
      await setupPusher(
        oldTokens: {oldEndpoint},
      );
    }
  }

  Future<void> _onUpMessage(Uint8List message, String i) async {
    upAction = true;
    final data = Map<String, dynamic>.from(
        json.decode(utf8.decode(message))['notification']);
    await pushHelper(
      PushNotification.fromJson(data),
      client: client,
      l10n: l10n,
      activeRoomId: router?.currentState?.pathParameters['roomid'],
    );
  }

  /// Workaround for the problem that local notification IDs must be int but we
  /// sort by [roomId] which is a String. To make sure that we don't have duplicated
  /// IDs we map the [roomId] to a number and store this number.
  late Map<String, int> idMap;
  Future<void> _loadIdMap() async {
    idMap = Map<String, int>.from(json.decode(
        (await store.getItem(SettingKeys.notificationCurrentIds)) ?? '{}'));
  }

  Future<int> mapRoomIdToInt(String roomId) async {
    await _loadIdMap();
    int? currentInt;
    try {
      currentInt = idMap[roomId];
    } catch (_) {
      currentInt = null;
    }
    if (currentInt != null) {
      return currentInt;
    }
    var nCurrentInt = 0;
    while (idMap.values.contains(currentInt)) {
      nCurrentInt++;
    }
    idMap[roomId] = nCurrentInt;
    await store.setItem(SettingKeys.notificationCurrentIds, json.encode(idMap));
    return nCurrentInt;
  }

  bool _clearingPushLock = false;
  Future<void> _onClearingPush({bool getFromServer = true}) async {
    if (_clearingPushLock) {
      return;
    }
    try {
      _clearingPushLock = true;
      late Iterable<String> emptyRooms;
      if (getFromServer) {
        Logs().v('[Push] Got new clearing push');
        var syncErrored = false;
        if (client.syncPending) {
          Logs().v('[Push] waiting for existing sync');
          // we need to catchError here as the Future might be in a different execution zone
          await client.oneShotSync().catchError((e) {
            syncErrored = true;
            Logs().v('[Push] Error one-shot syncing', e);
          });
        }
        if (!syncErrored) {
          Logs().v('[Push] single oneShotSync');
          // we need to catchError here as the Future might be in a different execution zone
          await client.oneShotSync().catchError((e) {
            syncErrored = true;
            Logs().v('[Push] Error one-shot syncing', e);
          });
          if (!syncErrored) {
            emptyRooms = client.rooms
                .where((r) => r.notificationCount == 0)
                .map((r) => r.id);
          }
        }
        if (syncErrored) {
          try {
            Logs().v(
                '[Push] failed to sync for fallback push, fetching notifications endpoint...');
            final notifications = await client.getNotifications(limit: 20);
            final notificationRooms =
                notifications.notifications.map((n) => n.roomId).toSet();
            emptyRooms = client.rooms
                .where((r) => !notificationRooms.contains(r.id))
                .map((r) => r.id);
          } catch (e) {
            Logs().v(
                '[Push] failed to fetch pending notifications for clearing push, falling back...',
                e);
            emptyRooms = client.rooms
                .where((r) => r.notificationCount == 0)
                .map((r) => r.id);
          }
        }
      } else {
        emptyRooms = client.rooms
            .where((r) => r.notificationCount == 0)
            .map((r) => r.id);
      }
      await _loadIdMap();
      var changed = false;
      for (final roomId in emptyRooms) {
        final id = idMap[roomId];
        if (id != null) {
          idMap.remove(roomId);
          changed = true;
          await _flutterLocalNotificationsPlugin.cancel(id);
        }
      }
      if (changed) {
        await store.setItem(
            SettingKeys.notificationCurrentIds, json.encode(idMap));
      }
    } finally {
      _clearingPushLock = false;
    }
  }
}
