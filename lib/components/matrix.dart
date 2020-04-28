import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluffychat/components/dialogs/simple_dialogs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../i18n/i18n.dart';
import '../utils/app_route.dart';
import '../utils/beautify_string_extension.dart';
import '../utils/event_extension.dart';
import '../utils/famedlysdk_store.dart';
import '../utils/room_extension.dart';
import '../views/chat.dart';
import 'avatar.dart';

class Matrix extends StatefulWidget {
  static const String callNamespace = 'chat.fluffy.jitsi_call';
  static const String defaultHomeserver = 'tchncs.de';

  final Widget child;

  final String clientName;

  final Client client;

  Matrix({this.child, this.clientName, this.client, Key key}) : super(key: key);

  @override
  MatrixState createState() => MatrixState();

  /// Returns the (nearest) Client instance of your application.
  static MatrixState of(BuildContext context) {
    MatrixState newState =
        (context.dependOnInheritedWidgetOfExactType<_InheritedMatrix>()).data;
    newState.context = context;
    return newState;
  }
}

class MatrixState extends State<Matrix> {
  Client client;
  BuildContext context;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
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

  String jitsiInstance = 'https://meet.jit.si/';

  void clean() async {
    if (!kIsWeb) return;

    final LocalStorage storage = LocalStorage('LocalStorage');
    await storage.ready;
    await storage.deleteItem(widget.clientName);
  }

  Future<String> downloadAndSaveContent(Uri content,
      {int width, int height, ThumbnailMethod method}) async {
    final bool thumbnail = width == null && height == null ? false : true;
    final String tempDirectory = (await getTemporaryDirectory()).path;
    final String prefix = thumbnail ? "thumbnail" : "";
    File file =
        File('$tempDirectory/${prefix}_${content.toString().split("/").last}');

    if (!file.existsSync()) {
      final url = thumbnail
          ? content.getThumbnail(client,
              width: width, height: height, method: method)
          : content.getDownloadLink(client);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      await file.writeAsBytes(bytes);
    }

    return file.path;
  }

  Future<void> setupFirebase() async {
    if (Platform.isIOS) iOS_Permission();

    String token;
    try {
      token = await _firebaseMessaging.getToken();
    } catch (_) {
      token = null;
    }
    if (token?.isEmpty ?? true) {
      showToast(
        I18n.of(context).noGoogleServicesWarning,
        duration: Duration(seconds: 15),
      );
      return;
    }
    await client.setPushers(
      token,
      "http",
      "chat.fluffy.fluffychat",
      widget.clientName,
      client.deviceName,
      "en",
      "https://janian.de:7023/",
      append: false,
      format: "event_id_only",
    );

    Function goToRoom = (dynamic message) async {
      try {
        String roomId;
        if (message is String) {
          roomId = message;
        } else if (message is Map) {
          roomId = (message["data"] ?? message)["room_id"];
        }
        if (roomId?.isEmpty ?? true) throw ("Bad roomId");
        await Navigator.of(context).pushAndRemoveUntil(
            AppRoute.defaultRoute(
              context,
              ChatView(roomId),
            ),
            (r) => r.isFirst);
      } catch (_) {
        showToast("Failed to open chat...");
        debugPrint(_);
      }
    };

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('notifications_icon');
    var initializationSettingsIOS =
        IOSInitializationSettings(onDidReceiveLocalNotification: (i, a, b, c) {
      return null;
    });
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: goToRoom);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        try {
          final data = message['data'] ?? message;
          final String roomId = data["room_id"];
          final String eventId = data["event_id"];
          final int unread = json.decode(data["counts"])["unread"];
          if ((roomId?.isEmpty ?? true) ||
              (eventId?.isEmpty ?? true) ||
              unread == 0) {
            await _flutterLocalNotificationsPlugin.cancelAll();
            return null;
          }
          if (activeRoomId == roomId) return null;

          // Get the room
          Room room = client.getRoomById(roomId);
          if (room == null) {
            await client.onRoomUpdate.stream
                .where((u) => u.id == roomId)
                .first
                .timeout(Duration(seconds: 10));
            room = client.getRoomById(roomId);
            if (room == null) return null;
          }

          // Get the event
          Event event = await client.store.getEventById(eventId, room);
          if (event == null) {
            final EventUpdate eventUpdate = await client.onEvent.stream
                .where((u) => u.content["event_id"] == eventId)
                .first
                .timeout(Duration(seconds: 10));
            event = Event.fromJson(eventUpdate.content, room);
            if (room == null) return null;
          }

          // Count all unread events
          int unreadEvents = 0;
          client.rooms
              .forEach((Room room) => unreadEvents += room.notificationCount);

          // Calculate title
          final String title = unread > 1
              ? I18n.of(context).unreadMessagesInChats(
                  unreadEvents.toString(), unread.toString())
              : I18n.of(context).unreadMessages(unreadEvents.toString());

          // Calculate the body
          final String body = event.getLocalizedBody(context,
              withSenderNamePrefix: true, hideReply: true);

          // The person object for the android message style notification
          final person = Person(
            name: room.getLocalizedDisplayname(context),
            icon: room.avatar == null
                ? null
                : await downloadAndSaveContent(
                    room.avatar,
                    width: 126,
                    height: 126,
                  ),
            iconSource: IconSource.FilePath,
          );

          // Show notification
          var androidPlatformChannelSpecifics = AndroidNotificationDetails(
              'fluffychat_push',
              'FluffyChat push channel',
              'Push notifications for FluffyChat',
              style: AndroidNotificationStyle.Messaging,
              styleInformation: MessagingStyleInformation(
                person,
                conversationTitle: title,
                messages: [
                  Message(
                    body,
                    event.time,
                    person,
                  )
                ],
              ),
              importance: Importance.Max,
              priority: Priority.High,
              ticker: I18n.of(context).newMessageInFluffyChat);
          var iOSPlatformChannelSpecifics = IOSNotificationDetails();
          var platformChannelSpecifics = NotificationDetails(
              androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
          await _flutterLocalNotificationsPlugin.show(
              0,
              room.getLocalizedDisplayname(context),
              body,
              platformChannelSpecifics,
              payload: roomId);
        } catch (exception) {
          debugPrint("[Push] Error while processing notification: " +
              exception.toString());
        }
        return null;
      },
      onResume: goToRoom,
      // Currently fires unexpectetly... https://github.com/FirebaseExtended/flutterfire/issues/1060
      //onLaunch: goToRoom,
    );
    debugPrint("[Push] Firebase initialized");
    return;
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      debugPrint("Settings registered: $settings");
    });
  }

  void _initWithStore() async {
    Future<LoginState> initLoginState = client.onLoginStateChanged.stream.first;
    client.storeAPI = kIsWeb ? Store(client) : ExtendedStore(client);
    debugPrint(
        "[Store] Store is extended: ${client.storeAPI.extended.toString()}");
    if (await initLoginState == LoginState.logged && !kIsWeb) {
      await setupFirebase();
    }
  }

  Map<String, dynamic> getAuthByPassword(String password, String session) => {
        "type": "m.login.password",
        "identifier": {
          "type": "m.id.user",
          "user": client.userID,
        },
        "user": client.userID,
        "password": password,
        "session": session,
      };

  StreamSubscription onRoomKeyRequestSub;
  StreamSubscription onJitsiCallSub;

  void onJitsiCall(EventUpdate eventUpdate) {
    final event = Event.fromJson(
        eventUpdate.content, client.getRoomById(eventUpdate.roomID));
    if (DateTime.now().millisecondsSinceEpoch -
            event.time.millisecondsSinceEpoch >
        1000 * 60 * 5) {
      return;
    }
    final senderName = event.sender.calcDisplayname();
    final senderAvatar = event.sender.avatarUrl;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(I18n.of(context).videoCall),
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
    if (widget.client == null) {
      debugPrint("[Matrix] Init matrix client");
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
        final Room room = request.room;
        final User sender = room.getUserByMXIDSync(request.sender);
        if (await SimpleDialogs(context).askConfirmation(
          titleText: I18n.of(context).requestToReadOlderMessages,
          contentText:
              "${sender.id}\n\n${I18n.of(context).device}:\n${request.requestingDevice.deviceId}\n\n${I18n.of(context).identity}:\n${request.requestingDevice.curve25519Key.beautified}",
          confirmText: I18n.of(context).verify,
          cancelText: I18n.of(context).deny,
        )) {
          await request.forwardKey();
        }
      });
      _initWithStore();
    } else {
      client = widget.client;
    }
    if (client.storeAPI != null) {
      client.storeAPI
          .getItem("chat.fluffy.jitsi_instance")
          .then((final instance) => jitsiInstance = instance ?? jitsiInstance);
      client.storeAPI.getItem("chat.fluffy.wallpaper").then((final path) async {
        if (path == null) return;
        final file = File(path);
        if (await file.exists()) {
          wallpaper = file;
        }
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
    bool update = old.data.client.accessToken != this.data.client.accessToken ||
        old.data.client.userID != this.data.client.userID ||
        old.data.client.matrixVersions != this.data.client.matrixVersions ||
        old.data.client.deviceID != this.data.client.deviceID ||
        old.data.client.deviceName != this.data.client.deviceName ||
        old.data.client.homeserver != this.data.client.homeserver;
    return update;
  }
}
