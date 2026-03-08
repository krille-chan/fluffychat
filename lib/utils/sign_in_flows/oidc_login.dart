import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:matrix/matrix.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/utils/matrix_sdk_extensions/oidc_session_json_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/sign_in_flows/calc_redirect_url.dart';

Future<void> oidcLoginFlow(
  Client client,
  BuildContext context,
  bool signUp,
) async {
  Logs().i('Starting Matrix Native OIDC Flow...');

  final (redirectUrl, urlScheme) = calcRedirectUrl();

  final clientUri = Uri.parse(AppSettings.website.value);
  final supportWebPlatform =
      kIsWeb &&
      kReleaseMode &&
      redirectUrl.scheme == 'https' &&
      redirectUrl.host.contains(clientUri.host);
  if (kIsWeb && !supportWebPlatform) {
    Logs().w(
      'OIDC Application Type web is not supported. Using native now. Please use this instance not in production!',
    );
  }

  final oidcClientData = await client.registerOidcClient(
    redirectUris: [redirectUrl],
    applicationType: supportWebPlatform
        ? OidcApplicationType.web
        : OidcApplicationType.native,
    clientInformation: OidcClientInformation(
      clientName: AppSettings.applicationName.value,
      clientUri: clientUri,
      logoUri: Uri.parse(AppSettings.logoUrl.value),
      tosUri: Uri.parse(AppSettings.tos.value),
      policyUri: Uri.parse(AppSettings.privacyPolicy.value),
    ),
  );

  final session = await client.initOidcLoginSession(
    oidcClientData: oidcClientData,
    redirectUri: redirectUrl,
    prompt: signUp ? 'create' : null,
  );

  if (!context.mounted) return;

  if (kIsWeb) {
    final store = await SharedPreferences.getInstance();
    store.setString(
      OidcSessionJsonExtension.homeserverStoreKey,
      client.homeserver!.toString(),
    );
    store.setString(
      OidcSessionJsonExtension.storeKey,
      jsonEncode(session.toJson()),
    );
  }

  final returnUrlString = await FlutterWebAuth2.authenticate(
    url: session.authenticationUri.toString(),
    callbackUrlScheme: urlScheme,
    options: FlutterWebAuth2Options(
      useWebview: PlatformInfos.isMobile,
      windowName: '_self',
    ),
  );
  if (kIsWeb) return; // On Web we return at intro page when app starts again!

  final returnUrl = Uri.parse(returnUrlString);
  final queryParameters = returnUrl.hasFragment
      ? Uri.parse(returnUrl.fragment).queryParameters
      : returnUrl.queryParameters;
  final code = queryParameters['code'] as String;
  final state = queryParameters['state'] as String;

  await client.oidcLogin(session: session, code: code, state: state);
}
