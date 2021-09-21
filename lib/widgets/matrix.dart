import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:fluffychat/utils/client_manager.dart';
import 'package:matrix/encryption.dart';
import 'package:matrix/matrix.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions.dart/matrix_locals.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/sentry_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:desktop_notifications/desktop_notifications.dart';
import '../utils/famedlysdk_store.dart';
import '../pages/key_verification_dialog.dart';
import '../utils/platform_infos.dart';
import '../config/app_config.dart';
import '../config/setting_keys.dart';
import '../utils/account_bundles.dart';
import '../utils/background_push.dart';
import 'package:vrouter/vrouter.dart';

class Matrix extends StatefulWidget {
  static const String callNamespace = 'chat.fluffy.jitsi_call';

  final Widget child;

  final GlobalKey<VRouterState> router;

  final BuildContext context;

  final List<Client> clients;

  final Map<String, String> queryParameters;

  Matrix({
    this.child,
    @required this.router,
    @required this.context,
    @required this.clients,
    this.queryParameters,
    Key key,
  }) : super(key: key);

  @override
  MatrixState createState() => MatrixState();

  /// Returns the (nearest) Client instance of your application.
  static MatrixState of(BuildContext context) =>
      Provider.of<MatrixState>(context, listen: false);
}

class MatrixState extends State<Matrix> with WidgetsBindingObserver {
  int activeClient = 0;
  String activeBundle;
  Store store = Store();
  BuildContext navigatorContext;

  BackgroundPush _backgroundPush;

  Client get client => widget.clients[_safeActiveClient];

  bool get isMultiAccount => widget.clients.length > 1;

  int getClientIndexByMatrixId(String matrixId) =>
      widget.clients.indexWhere((client) => client.userID == matrixId);

  int get _safeActiveClient {
    if (activeClient < 0 || activeClient >= widget.clients.length) {
      return 0;
    }
    return activeClient;
  }

  void setActiveClient(Client cl) {
    final i = widget.clients.indexWhere((c) => c == cl);
    if (i != null) {
      activeClient = i;
    } else {
      Logs().w('Tried to set an unknown client ${cl.userID} as active');
    }
  }

  List<Client> get currentBundle {
    if (!hasComplexBundles) {
      return List.from(widget.clients);
    }
    final bundles = accountBundles;
    if (bundles.containsKey(activeBundle)) {
      return bundles[activeBundle];
    }
    return bundles.values.first;
  }

  Map<String, List<Client>> get accountBundles {
    final resBundles = <String, List<_AccountBundleWithClient>>{};
    for (var i = 0; i < widget.clients.length; i++) {
      final bundles = widget.clients[i].accountBundles;
      for (final bundle in bundles) {
        if (bundle.name == null) {
          continue;
        }
        resBundles[bundle.name] ??= [];
        resBundles[bundle.name].add(_AccountBundleWithClient(
          client: widget.clients[i],
          bundle: bundle,
        ));
      }
    }
    for (final b in resBundles.values) {
      b.sort((a, b) => a.bundle.priority == null
          ? 1
          : b.bundle.priority == null
              ? -1
              : a.bundle.priority.compareTo(b.bundle.priority));
    }
    return resBundles
        .map((k, v) => MapEntry(k, v.map((vv) => vv.client).toList()));
  }

  bool get hasComplexBundles => accountBundles.values.any((v) => v.length > 1);

  Client _loginClientCandidate;

  Client getLoginClient() {
    final multiAccount = client.isLogged();
    if (!multiAccount) return client;
    _loginClientCandidate ??= ClientManager.createClient(
        // we use the first clients here, else we can easily end up with super long client names.
        widget.clients.first.generateUniqueTransactionId())
      ..onLoginStateChanged
          .stream
          .where((l) => l == LoginState.loggedIn)
          .first
          .then((_) {
        widget.clients.add(_loginClientCandidate);
        ClientManager.addClientNameToStore(_loginClientCandidate.clientName);
        _registerSubs(_loginClientCandidate.clientName);
        _loginClientCandidate = null;
        widget.router.currentState.to('/rooms');
      });
    return _loginClientCandidate;
  }

  Client getClientByName(String name) => widget.clients
      .firstWhere((c) => c.clientName == name, orElse: () => null);

  Map<String, dynamic> get shareContent => _shareContent;
  set shareContent(Map<String, dynamic> content) {
    _shareContent = content;
    onShareContentChanged.add(_shareContent);
  }

  Map<String, dynamic> _shareContent;

  final StreamController<Map<String, dynamic>> onShareContentChanged =
      StreamController.broadcast();

  File wallpaper;

  void _initWithStore() async {
    try {
      if (client.isLogged()) {
        // TODO: Figure out how this works in multi account
        final statusMsg = await store.getItem(SettingKeys.ownStatusMessage);
        if (statusMsg?.isNotEmpty ?? false) {
          Logs().v('Send cached status message: "$statusMsg"');
          await client.setPresence(
            client.userID,
            PresenceType.online,
            statusMsg: statusMsg,
          );
        }
      }
    } catch (e, s) {
      client.onLoginStateChanged.sink.addError(e, s);
      SentryController.captureException(e, s);
      rethrow;
    }
  }

  final onRoomKeyRequestSub = <String, StreamSubscription>{};
  final onKeyVerificationRequestSub = <String, StreamSubscription>{};
  final onJitsiCallSub = <String, StreamSubscription>{};
  final onNotification = <String, StreamSubscription>{};
  final onLoginStateChanged = <String, StreamSubscription<LoginState>>{};
  final onUiaRequest = <String, StreamSubscription<UiaRequest>>{};
  StreamSubscription<html.Event> onFocusSub;
  StreamSubscription<html.Event> onBlurSub;
  final onOwnPresence = <String, StreamSubscription<Presence>>{};

  String _cachedPassword;
  String get cachedPassword {
    final tmp = _cachedPassword;
    _cachedPassword = null;
    return tmp;
  }

  set cachedPassword(String p) => _cachedPassword = p;

  void _onUiaRequest(UiaRequest uiaRequest) async {
    try {
      if (uiaRequest.state != UiaRequestState.waitForUser ||
          uiaRequest.nextStages.isEmpty) return;
      final stage = uiaRequest.nextStages.first;
      switch (stage) {
        case AuthenticationTypes.password:
          final input = cachedPassword ??
              (await showTextInputDialog(
                useRootNavigator: false,
                context: navigatorContext,
                title: L10n.of(widget.context).pleaseEnterYourPassword,
                okLabel: L10n.of(widget.context).ok,
                cancelLabel: L10n.of(widget.context).cancel,
                textFields: [
                  DialogTextField(
                    minLines: 1,
                    maxLines: 1,
                    obscureText: true,
                    hintText: '******',
                  )
                ],
              ))
                  ?.single;
          if (input?.isEmpty ?? true) return;
          return uiaRequest.completeStage(
            AuthenticationPassword(
              session: uiaRequest.session,
              password: input,
              identifier: AuthenticationUserIdentifier(user: client.userID),
            ),
          );
        case AuthenticationTypes.emailIdentity:
          final emailInput = await showTextInputDialog(
            context: navigatorContext,
            message: L10n.of(context).serverRequiresEmail,
            okLabel: L10n.of(context).next,
            cancelLabel: L10n.of(context).cancel,
            textFields: [
              DialogTextField(
                hintText: L10n.of(context).addEmail,
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          );
          if (emailInput == null || emailInput.isEmpty) {
            return uiaRequest
                .cancel(Exception(L10n.of(context).serverRequiresEmail));
          }
          final clientSecret = DateTime.now().millisecondsSinceEpoch.toString();
          final currentThreepidCreds = await client.requestTokenToRegisterEmail(
            clientSecret,
            emailInput.single,
            0,
          );
          final auth = AuthenticationThreePidCreds(
            session: uiaRequest.session,
            type: AuthenticationTypes.emailIdentity,
            threepidCreds: [
              ThreepidCreds(
                sid: currentThreepidCreds.sid,
                clientSecret: clientSecret,
              ),
            ],
          );
          if (OkCancelResult.ok ==
              await showOkCancelAlertDialog(
                useRootNavigator: false,
                context: navigatorContext,
                title: L10n.of(context).weSentYouAnEmail,
                message: L10n.of(context).pleaseClickOnLink,
                okLabel: L10n.of(context).iHaveClickedOnLink,
                cancelLabel: L10n.of(widget.context).cancel,
              )) {
            return uiaRequest.completeStage(auth);
          }
          return uiaRequest.cancel();
        case AuthenticationTypes.dummy:
          return uiaRequest.completeStage(
            AuthenticationData(
              type: AuthenticationTypes.dummy,
              session: uiaRequest.session,
            ),
          );
        default:
          await launch(
            client.homeserver.toString() +
                '/_matrix/client/r0/auth/$stage/fallback/web?session=${uiaRequest.session}',
          );
          if (OkCancelResult.ok ==
              await showOkCancelAlertDialog(
                useRootNavigator: false,
                message: L10n.of(widget.context).pleaseFollowInstructionsOnWeb,
                context: navigatorContext,
                okLabel: L10n.of(widget.context).next,
                cancelLabel: L10n.of(widget.context).cancel,
              )) {
            return uiaRequest.completeStage(
              AuthenticationData(session: uiaRequest.session),
            );
          } else {
            return uiaRequest.cancel();
          }
      }
    } catch (e, s) {
      Logs().e('Error while background UIA', e, s);
      return uiaRequest.cancel(e);
    }
  }

  bool webHasFocus = true;

  String get activeRoomId =>
      VRouter.of(navigatorContext).pathParameters['roomid'];

  void _showLocalNotification(EventUpdate eventUpdate) async {
    final roomId = eventUpdate.roomID;
    if (webHasFocus && activeRoomId == roomId) return;
    final room = client.getRoomById(roomId);
    if (room.notificationCount == 0) return;
    final event = Event.fromJson(eventUpdate.content, room);
    final title =
        room.getLocalizedDisplayname(MatrixLocals(L10n.of(widget.context)));
    final body = event.getLocalizedBody(
      MatrixLocals(L10n.of(widget.context)),
      withSenderNamePrefix:
          !room.isDirectChat || room.lastEvent.senderId == client.userID,
      plaintextBody: true,
      hideReply: true,
      hideEdit: true,
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
        title,
        body: body,
        icon: icon.toString(),
      );
    } else if (Platform.isLinux) {
      await linuxNotifications.notify(
        title,
        body: body,
        replacesId: _linuxNotificationIds[roomId] ?? -1,
        appName: AppConfig.applicationName,
      );
    }
  }

  final linuxNotifications =
      PlatformInfos.isLinux ? NotificationsClient() : null;
  final Map<String, int> _linuxNotificationIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initMatrix();
    if (PlatformInfos.isWeb) {
      initConfig().then((_) => initSettings());
    } else {
      initSettings();
    }
  }

  Future<void> initConfig() async {
    try {
      final configJsonString =
          utf8.decode((await http.get(Uri.parse('config.json'))).bodyBytes);
      final configJson = json.decode(configJsonString);
      AppConfig.loadFromJson(configJson);
    } catch (e, _) {
      Logs().v('[ConfigLoader] config.json not found', e);
    }
  }

  void _registerSubs(String name) {
    final c = getClientByName(name);
    if (c == null) {
      Logs().w(
          'Attempted to register subscriptions for non-existing client $name');
      return;
    }
    onKeyVerificationRequestSub[name] ??= c.onKeyVerificationRequest.stream
        .listen((KeyVerification request) async {
      var hidPopup = false;
      request.onUpdate = () {
        if (!hidPopup &&
            {KeyVerificationState.done, KeyVerificationState.error}
                .contains(request.state)) {
          Navigator.of(navigatorContext).pop('dialog');
        }
        hidPopup = true;
      };
      if (await showOkCancelAlertDialog(
            useRootNavigator: false,
            context: navigatorContext,
            title: L10n.of(widget.context).newVerificationRequest,
            message:
                L10n.of(widget.context).askVerificationRequest(request.userId),
            okLabel: L10n.of(widget.context).ok,
            cancelLabel: L10n.of(widget.context).cancel,
          ) ==
          OkCancelResult.ok) {
        request.onUpdate = null;
        hidPopup = true;
        await request.acceptVerification();
        await KeyVerificationDialog(request: request).show(navigatorContext);
      } else {
        request.onUpdate = null;
        hidPopup = true;
        await request.rejectVerification();
      }
    });
    onLoginStateChanged[name] ??= c.onLoginStateChanged.stream.listen((state) {
      final loggedInWithMultipleClients = widget.clients.length > 1;
      if (state != LoginState.loggedIn) {
        _cancelSubs(c.clientName);
        widget.clients.remove(c);
      }
      if (loggedInWithMultipleClients && state != LoginState.loggedIn) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(L10n.of(context).oneClientLoggedOut),
          ),
        );

        if (state != LoginState.loggedIn) {
          widget.router.currentState.to(
            '/rooms',
            queryParameters: widget.router.currentState.queryParameters,
          );
        }
      } else {
        widget.router.currentState.to(
          state == LoginState.loggedIn ? '/rooms' : '/home',
          queryParameters: widget.router.currentState.queryParameters,
        );
      }
    });
    // Cache and resend status message
    onOwnPresence[name] ??= c.onPresence.stream.listen((presence) {
      if (c.isLogged() &&
          c.userID == presence.senderId &&
          presence.presence?.statusMsg != null) {
        Logs().v('Update status message: "${presence.presence.statusMsg}"');
        store.setItem(
            SettingKeys.ownStatusMessage, presence.presence.statusMsg);
      }
    });
    onUiaRequest[name] ??= c.onUiaRequest.stream.listen(_onUiaRequest);
    if (PlatformInfos.isWeb || PlatformInfos.isLinux) {
      c.onSync.stream.first.then((s) {
        html.Notification.requestPermission();
        onNotification[name] ??= c.onEvent.stream
            .where((e) =>
                e.type == EventUpdateType.timeline &&
                [EventTypes.Message, EventTypes.Sticker, EventTypes.Encrypted]
                    .contains(e.content['type']) &&
                e.content['sender'] != c.userID)
            .listen(_showLocalNotification);
      });
    }
  }

  void _cancelSubs(String name) {
    onRoomKeyRequestSub[name]?.cancel();
    onRoomKeyRequestSub.remove(name);
    onKeyVerificationRequestSub[name]?.cancel();
    onKeyVerificationRequestSub.remove(name);
    onLoginStateChanged[name]?.cancel();
    onLoginStateChanged.remove(name);
    onOwnPresence[name]?.cancel();
    onOwnPresence.remove(name);
    onNotification[name]?.cancel();
    onNotification.remove(name);
  }

  void initMatrix() {
    // Display the app lock
    if (PlatformInfos.isMobile) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FlutterSecureStorage().read(key: SettingKeys.appLockKey).then((lock) {
          if (lock?.isNotEmpty ?? false) {
            AppLock.of(widget.context).enable();
            AppLock.of(widget.context).showLockScreen();
          }
        });
      });
    }

    _initWithStore();

    for (final c in widget.clients) {
      _registerSubs(c.clientName);
    }

    if (kIsWeb) {
      onFocusSub = html.window.onFocus.listen((_) => webHasFocus = true);
      onBlurSub = html.window.onBlur.listen((_) => webHasFocus = false);
    }

    if (PlatformInfos.isMobile) {
      _backgroundPush = BackgroundPush(
        client,
        context,
        widget.router,
        onFcmError: (errorMsg) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMsg))),
      );
    }
  }

  bool _firstStartup = true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Logs().v('AppLifecycleState = $state');
    final foreground = state != AppLifecycleState.detached &&
        state != AppLifecycleState.paused;
    client.backgroundSync = foreground;
    client.syncPresence = foreground ? null : PresenceType.unavailable;
    client.requestHistoryOnLimitedTimeline = !foreground;
    if (_firstStartup) {
      _firstStartup = false;
      _backgroundPush?.setupPush();
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
      store.getItem(SettingKeys.fontSizeFactor).then((value) =>
          AppConfig.fontSizeFactor =
              double.tryParse(value ?? '') ?? AppConfig.fontSizeFactor);
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
      store
          .getItemBool(SettingKeys.autoplayImages, AppConfig.autoplayImages)
          .then((value) => AppConfig.autoplayImages = value);
      store
          .getItemBool(SettingKeys.sendOnEnter, AppConfig.sendOnEnter)
          .then((value) => AppConfig.sendOnEnter = value);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    onRoomKeyRequestSub.values.map((s) => s.cancel());
    onKeyVerificationRequestSub.values.map((s) => s.cancel());
    onLoginStateChanged.values.map((s) => s.cancel());
    onOwnPresence.values.map((s) => s.cancel());
    onNotification.values.map((s) => s.cancel());

    onFocusSub?.cancel();
    onBlurSub?.cancel();
    _backgroundPush?.onLogin?.cancel();

    linuxNotifications?.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => this,
      child: widget.child,
    );
  }
}

class FixedThreepidCreds extends ThreepidCreds {
  FixedThreepidCreds({
    String sid,
    String clientSecret,
    String idServer,
    String idAccessToken,
  }) : super(
          sid: sid,
          clientSecret: clientSecret,
          idServer: idServer,
          idAccessToken: idAccessToken,
        );

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['sid'] = sid;
    data['client_secret'] = clientSecret;
    if (idServer != null) data['id_server'] = idServer;
    if (idAccessToken != null) data['id_access_token'] = idAccessToken;
    return data;
  }
}

class _AccountBundleWithClient {
  final Client client;
  final AccountBundle bundle;
  _AccountBundleWithClient({this.client, this.bundle});
}
