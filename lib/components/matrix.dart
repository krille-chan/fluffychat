import 'dart:async';
import 'dart:io';

import 'package:famedlysdk/encryption.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/dialogs/simple_dialogs.dart';
import 'package:fluffychat/utils/firebase_controller.dart';
import 'package:fluffychat/utils/matrix_locals.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/user_status.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:localstorage/localstorage.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import '../utils/app_route.dart';
import '../utils/beautify_string_extension.dart';
import '../utils/famedlysdk_store.dart';
import '../utils/presence_extension.dart';
import '../views/key_verification.dart';
import 'avatar.dart';

class Matrix extends StatefulWidget {
  static const String callNamespace = 'chat.fluffy.jitsi_call';

  final Widget child;

  final String clientName;

  final Client client;

  final Store store;

  Matrix({this.child, this.clientName, this.client, this.store, Key key})
      : super(key: key);

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
  Store store;
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
  bool renderHtml = false;

  String jitsiInstance = 'https://meet.jit.si/';

  void clean() async {
    if (!kIsWeb) return;

    final storage = LocalStorage('LocalStorage');
    await storage.ready;
    await storage.deleteItem(widget.clientName);
  }

  void _initWithStore() async {
    var initLoginState = client.onLoginStateChanged.stream.first;
    try {
      client.database = await getDatabase(client);
      await client.connect();
      if (await initLoginState == LoginState.logged && PlatformInfos.isMobile) {
        await FirebaseController.setupFirebase(
          this,
          widget.clientName,
        );
      }
      _cleanUpUserStatus(userStatuses);
    } catch (e, s) {
      client.onLoginStateChanged.sink.addError(e, s);
      captureException(e, s);
      rethrow;
    }
  }

  Map<String, dynamic> getAuthByPassword(String password, [String session]) => {
        'type': 'm.login.password',
        'identifier': {
          'type': 'm.id.user',
          'user': client.userID,
        },
        'user': client.userID,
        'password': password,
        if (session != null) 'session': session,
      };

  StreamSubscription onRoomKeyRequestSub;
  StreamSubscription onKeyVerificationRequestSub;
  StreamSubscription onJitsiCallSub;
  StreamSubscription onNotification;
  StreamSubscription<html.Event> onFocusSub;
  StreamSubscription<html.Event> onBlurSub;
  StreamSubscription onPresenceSub;

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
                  child: Icon(Icons.phone_missed),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Spacer(),
                FloatingActionButton(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.phone),
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

  void _showWebNotification(EventUpdate eventUpdate) async {
    if (webHasFocus && activeRoomId == eventUpdate.roomID) return;
    final room = client.getRoomById(eventUpdate.roomID);
    if (room.notificationCount == 0) return;
    final event = Event.fromJson(eventUpdate.content, room);
    final body = event.getLocalizedBody(
      MatrixLocals(L10n.of(context)),
      withSenderNamePrefix:
          !room.isDirectChat || room.lastEvent.senderId == client.userID,
    );
    html.AudioElement()
      ..src = 'assets/assets/sounds/notification.wav'
      ..autoplay = true
      ..load();
    html.Notification(
      room.getLocalizedDisplayname(MatrixLocals(L10n.of(context))),
      body: body,
      icon: event.sender.avatarUrl?.getThumbnail(client,
              width: 64, height: 64, method: ThumbnailMethod.crop) ??
          room.avatar?.getThumbnail(client,
              width: 64, height: 64, method: ThumbnailMethod.crop),
    );
  }

  @override
  void initState() {
    store = widget.store ?? Store();
    if (widget.client == null) {
      debugPrint('[Matrix] Init matrix client');
      final Set verificationMethods = <KeyVerificationMethod>{
        KeyVerificationMethod.numbers
      };
      if (!kIsWeb) {
        // emojis don't show in web somehow
        verificationMethods.add(KeyVerificationMethod.emoji);
      }
      client = Client(widget.clientName,
          enableE2eeRecovery: true,
          verificationMethods: verificationMethods,
          importantStateEvents: <String>{
            'im.ponies.room_emotes', // we want emotes to work properly
          });
      onPresenceSub ??= client.onPresence.stream
          .where((p) => p.isUserStatus)
          .listen(_storeUserStatus);
      onJitsiCallSub ??= client.onEvent.stream
          .where((e) =>
              e.type == 'timeline' &&
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
        if (await SimpleDialogs(context).askConfirmation(
          titleText: L10n.of(context).requestToReadOlderMessages,
          contentText:
              '${sender.id}\n\n${L10n.of(context).device}:\n${request.requestingDevice.deviceId}\n\n${L10n.of(context).identity}:\n${request.requestingDevice.curve25519Key.beautified}',
          confirmText: L10n.of(context).verify,
          cancelText: L10n.of(context).deny,
        )) {
          await request.forwardKey();
        }
      });
      onKeyVerificationRequestSub ??= client.onKeyVerificationRequest.stream
          .listen((KeyVerification request) async {
        if (await SimpleDialogs(context).askConfirmation(
          titleText: L10n.of(context).newVerificationRequest,
          contentText: L10n.of(context).askVerificationRequest(request.userId),
        )) {
          await request.acceptVerification();
          await Navigator.of(context).push(
            AppRoute.defaultRoute(
              context,
              KeyVerificationView(request: request),
            ),
          );
        } else {
          await request.rejectVerification();
        }
      });
      _initWithStore();
    } else {
      client = widget.client;
      client.connect();
    }
    if (store != null) {
      store
          .getItem('chat.fluffy.jitsi_instance')
          .then((final instance) => jitsiInstance = instance ?? jitsiInstance);
      store.getItem('chat.fluffy.wallpaper').then((final path) async {
        if (path == null) return;
        final file = File(path);
        if (await file.exists()) {
          wallpaper = file;
        }
      });
      store.getItem('chat.fluffy.renderHtml').then((final render) async {
        renderHtml = render == '1';
      });
    }
    if (kIsWeb) {
      onFocusSub = html.window.onFocus.listen((_) => webHasFocus = true);
      onBlurSub = html.window.onBlur.listen((_) => webHasFocus = false);

      client.onSync.stream.first.then((s) {
        html.Notification.requestPermission();
        onNotification ??= client.onEvent.stream
            .where((e) =>
                e.type == 'timeline' &&
                [EventTypes.Message, EventTypes.Sticker, EventTypes.Encrypted]
                    .contains(e.eventType) &&
                e.content['sender'] != client.userID)
            .listen(_showWebNotification);
      });
    }
    super.initState();
  }

  List<UserStatus> get userStatuses {
    try {
      return (client.accountData[userStatusesType].content['user_statuses']
              as List)
          .map((json) => UserStatus.fromJson(json))
          .toList();
    } catch (_) {}
    return [];
  }

  void _storeUserStatus(Presence presence) {
    final tmpUserStatuses = List<UserStatus>.from(userStatuses);
    final currentStatusIndex =
        userStatuses.indexWhere((u) => u.userId == presence.senderId);
    final newUserStatus = UserStatus()
      ..receivedAt = DateTime.now().millisecondsSinceEpoch
      ..statusMsg = presence.presence.statusMsg
      ..userId = presence.senderId;
    if (currentStatusIndex == -1) {
      tmpUserStatuses.add(newUserStatus);
    } else if (tmpUserStatuses[currentStatusIndex].statusMsg !=
        presence.presence.statusMsg) {
      if (presence.presence.statusMsg.trim().isEmpty) {
        tmpUserStatuses.removeAt(currentStatusIndex);
      } else {
        tmpUserStatuses[currentStatusIndex] = newUserStatus;
      }
    } else {
      return;
    }
    _cleanUpUserStatus(tmpUserStatuses);
  }

  void _cleanUpUserStatus(List<UserStatus> tmpUserStatuses) {
    final now = DateTime.now().millisecondsSinceEpoch;
    tmpUserStatuses
        .removeWhere((u) => (now - u.receivedAt) > (1000 * 60 * 60 * 24));
    tmpUserStatuses.sort((a, b) => b.receivedAt.compareTo(a.receivedAt));
    if (tmpUserStatuses.length > 40) {
      tmpUserStatuses.removeRange(40, tmpUserStatuses.length);
    }
    if (tmpUserStatuses != userStatuses) {
      client.setAccountData(
        client.userID,
        userStatusesType,
        {
          'user_statuses': tmpUserStatuses.map((i) => i.toJson()).toList(),
        },
      );
    }
  }

  @override
  void dispose() {
    onRoomKeyRequestSub?.cancel();
    onKeyVerificationRequestSub?.cancel();
    onJitsiCallSub?.cancel();
    onPresenceSub?.cancel();
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
