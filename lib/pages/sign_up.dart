import 'dart:async';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/views/sign_up_view.dart';
import 'package:fluffychat/utils/platform_infos.dart';

import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:universal_html/html.dart' as html;
import 'package:vrouter/vrouter.dart';

import '../main.dart';

class SignUp extends StatefulWidget {
  @override
  SignUpController createState() => SignUpController();
}

class SignUpController extends State<SignUp> {
  Map<String, dynamic> _rawLoginTypes;
  bool registrationSupported;
  StreamSubscription _intentDataStreamSubscription;
  List<IdentityProvider> get identityProviders {
    if (!ssoLoginSupported) return [];
    final rawProviders = _rawLoginTypes.tryGetList('flows').singleWhere(
        (flow) =>
            flow['type'] == AuthenticationTypes.sso)['identity_providers'];
    return (rawProviders as List)
        .map((json) => IdentityProvider.fromJson(json))
        .toList();
  }

  void _loginWithToken(String token) {
    if (token?.isEmpty ?? true) return;
    showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context).client.login(
            type: AuthenticationTypes.token,
            token: token,
            initialDeviceDisplayName: PlatformInfos.clientName,
          ),
    );
  }

  void _processIncomingUris(String text) async {
    if (text == null || !text.startsWith(AppConfig.appOpenUrlScheme)) return;
    VRouter.of(context).push('/home');
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
        final token =
            Uri.parse(html.window.location.href).queryParameters['loginToken'];
        _loginWithToken(token);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _intentDataStreamSubscription?.cancel();
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

  void ssoLoginAction(String id) {
    final redirectUrl = kIsWeb
        ? html.window.location.href
        : AppConfig.appOpenUrlScheme.toLowerCase() + '://sso';
    launch(
        '${Matrix.of(context).client.homeserver?.toString()}/_matrix/client/r0/login/sso/redirect/${Uri.encodeComponent(id)}?redirectUrl=${Uri.encodeQueryComponent(redirectUrl)}');
  }

  void signUpAction() => launch(
      '${Matrix.of(context).client.homeserver?.toString()}/_matrix/static/client/register');

  @override
  Widget build(BuildContext context) => SignUpView(this);
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
