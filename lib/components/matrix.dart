import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/utils/sqflite_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
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
            Text("Loading... Please wait"),
          ],
        ),
      ),
    );
  }

  hideLoadingDialog() => Navigator.of(_loadingDialogContext)?.pop();

  StreamSubscription onSetupFirebase;

  void setupFirebase(LoginState login) async {
    if (login != LoginState.logged) return;
    if (Platform.isIOS) iOS_Permission();

    final String token = await _firebaseMessaging.getToken();
    if (token?.isEmpty ?? true) {
      return Toast.show(
        "Push notifications disabled.",
        context,
        duration: Toast.LENGTH_LONG,
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

    _firebaseMessaging.configure(
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  void initState() {
    if (widget.client == null) {
      client = Client(widget.clientName, debug: false);
      if (!kIsWeb) {
        client.store = Store(client);
      } else {
        loadAccount();
      }
    } else {
      client = widget.client;
    }
    onSetupFirebase ??= client.onLoginStateChanged.stream.listen(setupFirebase);
    super.initState();
  }

  @override
  void dispose() {
    onSetupFirebase?.cancel();
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
