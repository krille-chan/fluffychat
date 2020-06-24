import 'dart:async';
import 'dart:io';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:famedlysdk/encryption.dart';
import 'package:fluffychat/components/dialogs/simple_dialogs.dart';
import 'package:fluffychat/utils/firebase_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/l10n.dart';
import '../utils/beautify_string_extension.dart';
import '../utils/famedlysdk_store.dart';
import 'avatar.dart';

class Matrix extends StatefulWidget {
  static const String callNamespace = 'chat.fluffy.jitsi_call';
  static const String defaultHomeserver = 'tchncs.de';

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
    client.database = await getDatabase(client);
    client.connect();
    if (await initLoginState == LoginState.logged && !kIsWeb) {
      await FirebaseController.setupFirebase(
        client,
        widget.clientName,
      );
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
  StreamSubscription onJitsiCallSub;

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

  @override
  void initState() {
    store = widget.store ?? Store();
    if (widget.client == null) {
      debugPrint('[Matrix] Init matrix client');
      client = Client(widget.clientName, debug: false);
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
    super.initState();
  }

  @override
  void dispose() {
    onRoomKeyRequestSub?.cancel();
    onJitsiCallSub?.cancel();
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
    var update =
        old.data.client.api.accessToken != data.client.api.accessToken ||
            old.data.client.userID != data.client.userID ||
            old.data.client.deviceID != data.client.deviceID ||
            old.data.client.deviceName != data.client.deviceName ||
            old.data.client.api.homeserver != data.client.api.homeserver;
    return update;
  }
}
