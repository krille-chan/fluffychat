import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:famedlysdk/encryption.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/utils/firebase_controller.dart';
import 'package:fluffychat/utils/matrix_locals.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/sentry_controller.dart';
import 'package:fluffychat/views/settings_3pid.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:logger_flutter/logger_flutter.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
/*import 'package:fluffychat/views/chat.dart';
import 'package:fluffychat/app_config.dart';
import 'package:dbus/dbus.dart';
import 'package:desktop_notifications/desktop_notifications.dart';*/

import '../utils/beautify_string_extension.dart';
import '../utils/famedlysdk_store.dart';
import 'dialogs/key_verification_dialog.dart';
import '../utils/platform_infos.dart';
import '../app_config.dart';
import '../config/setting_keys.dart';
import 'avatar.dart';

class Matrix extends StatefulWidget {
  static const String callNamespace = 'chat.fluffy.jitsi_call';

  final Widget child;

  Matrix({this.child, Key key}) : super(key: key);

  @override
  MatrixState createState() => MatrixState();

  /// Returns the (nearest) Client instance of your application.
  static MatrixState of(BuildContext context) {
    var newState =
        (context.dependOnInheritedWidgetOfExactType<_InheritedMatrix>()).data;
    newState.context = FirebaseController.context = context;
    return newState;
  }
}

class MatrixState extends State<Matrix> {
  Client client;
  Store store = Store();
  @override
  BuildContext context;

  static const String userStatusesType = 'chat.fluffy.user_statuses';

  Map<String, dynamic> get shareContent => _shareContent;
  set shareContent(Map<String, dynamic> content) {
    _shareContent = content;
    onShareContentChanged.add(_shareContent);
  }

  Map<String, dynamic> _shareContent;

  final StreamController<Map<String, dynamic>> onShareContentChanged =
      StreamController.broadcast();

  String activeRoomId;
  File wallpaper;
  String clientName;

  void clean() async {
    if (!kIsWeb) return;

    await store.deleteItem(clientName);
  }

  void _initWithStore() async {
    var initLoginState = client.onLoginStateChanged.stream.first;
    try {
      client.init();

      final firstLoginState = await initLoginState;
      if (firstLoginState == LoginState.logged) {
        if (PlatformInfos.isMobile) {
          await FirebaseController.setupFirebase(
            this,
            clientName,
          );
        }
      }
      final storeItem = await store.getItem(SettingKeys.showNoPid);
      final configOptionMissing = storeItem == null || storeItem.isEmpty;
      if (configOptionMissing || (!configOptionMissing && storeItem == '1')) {
        if (configOptionMissing) {
          await store.setItem(SettingKeys.showNoPid, '0');
        }
        await Matrix.of(context)
            .client
            .requestThirdPartyIdentifiers()
            .then((l) {
          if (l.isEmpty) {
            Flushbar(
              title: L10n.of(context).warning,
              message: L10n.of(context).noPasswordRecoveryDescription,
              mainButton: RaisedButton(
                elevation: 7,
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(L10n.of(context).edit),
                onPressed: () => Navigator.of(context).push(
                  AppRoute.defaultRoute(
                    context,
                    Settings3PidView(),
                  ),
                ),
              ),
              flushbarStyle: FlushbarStyle.FLOATING,
            ).show(context);
          }
        }).catchError((_) => null);
      }
    } catch (e, s) {
      client.onLoginStateChanged.sink.addError(e, s);
      SentryController.captureException(e, s);
      rethrow;
    }
  }

  StreamSubscription onRoomKeyRequestSub;
  StreamSubscription onKeyVerificationRequestSub;
  StreamSubscription onJitsiCallSub;
  StreamSubscription onNotification;
  StreamSubscription<UiaRequest> onUiaRequest;
  StreamSubscription<html.Event> onFocusSub;
  StreamSubscription<html.Event> onBlurSub;

  void _onUiaRequest(UiaRequest uiaRequest) async {
    uiaRequest.onUpdate = (_) => _onUiaRequest(uiaRequest);
    if (uiaRequest.state != UiaRequestState.waitForUser ||
        uiaRequest.nextStages.isEmpty) return;
    final stage = uiaRequest.nextStages.first;
    switch (stage) {
      case AuthenticationTypes.password:
        final input = await showTextInputDialog(context: context, textFields: [
          DialogTextField(
            minLines: 1,
            maxLines: 1,
            obscureText: true,
          )
        ]);
        if (input?.isEmpty ?? true) return;
        return uiaRequest.completeStage(
          AuthenticationPassword(
            session: uiaRequest.session,
            user: client.userID,
            password: input.single,
            identifier: AuthenticationUserIdentifier(user: client.userID),
          ),
        );
      default:
        Logs().w('Warning! Cannot handle the stage "$stage"');
        return;
    }
  }

  void onJitsiCall(EventUpdate eventUpdate) {
    final event = Event.fromJson(
        eventUpdate.content, client.getRoomById(eventUpdate.roomID));
    if (DateTime.now().millisecondsSinceEpoch -
            event.originServerTs.millisecondsSinceEpoch >
        1000 * 60 * 5) {
      return;
    }
    final senderName = event.sender.calcDisplayname();
    final senderAvatar = event.sender.avatarUrl;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(L10n.of(context).videoCall),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: Avatar(senderAvatar, senderName),
              title: Text(
                senderName,
                style: TextStyle(fontSize: 18),
              ),
              subtitle:
                  event.room.isDirectChat ? null : Text(event.room.displayname),
            ),
            Divider(),
            Row(
              children: <Widget>[
                Spacer(),
                FloatingActionButton(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.phone_missed_outlined),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Spacer(),
                FloatingActionButton(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.phone_outlined),
                  onPressed: () {
                    Navigator.of(context).pop();
                    launch(event.body);
                  },
                ),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
    return;
  }

  bool webHasFocus = true;

  void _showLocalNotification(EventUpdate eventUpdate) async {
    final roomId = eventUpdate.roomID;
    if (webHasFocus && activeRoomId == roomId) return;
    final room = client.getRoomById(roomId);
    if (room.notificationCount == 0) return;
    final event = Event.fromJson(eventUpdate.content, room);
    final body = event.getLocalizedBody(
      MatrixLocals(L10n.of(context)),
      withSenderNamePrefix:
          !room.isDirectChat || room.lastEvent.senderId == client.userID,
    );
    final icon = event.sender.avatarUrl?.getThumbnail(client,
            width: 64, height: 64, method: ThumbnailMethod.crop) ??
        room.avatar?.getThumbnail(client,
            width: 64, height: 64, method: ThumbnailMethod.crop);
    if (kIsWeb) {
      html.AudioElement()
        ..src = 'assets/assets/sounds/notification.wav'
        ..autoplay = true
        ..load();
      html.Notification(
        room.getLocalizedDisplayname(MatrixLocals(L10n.of(context))),
        body: body,
        icon: icon,
      );
    } else if (Platform.isLinux) {
      /*var sessionBus = DBusClient.session();
      var client = NotificationClient(sessionBus);
      _linuxNotificationIds[roomId] = await client.notify(
        room.getLocalizedDisplayname(MatrixLocals(L10n.of(context))),
        body: body,
        replacesID: _linuxNotificationIds[roomId] ?? -1,
        appName: AppConfig.applicationName,
        actionCallback: (_) => Navigator.of(context).pushAndRemoveUntil(
            AppRoute.defaultRoute(
              context,
              ChatView(roomId),
            ),
            (r) => r.isFirst),
      );
      await sessionBus.close();*/
    }
  }

  //final Map<String, int> _linuxNotificationIds = {};

  @override
  void initState() {
    super.initState();
    initMatrix();
    initConfig().then((_) => initSettings());
  }

  Future<void> initConfig() async {
    if (PlatformInfos.isMobile) {
      return;
    }
    try {
      var configJsonString = '';
      if (PlatformInfos.isWeb) {
        configJsonString =
            utf8.decode((await http.get('config.json')).bodyBytes);
      } else if (PlatformInfos.isBetaDesktop) {
        final appDocDir = await getApplicationSupportDirectory();
        configJsonString =
            await File('${appDocDir.path}/config.json').readAsString();
      } else {
        final appDocDir = await getApplicationDocumentsDirectory();
        configJsonString =
            await File('${appDocDir.path}/config.json').readAsString();
      }
      final configJson = json.decode(configJsonString);
      AppConfig.loadFromJson(configJson);
    } catch (e, s) {
      Logs().w('[ConfigLoader] Failed to load config.json', e, s);
    }
  }

  void initMatrix() {
    LogConsole.init();
    clientName =
        '${AppConfig.applicationName} ${kIsWeb ? 'Web' : Platform.operatingSystem}';
    final Set verificationMethods = <KeyVerificationMethod>{
      KeyVerificationMethod.numbers
    };
    if (PlatformInfos.isMobile) {
      // emojis don't show in web somehow
      verificationMethods.add(KeyVerificationMethod.emoji);
    }
    client = Client(
      clientName,
      enableE2eeRecovery: true,
      verificationMethods: verificationMethods,
      importantStateEvents: <String>{
        'im.ponies.room_emotes', // we want emotes to work properly
      },
      databaseBuilder: getDatabase,
    );
    onJitsiCallSub ??= client.onEvent.stream
        .where((e) =>
            e.type == EventUpdateType.timeline &&
            e.eventType == 'm.room.message' &&
            e.content['content']['msgtype'] == Matrix.callNamespace &&
            e.content['sender'] != client.userID)
        .listen(onJitsiCall);

    onRoomKeyRequestSub ??=
        client.onRoomKeyRequest.stream.listen((RoomKeyRequest request) async {
      final room = request.room;
      if (request.sender != room.client.userID) {
        return; // ignore share requests by others
      }
      final sender = room.getUserByMXIDSync(request.sender);
      if (await showOkCancelAlertDialog(
            context: context,
            title: L10n.of(context).requestToReadOlderMessages,
            message:
                '${sender.id}\n\n${L10n.of(context).device}:\n${request.requestingDevice.deviceId}\n\n${L10n.of(context).identity}:\n${request.requestingDevice.curve25519Key.beautified}',
            okLabel: L10n.of(context).verify,
            cancelLabel: L10n.of(context).deny,
          ) ==
          OkCancelResult.ok) {
        await request.forwardKey();
      }
    });
    onKeyVerificationRequestSub ??= client.onKeyVerificationRequest.stream
        .listen((KeyVerification request) async {
      var hidPopup = false;
      request.onUpdate = () {
        if (!hidPopup &&
            {KeyVerificationState.done, KeyVerificationState.error}
                .contains(request.state)) {
          Navigator.of(context, rootNavigator: true).pop('dialog');
        }
        hidPopup = true;
      };
      if (await showOkCancelAlertDialog(
            context: context,
            title: L10n.of(context).newVerificationRequest,
            message: L10n.of(context).askVerificationRequest(request.userId),
          ) ==
          OkCancelResult.ok) {
        request.onUpdate = null;
        hidPopup = true;
        await request.acceptVerification();
        await KeyVerificationDialog(request: request).show(context);
      } else {
        request.onUpdate = null;
        hidPopup = true;
        await request.rejectVerification();
      }
    });
    _initWithStore();

    if (kIsWeb) {
      onFocusSub = html.window.onFocus.listen((_) => webHasFocus = true);
      onBlurSub = html.window.onBlur.listen((_) => webHasFocus = false);
    }
    onUiaRequest ??= client.onUiaRequest.stream.listen(_onUiaRequest);
    if (kIsWeb || Platform.isLinux) {
      client.onSync.stream.first.then((s) {
        html.Notification.requestPermission();
        onNotification ??= client.onEvent.stream
            .where((e) =>
                e.type == EventUpdateType.timeline &&
                [EventTypes.Message, EventTypes.Sticker, EventTypes.Encrypted]
                    .contains(e.eventType) &&
                e.content['sender'] != client.userID)
            .listen(_showLocalNotification);
      });
    }
  }

  void initSettings() {
    if (store != null) {
      store.getItem(SettingKeys.jitsiInstance).then((final instance) =>
          AppConfig.jitsiInstance = instance ?? AppConfig.jitsiInstance);
      store.getItem(SettingKeys.wallpaper).then((final path) async {
        if (path == null) return;
        final file = File(path);
        if (await file.exists()) {
          wallpaper = file;
        }
      });
      store
          .getItemBool(SettingKeys.renderHtml, AppConfig.renderHtml)
          .then((value) => AppConfig.renderHtml = value);
      store
          .getItemBool(
              SettingKeys.hideRedactedEvents, AppConfig.hideRedactedEvents)
          .then((value) => AppConfig.hideRedactedEvents = value);
      store
          .getItemBool(
              SettingKeys.hideUnknownEvents, AppConfig.hideUnknownEvents)
          .then((value) => AppConfig.hideUnknownEvents = value);
    }
  }

  @override
  void dispose() {
    onRoomKeyRequestSub?.cancel();
    onKeyVerificationRequestSub?.cancel();
    onJitsiCallSub?.cancel();
    onNotification?.cancel();
    onFocusSub?.cancel();
    onBlurSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedMatrix(
      data: this,
      child: widget.child,
    );
  }
}

class _InheritedMatrix extends InheritedWidget {
  final MatrixState data;

  _InheritedMatrix({Key key, this.data, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedMatrix old) {
    var update = old.data.client.accessToken != data.client.accessToken ||
        old.data.client.userID != data.client.userID ||
        old.data.client.deviceID != data.client.deviceID ||
        old.data.client.deviceName != data.client.deviceName ||
        old.data.client.homeserver != data.client.homeserver;
    return update;
  }
}
