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

import 'package:collection/collection.dart';
import 'package:fcm_shared_isolate/fcm_shared_isolate.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_new_badger/flutter_new_badger.dart';
import 'package:http/http.dart' as http;
import 'package:matrix/matrix.dart';
import 'package:unifiedpush/unifiedpush.dart';
import 'package:unifiedpush_ui/unifiedpush_ui.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';
import 'package:fluffychat/pangea/learning_settings/constants/language_constants.dart';
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
  Client client;
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

  // final dynamic firebase = null; //FcmSharedIsolate();
  // #Pangea
  // uncommented to enable notifications on IOS
  final FcmSharedIsolate? firebase = FcmSharedIsolate();
  // Pangea#

  DateTime? lastReceivedPush;

  bool upAction = false;

  void _init() async {
    try {
      // #Pangea
      FirebaseMessaging.instance.getInitialMessage().then(_onOpenNotification);
      FirebaseMessaging.onMessageOpenedApp.listen(_onOpenNotification);
      // Pangea#
      await _flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings('notifications_icon'),
          iOS: DarwinInitializationSettings(),
        ),
        onDidReceiveNotificationResponse: goToRoom,
      );

      // #Pangea
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        pushHelper(
          PushNotification.fromJson(message.data),
          client: client,
          l10n: l10n,
          activeRoomId: matrix?.activeRoomId,
          flutterLocalNotificationsPlugin: _flutterLocalNotificationsPlugin,
        );
      });
      // Pangea#

      Logs().v('Flutter Local Notifications initialized');
      firebase?.setListeners(
        onMessage: (message) => pushHelper(
          PushNotification.fromJson(
            Map<String, dynamic>.from(message['data'] ?? message),
          ),
          client: client,
          l10n: l10n,
          activeRoomId: matrix?.activeRoomId,
          flutterLocalNotificationsPlugin: _flutterLocalNotificationsPlugin,
        ),
        // #Pangea
        onNewToken: _newFcmToken,
        // Pangea#
      );

      if (Platform.isAndroid) {
        await UnifiedPush.initialize(
          onNewEndpoint: _newUpEndpoint,
          onRegistrationFailed: _upUnregistered,
          onUnregistered: _upUnregistered,
          onMessage: _onUpMessage,
        );
      }
    } catch (e, s) {
      Logs().e('Unable to initialize Flutter local notifications', e, s);
    }
  }

  BackgroundPush._(this.client) {
    _init();
  }

  // #Pangea
  Future<void> _onOpenNotification(RemoteMessage? message) async {
    const sessionIdKey = "content_pangea.activity.session_room_id";

    // Early return if no room_id.
    final roomId = message?.data['room_id'];
    if (roomId is! String || roomId.isEmpty) return;

    // Helper to ensure a room is loaded or synced.
    Future<Room?> ensureRoomLoaded(String id) async {
      await client.roomsLoading;
      await client.accountDataLoading;

      var room = client.getRoomById(id);
      if (room == null) {
        await client.waitForRoomInSync(id).timeout(const Duration(seconds: 30));
        room = client.getRoomById(id);
      }
      return room;
    }

    // Handle session room if provided.
    final sessionRoomId = message?.data[sessionIdKey];
    if (sessionRoomId is String && sessionRoomId.isNotEmpty) {
      try {
        final course = await ensureRoomLoaded(roomId);
        if (course == null) return;

        final session = client.getRoomById(sessionRoomId);
        if (session?.membership == Membership.join) {
          FluffyChatApp.router.go('/rooms/$sessionRoomId');
          return;
        }

        await client.joinRoom(
          sessionRoomId,
          via: course.spaceChildren
              .firstWhereOrNull((child) => child.roomId == sessionRoomId)
              ?.via,
        );

        await ensureRoomLoaded(sessionRoomId);
        FluffyChatApp.router.go('/rooms/$sessionRoomId');
        return;
      } catch (err, s) {
        ErrorHandler.logError(e: err, s: s, data: {"roomId": sessionRoomId});
      }
    }

    // Fallback: just open the original room.
    try {
      final room = await ensureRoomLoaded(roomId);
      FluffyChatApp.router.go(
        room?.membership == Membership.invite ? '/rooms' : '/rooms/$roomId',
      );
    } catch (err, s) {
      ErrorHandler.logError(e: err, s: s, data: {"roomId": roomId});
    }
  }
  // Pangea#

  factory BackgroundPush.clientOnly(Client client) {
    return _instance ??= BackgroundPush._(client);
  }

  factory BackgroundPush(
    MatrixState matrix, {
    final void Function(String errorMsg, {Uri? link})? onFcmError,
  }) {
    final instance = BackgroundPush.clientOnly(matrix.client);
    instance.matrix = matrix;
    // ignore: prefer_initializing_formals
    instance.onFcmError = onFcmError;
    // #Pangea
    instance.fullInit();
    // Pangea#
    return instance;
  }

  // #Pangea
  Future<void> fullInit() => setupPush();

  void handleLoginStateChanged(_) => setupPush();

  StreamSubscription<LoginState>? onLogin;

  void _newFcmToken(String token) {
    _fcmToken = token;
    debugPrint('Fcm foken $_fcmToken');
    setupPush();
  }
  // Pangea#

  Future<void> cancelNotification(String roomId) async {
    Logs().v('Cancel notification for room', roomId);
    await _flutterLocalNotificationsPlugin.cancel(roomId.hashCode);

    // Workaround for app icon badge not updating
    if (Platform.isIOS) {
      final unreadCount = client.rooms
          .where((room) => room.isUnreadOrInvited && room.id != roomId)
          .length;
      // #Pangea
      try {
        // Pangea#
        if (unreadCount == 0) {
          FlutterNewBadger.removeBadge();
        } else {
          FlutterNewBadger.setBadge(unreadCount);
        }
        // #Pangea
      } catch (e, s) {
        ErrorHandler.logError(data: {}, e: e, s: s);
      }
      // Pangea#
      return;
    }
  }

  Future<void> setupPusher({
    String? gatewayUrl,
    String? token,
    Set<String?>? oldTokens,
    bool useDeviceSpecificAppId = false,
  }) async {
    // #Pangea
    try {
      // Pangea#
      if (PlatformInfos.isIOS) {
        await firebase?.requestPermission();
      }
      if (PlatformInfos.isAndroid) {
        _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
      }
      // #Pangea
    } catch (err, s) {
      ErrorHandler.logError(
        e: "Error requesting notifications permission: $err",
        s: s,
        data: {},
      );
    }
    // Pangea#
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
          // #Pangea
          currentPushers.first.lang == LanguageKeys.defaultLanguage &&
          // Pangea#
          currentPushers.first.data.url.toString() == gatewayUrl &&
          currentPushers.first.data.format ==
              // #Pangea
              // AppSettings.pushNotificationsPusherFormat
              //     .getItem(matrix!.store) &&
              null &&
          // Pangea#
          mapEquals(
            currentPushers.single.data.additionalProperties,
            {"data_message": pusherDataMessageFormat},
          )) {
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
            //#Pangea
            // lang: 'en',
            lang: LanguageKeys.defaultLanguage,
            // Pangea#
            data: PusherData(
              url: Uri.parse(gatewayUrl!),
              // #Pangea
              // format: AppSettings.pushNotificationsPusherFormat
              //     .getItem(matrix!.store),
              // Pangea#
              additionalProperties: {"data_message": pusherDataMessageFormat},
            ),
            kind: 'http',
          ),
          append: false,
        );
      } catch (e, s) {
        Logs().e('[Push] Unable to set pushers', e, s);
        // #Pangea
        ErrorHandler.logError(
          e: e,
          s: s,
          data: {},
        );
        // Pangea#
      }
    }
  }

  final pusherDataMessageFormat = Platform.isAndroid
      ? 'android'
      : Platform.isIOS
          ? 'ios'
          : null;

  static bool _wentToRoomOnStartup = false;

  Future<void> setupPush() async {
    Logs().d("SetupPush");
    if (client.onLoginStateChanged.value != LoginState.loggedIn ||
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
      await setupUp();
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
        // #Pangea
        // _fcmToken = await firebase?.getToken();
        _fcmToken = await _getToken();
        // Pangea#
        if (_fcmToken == null) throw ('PushToken is null');
      } catch (e, s) {
        Logs().w('[Push] cannot get token', e, e is String ? null : s);
        await _noFcmWarning();
        return;
      }
    }
    await setupPusher(
      gatewayUrl:
          AppSettings.pushNotificationsGatewayUrl.getItem(matrix!.store),
      token: _fcmToken,
    );
  }

  Future<void> goToRoom(NotificationResponse? response) async {
    try {
      final roomId = response?.payload;
      Logs().v('[Push] Attempting to go to room $roomId...');
      if (roomId == null) {
        return;
      }
      await client.roomsLoading;
      await client.accountDataLoading;
      if (client.getRoomById(roomId) == null) {
        await client
            .waitForRoomInSync(roomId)
            .timeout(const Duration(seconds: 30));
      }
      FluffyChatApp.router.go(
        client.getRoomById(roomId)?.membership == Membership.invite
            ? '/rooms'
            : '/rooms/$roomId',
      );
    } catch (e, s) {
      Logs().e('[Push] Failed to open room', e, s);
      // #Pangea
      ErrorHandler.logError(
        e: e,
        s: s,
        data: {
          "roomID": response?.payload,
        },
      );
      // Pangea#
    }
  }

  Future<void> setupUp() async {
    await UnifiedPushUi(matrix!.context, ["default"], UPFunctions())
        .registerAppWithDialog();
  }

  Future<void> _newUpEndpoint(String newEndpoint, String i) async {
    upAction = true;
    if (newEndpoint.isEmpty) {
      await _upUnregistered(i);
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
    Logs().i('[Push] UnifiedPush using endpoint $endpoint');
    final oldTokens = <String?>{};
    try {
      // #Pangea
      // final fcmToken = await firebase?.getToken();
      final fcmToken = await _getToken();
      // Pangea#
      oldTokens.add(fcmToken);
    } catch (_) {}
    await setupPusher(
      gatewayUrl: endpoint,
      token: newEndpoint,
      oldTokens: oldTokens,
      useDeviceSpecificAppId: true,
    );
    await matrix?.store.setString(SettingKeys.unifiedPushEndpoint, newEndpoint);
    await matrix?.store.setBool(SettingKeys.unifiedPushRegistered, true);
  }

  Future<void> _upUnregistered(String i) async {
    upAction = true;
    Logs().i('[Push] Removing UnifiedPush endpoint...');
    final oldEndpoint =
        matrix?.store.getString(SettingKeys.unifiedPushEndpoint);
    await matrix?.store.setBool(SettingKeys.unifiedPushRegistered, false);
    await matrix?.store.remove(SettingKeys.unifiedPushEndpoint);
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
      json.decode(utf8.decode(message))['notification'],
    );
    // UP may strip the devices list
    data['devices'] ??= [];
    await pushHelper(
      PushNotification.fromJson(data),
      client: client,
      l10n: l10n,
      activeRoomId: matrix?.activeRoomId,
      flutterLocalNotificationsPlugin: _flutterLocalNotificationsPlugin,
    );
  }

  // #Pangea
  Future<String?> _getToken() async {
    if (Platform.isAndroid) {
      return (await FirebaseMessaging.instance.getToken());
    }
    return await firebase?.getToken();
  }
  // Pangea#
}

class UPFunctions extends UnifiedPushFunctions {
  final List<String> features = [
    /*list of features*/
  ];

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
