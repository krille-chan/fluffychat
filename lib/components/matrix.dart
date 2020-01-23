import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/i18n/i18n.dart';
import 'package:fluffychat/utils/app_route.dart';
import 'package:fluffychat/utils/event_extension.dart';
import 'package:fluffychat/utils/room_extension.dart';
import 'package:fluffychat/utils/sqflite_store.dart';
import 'package:fluffychat/views/chat.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';

class Matrix extends StatefulWidget {
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
  Map<String, dynamic> shareContent;

  String activeRoomId;

  /// Used to load the old account if there is no store available.
  void loadAccount() async {
    final LocalStorage storage = LocalStorage('LocalStorage');
    await storage.ready;

    final credentialsStr = storage.getItem(widget.clientName);
    if (credentialsStr == null || credentialsStr.isEmpty) {
      client.onLoginStateChanged.add(LoginState.loggedOut);
      return;
    }
    print("[Matrix] Restoring account credentials");
    final Map<String, dynamic> credentials = json.decode(credentialsStr);
    client.connect(
      newDeviceID: credentials["deviceID"],
      newDeviceName: credentials["deviceName"],
      newHomeserver: credentials["homeserver"],
      newLazyLoadMembers: credentials["lazyLoadMembers"],
      //newMatrixVersions: credentials["matrixVersions"], // FIXME: wrong List type
      newToken: credentials["token"],
      newUserID: credentials["userID"],
    );
  }

  /// Used to save the current account persistently if there is no store available.
  Future<void> saveAccount() async {
    if (!kIsWeb) return;
    print("[Matrix] Save account credentials in crypted preferences");
    final Map<String, dynamic> credentials = {
      "deviceID": client.deviceID,
      "deviceName": client.deviceName,
      "homeserver": client.homeserver,
      "lazyLoadMembers": client.lazyLoadMembers,
      "matrixVersions": client.matrixVersions,
      "token": client.accessToken,
      "userID": client.userID,
    };

    final LocalStorage storage = LocalStorage('LocalStorage');
    await storage.ready;
    await storage.setItem(widget.clientName, json.encode(credentials));
    return;
  }

  void clean() async {
    if (!kIsWeb) return;
    print("Clear session...");

    final LocalStorage storage = LocalStorage('LocalStorage');
    await storage.ready;
    await storage.deleteItem(widget.clientName);
  }

  BuildContext _loadingDialogContext;

  Future<dynamic> tryRequestWithLoadingDialog(Future<dynamic> request) async {
    showLoadingDialog(context);
    final dynamic = await tryRequestWithErrorToast(request);
    hideLoadingDialog();
    return dynamic;
  }

  Future<dynamic> tryRequestWithErrorToast(Future<dynamic> request) async {
    try {
      return await request;
    } catch (exception) {
      Toast.show(
        exception.toString(),
        context,
        duration: Toast.LENGTH_LONG,
      );
      return false;
    }
  }

  showLoadingDialog(BuildContext context) {
    _loadingDialogContext = context;
    showDialog(
      context: _loadingDialogContext,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        content: Row(
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text(I18n.of(context).loadingPleaseWait),
          ],
        ),
      ),
    );
  }

  hideLoadingDialog() => Navigator.of(_loadingDialogContext)?.pop();

  Future<String> downloadAndSaveContent(MxContent content,
      {int width, int height, ThumbnailMethod method}) async {
    final bool thumbnail = width == null && height == null ? false : true;
    final String tempDirectory = (await getTemporaryDirectory()).path;
    final String prefix = thumbnail ? "thumbnail" : "";
    File file = File('$tempDirectory/${prefix}_${content.mxc.split("/").last}');

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

    final String token = await _firebaseMessaging.getToken();
    if (token?.isEmpty ?? true) {
      return Toast.show(
        I18n.of(context).noGoogleServicesWarning,
        context,
        duration: 10,
      );
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
          roomId = message["data"]["room_id"];
        }
        if (roomId?.isEmpty ?? true) throw ("Bad roomId");
        await Navigator.of(context).pushAndRemoveUntil(
            AppRoute.defaultRoute(
              context,
              Chat(roomId),
            ),
            (r) => r.isFirst);
      } catch (_) {
        Toast.show("Failed to open chat...", context);
        print(_);
      }
    };

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('notifications_icon');
    var initializationSettingsIOS =
        IOSInitializationSettings(onDidReceiveLocalNotification: (i, a, b, c) {
      print("onDidReceiveLocalNotification: $i $a $b $c");
      return null;
    });
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: goToRoom);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        try {
          final String roomId = message["data"]["room_id"];
          final String eventId = message["data"]["event_id"];
          final int unread = json.decode(message["data"]["counts"])["unread"];
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
              withSenderNamePrefix: true, hideQuotes: true);

          // The person object for the android message style notification
          final person = Person(
            name: room.getLocalizedDisplayname(context),
            icon: room.avatar.mxc.isEmpty
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
          print("[Push] Error while processing notification: " +
              exception.toString());
        }
        return null;
      },
      onResume: goToRoom,
      // Currently fires unexpectetly... https://github.com/FirebaseExtended/flutterfire/issues/1060
      //onLaunch: goToRoom,
    );
    print("[Push] Firebase initialized");
    return;
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  void _initWithStore() async {
    Future<LoginState> initLoginState = client.onLoginStateChanged.stream.first;
    client.store = Store(client);
    if (await initLoginState == LoginState.logged) {
      await setupFirebase();
    }
  }

  @override
  void initState() {
    if (widget.client == null) {
      print("[Matrix] Init matrix client");
      client = Client(widget.clientName, debug: false);
      if (!kIsWeb) {
        _initWithStore();
      } else {
        print("[Web] Web platform detected - Store disabled!");
        loadAccount();
      }
    } else {
      client = widget.client;
    }
    super.initState();
  }

  @override
  void dispose() {
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
        old.data.client.lazyLoadMembers != this.data.client.lazyLoadMembers ||
        old.data.client.deviceID != this.data.client.deviceID ||
        old.data.client.deviceName != this.data.client.deviceName ||
        old.data.client.homeserver != this.data.client.homeserver;
    return update;
  }
}
