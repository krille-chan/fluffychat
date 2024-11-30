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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:matrix/matrix.dart';
import 'package:unifiedpush/unifiedpush.dart';
import 'package:unifiedpush_ui/unifiedpush_ui.dart';

import 'package:fluffychat/utils/push_helper.dart';
import 'package:fluffychat/widgets/fluffy_chat_app.dart';
import '../config/app_config.dart';
import '../config/setting_keys.dart';
import '../widgets/matrix.dart';
import 'platform_infos.dart';

//import 'package:fcm_shared_isolate/fcm_shared_isolate.dart';

class NoTokenException implements Exception {
  String get cause => 'Cannot get firebase token';
}

class BackgroundPush {
  static BackgroundPush? _instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  List<Client> clients;
  MatrixState? matrix;
  String? _fcmToken;
  void Function(String errorMsg, {Uri? link})? onFcmError;
  L10n? l10n;

  Future<void> loadLocale() async {
    final context = matrix?.context;
    // inspired by _lookupL10n in .dart_tool/flutter_gen/gen_l10n/l10n.dart
    l10n ??= (context != null ? L10n.of(context) : null) ??
        (await L10n.delegate.load(PlatformDispatcher.instance.locale));
  }

  final pendingTests = <String, Completer<void>>{};

  final dynamic firebase = null; //FcmSharedIsolate();

  DateTime? lastReceivedPush;

  bool upAction = false;

  void _init() async {
    try {
      await _flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings('notifications_icon'),
          iOS: DarwinInitializationSettings(),
        ),
        onDidReceiveNotificationResponse: goToRoom,
      );
      Logs().v('Flutter Local Notifications initialized');
      firebase?.setListeners(
        onMessage: (message) => PushHelper.pushHelper(
          PushNotification.fromJson(
            Map<String, dynamic>.from(message['data'] ?? message),
          ),
          clients: clients,
          //TODO: figure out if firebase supports
          //      multiple instances
          instance: clients.first.clientName,
          l10n: l10n,
          activeRoomId: matrix?.activeRoomId,
          activeClient: matrix?.client,
          flutterLocalNotificationsPlugin: _flutterLocalNotificationsPlugin,
        ),
      );
      if (Platform.isAndroid) {
        await UnifiedPush.initialize(
          onNewEndpoint: _newUPEndpoint,
          onRegistrationFailed: _onUPUnregistered,
          onUnregistered: _onUPUnregistered,
          onMessage: _onUPMessage,
        );
      }
    } catch (e, s) {
      Logs().e('Unable to initialize Flutter local notifications', e, s);
    }
  }

  BackgroundPush._(this.clients) {
    _init();
  }

  factory BackgroundPush.clientsOnly(List<Client> clients) {
    return _instance ??= BackgroundPush._(clients);
  }

  factory BackgroundPush(
    MatrixState matrix, {
    final void Function(String errorMsg, {Uri? link})? onFcmError,
  }) {
    final instance = BackgroundPush.clientsOnly(matrix.widget.clients);
    instance.matrix = matrix;
    // ignore: prefer_initializing_formals
    instance.onFcmError = onFcmError;
    return instance;
  }

  Future<void> cancelNotification(Client client, String roomId) async {
    Logs().v('Cancel notification for room', roomId);
    await _flutterLocalNotificationsPlugin.cancel(roomId.hashCode);

    // Workaround for app icon badge not updating
    if (Platform.isIOS) {
      final unreadCount = client.rooms
          .where((room) => room.isUnreadOrInvited && room.id != roomId)
          .length;
      if (unreadCount == 0) {
        FlutterAppBadger.removeBadge();
      } else {
        FlutterAppBadger.updateBadgeCount(unreadCount);
      }
      return;
    }
  }

  Future<void> setupPusher({
    String? gatewayUrl,
    String? token,
    Set<String?>? oldTokens,
    bool useDeviceSpecificAppId = false,
    required Client client,
  }) async {
    if (PlatformInfos.isIOS) {
      await firebase?.requestPermission();
    } else if (PlatformInfos.isAndroid) {
      _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
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
              AppConfig.pushNotificationsPusherFormat &&
          mapEquals(
            currentPushers.single.data.additionalProperties,
            {"data_message": pusherDataMessageFormat},
          )) {
        Logs().i('[Push] Pusher already set');
      } else {
        Logs().i('[Push] Need to set new pusher');
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
              additionalProperties: {"data_message": pusherDataMessageFormat},
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

  final pusherDataMessageFormat = Platform.isAndroid
      ? 'android'
      : Platform.isIOS
          ? 'ios'
          : null;

  static bool _wentToRoomOnStartup = false;

  Future<void> setupPush(List<Client> clients) async {
    Logs().d("SetupPush");

    {
      // migrate single client push settings to multiclient settings
      final endpoint = matrix!.store.getString(SettingKeys.unifiedPushEndpoint);
      if (endpoint != null) {
        matrix!.store.setString(
          clients.first.clientName + SettingKeys.unifiedPushEndpoint,
          endpoint,
        );
        matrix!.store.remove(SettingKeys.unifiedPushEndpoint);
      }

      final registered =
          matrix!.store.getBool(SettingKeys.unifiedPushRegistered);
      if (registered != null) {
        matrix!.store.setBool(
          clients.first.clientName + SettingKeys.unifiedPushRegistered,
          registered,
        );
        matrix!.store.remove(SettingKeys.unifiedPushRegistered);
      }
    }

    if (clients.first.onLoginStateChanged.value != LoginState.loggedIn ||
        !PlatformInfos.isMobile ||
        matrix == null) {
      return;
    }
    // Do not setup unifiedpush if this has been initialized by
    // an unifiedpush action
    if (upAction) {
      return;
    }
    if (!PlatformInfos.isIOS &&
        (await UnifiedPush.getDistributors()).isNotEmpty) {
      await setupUP(clients);
    } else {
      await setupFirebase();
    }

    // ignore: unawaited_futures
    _flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails()
        .then((details) {
      if (details == null ||
          !details.didNotificationLaunchApp ||
          _wentToRoomOnStartup) {
        return;
      }
      _wentToRoomOnStartup = true;
      goToRoom(details.notificationResponse);
    });
  }

  Future<void> _noFcmWarning() async {
    if (matrix == null) {
      return;
    }
    if ((matrix?.store.getBool(SettingKeys.showNoGoogle) ?? false) == true) {
      return;
    }
    await loadLocale();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (PlatformInfos.isAndroid) {
        onFcmError?.call(
          l10n!.noGoogleServicesWarning,
          link: Uri.parse(
            AppConfig.enablePushTutorial,
          ),
        );
        return;
      }
      onFcmError?.call(l10n!.oopsPushError);
    });
  }

  Future<void> setupFirebase() async {
    Logs().v('Setup firebase');
    if (_fcmToken?.isEmpty ?? true) {
      try {
        _fcmToken = await firebase?.getToken();
        if (_fcmToken == null) throw ('PushToken is null');
      } catch (e, s) {
        Logs().w('[Push] cannot get token', e, e is String ? null : s);
        await _noFcmWarning();
        return;
      }
    }
    await setupPusher(
      gatewayUrl: AppConfig.pushNotificationsGatewayUrl,
      token: _fcmToken,
      client: clients.first, // Workaround: see todo in _init
    );
  }

  Future<void> goToRoom(NotificationResponse? response) async {
    try {
      final payloadEncoded = response?.payload;
      if (payloadEncoded == null || payloadEncoded.isEmpty) {
        return;
      }
      final payload =
          NotificationResponsePayload.fromJson(jsonDecode(payloadEncoded));
      if (payload.roomId.isEmpty) {
        return;
      }
      Logs().v('[Push] Attempting to go to room ${payload.roomId}...');

      Client? client;
      for (final c in clients) {
        if (c.clientName == payload.clientName) {
          client = c;
          break;
        }
      }
      if (client == null) {
        Logs()
            .w('[Push] No client could be found for room ${payload.roomId}...');
        return;
      }
      if (matrix!.client != client) {
        matrix!.setActiveClient(client);
      }

      await client.roomsLoading;
      await client.accountDataLoading;
      if (client.getRoomById(payload.roomId) == null) {
        await client
            .waitForRoomInSync(payload.roomId)
            .timeout(const Duration(seconds: 30));
      }
      FluffyChatApp.router.go(
        client.getRoomById(payload.roomId)?.membership == Membership.invite
            ? '/rooms'
            : '/rooms/${payload.roomId}',
      );
    } catch (e, s) {
      Logs().e('[Push] Failed to open room', e, s);
    }
  }

  Future<void> setupUP(List<Client> clients) async {
    final names = clients.map((c) => c.clientName);
    await UnifiedPushUi(matrix!.context, List.from(names), UPFunctions())
        .registerAppWithDialog();
  }

  Future<void> _newUPEndpoint(String newEndpoint, String instance) async {
    upAction = true;
    if (newEndpoint.isEmpty) {
      await _onUPUnregistered(instance);
      return;
    }
    var endpoint =
        'https://matrix.gateway.unifiedpush.org/_matrix/push/v1/notify';
    try {
      final url = Uri.parse(newEndpoint)
          .replace(
            path: '/_matrix/push/v1/notify',
            query: '',
          )
          .toString()
          .split('?')
          .first;
      final res =
          json.decode(utf8.decode((await http.get(Uri.parse(url))).bodyBytes));
      if (res['gateway'] == 'matrix' ||
          (res['unifiedpush'] is Map &&
              res['unifiedpush']['gateway'] == 'matrix')) {
        endpoint = url;
      }
    } catch (e) {
      Logs().i(
        '[Push] No self-hosted unified push gateway present: $newEndpoint',
      );
    }
    Logs().i('[Push] UnifiedPush $instance using endpoint $endpoint');
    final oldTokens = <String?>{};
    try {
      final fcmToken = await firebase?.getToken();
      oldTokens.add(fcmToken);
    } catch (_) {}
    final client = clientFromInstance(instance, clients);
    if (client == null) {
      Logs().e("Not client found for $instance");
      return;
    }
    await setupPusher(
      gatewayUrl: endpoint,
      token: newEndpoint,
      oldTokens: oldTokens,
      useDeviceSpecificAppId: true,
      client: client,
    );
    await matrix?.store.setString(
      client.clientName + SettingKeys.unifiedPushEndpoint,
      newEndpoint,
    );
    await matrix?.store
        .setBool(client.clientName + SettingKeys.unifiedPushRegistered, true);
  }

  Future<void> _onUPUnregistered(String instance) async {
    upAction = true;
    final client = clientFromInstance(instance, clients);
    if (client == null) {
      return;
    }
    Logs().i('[Push] Removing UnifiedPush endpoint...');
    final oldEndpoint = matrix?.store
        .getString(client.clientName + SettingKeys.unifiedPushEndpoint);
    await matrix?.store
        .setBool(client.clientName + SettingKeys.unifiedPushRegistered, false);
    await matrix?.store
        .remove(client.clientName + SettingKeys.unifiedPushEndpoint);
    if (oldEndpoint?.isNotEmpty ?? false) {
      // remove the old pusher
      await setupPusher(
        oldTokens: {oldEndpoint},
        client: client,
      );
    }
  }

  Future<void> _onUPMessage(Uint8List message, String instance) async {
    upAction = true;
    final data = Map<String, dynamic>.from(
      json.decode(utf8.decode(message))['notification'],
    );
    // UP may strip the devices list
    data['devices'] ??= [];
    await PushHelper.pushHelper(
      PushNotification.fromJson(data),
      clients: clients,
      instance: instance,
      l10n: l10n,
      activeClient: matrix?.client,
      activeRoomId: matrix?.activeRoomId,
      flutterLocalNotificationsPlugin: _flutterLocalNotificationsPlugin,
    );
  }
}

class UPFunctions extends UnifiedPushFunctions {
  final List<String> features = [/*list of features*/];
  @override
  Future<String?> getDistributor() async {
    return await UnifiedPush.getDistributor();
  }

  @override
  Future<List<String>> getDistributors() async {
    return await UnifiedPush.getDistributors(features);
  }

  @override
  Future<void> registerApp(String instance) async {
    await UnifiedPush.registerApp(instance, features);
  }

  @override
  Future<void> saveDistributor(String distributor) async {
    await UnifiedPush.saveDistributor(distributor);
  }
}

Client? clientFromInstance(String? instance, List<Client> clients) {
  for (final c in clients) {
    if (c.clientName == instance) {
      return c;
    }
  }
  return null;
}
