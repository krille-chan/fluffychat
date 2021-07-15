import 'dart:async';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:matrix/matrix.dart';
import 'package:fluffychat/pages/views/homeserver_picker_view.dart';
import 'package:fluffychat/utils/famedlysdk_store.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/localized_exception_extension.dart';
import 'package:vrouter/vrouter.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:uni_links/uni_links.dart';

import '../main.dart';

class HomeserverPicker extends StatefulWidget {
  @override
  HomeserverPickerController createState() => HomeserverPickerController();
}

class HomeserverPickerController extends State<HomeserverPicker> {
  bool isLoading = false;
  String domain = AppConfig.defaultHomeserver;
  final TextEditingController homeserverController =
      TextEditingController(text: AppConfig.defaultHomeserver);
  StreamSubscription _intentDataStreamSubscription;
  String error;
  Timer _coolDown;

  void setDomain(String domain) {
    this.domain = domain;
    _coolDown?.cancel();
    if (domain.isNotEmpty) {
      _coolDown = Timer(Duration(seconds: 1), checkHomeserverAction);
    }
  }

  void _loginWithToken(String token) {
    if (token?.isEmpty ?? true) return;

    showFutureLoadingDialog(
      context: context,
      future: () async {
        if (Matrix.of(context).client.homeserver == null) {
          await Matrix.of(context).client.checkHomeserver(
                await Store()
                    .getItem(HomeserverPickerController.ssoHomeserverKey),
              );
        }
        await Matrix.of(context).client.login(
              type: AuthenticationTypes.token,
              token: token,
              initialDeviceDisplayName: PlatformInfos.clientName,
            );
      },
    );
  }

  void _processIncomingUris(String text) async {
    if (text == null || !text.startsWith(AppConfig.appOpenUrlScheme)) return;
    await browser?.close();
    VRouter.of(context).to('/home');
    final token = Uri.parse(text).queryParameters['loginToken'];
    if (token != null) _loginWithToken(token);
  }

  void _initReceiveUri() {
    if (!PlatformInfos.isMobile) return;
    // For receiving shared Uris
    _intentDataStreamSubscription = linkStream.listen(_processIncomingUris);
    if (FluffyChatApp.gotInitialLink == false) {
      FluffyChatApp.gotInitialLink = true;
      getInitialLink().then(_processIncomingUris);
    }
  }

  @override
  void initState() {
    super.initState();
    _initReceiveUri();
    if (kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final token = Matrix.of(context).widget.queryParameters['loginToken'];
        if (token != null) _loginWithToken(token);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _intentDataStreamSubscription?.cancel();
  }

  /// Starts an analysis of the given homeserver. It uses the current domain and
  /// makes sure that it is prefixed with https. Then it searches for the
  /// well-known information and forwards to the login page depending on the
  /// login type.
  void checkHomeserverAction() async {
    _coolDown?.cancel();
    try {
      if (domain.isEmpty) throw L10n.of(context).changeTheHomeserver;
      var homeserver = domain;

      if (!homeserver.startsWith('https://')) {
        homeserver = 'https://$homeserver';
      }

      setState(() {
        error = _rawLoginTypes = registrationSupported = null;
        isLoading = true;
      });
      final wellKnown =
          await Matrix.of(context).client.checkHomeserver(homeserver);

      var jitsi = wellKnown?.content
          ?.tryGet<Map<String, dynamic>>('im.vector.riot.jitsi')
          ?.tryGet<String>('preferredDomain');
      if (jitsi != null) {
        if (!jitsi.endsWith('/')) {
          jitsi += '/';
        }
        Logs().v('Found custom jitsi instance $jitsi');
        await Matrix.of(context)
            .store
            .setItem(SettingKeys.jitsiInstance, jitsi);
        AppConfig.jitsiInstance = jitsi;
      }
    } catch (e) {
      setState(() => error = '${(e as Object).toLocalizedString(context)}');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Map<String, dynamic> _rawLoginTypes;
  bool registrationSupported;

  List<IdentityProvider> get identityProviders {
    if (!ssoLoginSupported) return [];
    final rawProviders = _rawLoginTypes.tryGetList('flows').singleWhere(
        (flow) =>
            flow['type'] == AuthenticationTypes.sso)['identity_providers'];
    final list = (rawProviders as List)
        .map((json) => IdentityProvider.fromJson(json))
        .toList();
    if (PlatformInfos.isCupertinoStyle) {
      list.sort((a, b) => a.brand == 'apple' ? -1 : 1);
    }
    return list;
  }

  bool get passwordLoginSupported =>
      Matrix.of(context)
          .client
          .supportedLoginTypes
          .contains(AuthenticationTypes.password) &&
      _rawLoginTypes
          .tryGetList('flows')
          .any((flow) => flow['type'] == AuthenticationTypes.password);

  bool get ssoLoginSupported =>
      Matrix.of(context)
          .client
          .supportedLoginTypes
          .contains(AuthenticationTypes.sso) &&
      _rawLoginTypes
          .tryGetList('flows')
          .any((flow) => flow['type'] == AuthenticationTypes.sso);

  Future<Map<String, dynamic>> getLoginTypes() async {
    _rawLoginTypes ??= await Matrix.of(context).client.request(
          RequestType.GET,
          '/client/r0/login',
        );
    if (registrationSupported == null) {
      try {
        await Matrix.of(context).client.register();
        registrationSupported = true;
      } on MatrixException catch (e) {
        registrationSupported = e.requireAdditionalAuthentication ?? false;
      }
    }
    return _rawLoginTypes;
  }

  ChromeSafariBrowser browser;

  static const String ssoHomeserverKey = 'sso-homeserver';

  void ssoLoginAction(String id) {
    if (kIsWeb) {
      // We store the homserver in the local storage instead of a redirect
      // parameter because of possible CSRF attacks.
      Store().setItem(
          ssoHomeserverKey, Matrix.of(context).client.homeserver.toString());
    }
    final redirectUrl = kIsWeb
        ? AppConfig.webBaseUrl + '/#/'
        : AppConfig.appOpenUrlScheme.toLowerCase() + '://login';
    final url =
        '${Matrix.of(context).client.homeserver?.toString()}/_matrix/client/r0/login/sso/redirect/${Uri.encodeComponent(id)}?redirectUrl=${Uri.encodeQueryComponent(redirectUrl)}';
    if (PlatformInfos.isIOS) {
      browser ??= ChromeSafariBrowser();
      browser.open(url: Uri.parse(url));
    } else {
      launch(redirectUrl, forceWebView: true);
    }
  }

  void signUpAction() => launch(
        '${Matrix.of(context).client.homeserver?.toString()}/_matrix/static/client/register',
        forceSafariVC: true,
        forceWebView: true,
      );

  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    Matrix.of(context).navigatorContext = context;
    if (!_initialized) {
      _initialized = true;
      checkHomeserverAction();
    }
    return HomeserverPickerView(this);
  }
}

class IdentityProvider {
  final String id;
  final String name;
  final String icon;
  final String brand;

  IdentityProvider({this.id, this.name, this.icon, this.brand});

  factory IdentityProvider.fromJson(Map<String, dynamic> json) =>
      IdentityProvider(
        id: json['id'],
        name: json['name'],
        icon: json['icon'],
        brand: json['brand'],
      );
}
