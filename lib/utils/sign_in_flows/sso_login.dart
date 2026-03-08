import 'package:flutter/material.dart';

import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/utils/sign_in_flows/calc_redirect_url.dart';

Future<void> ssoLoginFlow(
  Client client,
  BuildContext context,
  bool signUp,
) async {
  final (redirectUrl, urlScheme) = calcRedirectUrl(withAuthHtmlPath: true);

  Logs().i('Starting legacy SSO Flow with redirect URL', redirectUrl);

  final url = client.homeserver!.replace(
    path: '/_matrix/client/v3/login/sso/redirect',
    queryParameters: {
      'redirectUrl': redirectUrl.toString(),
      'action': signUp ? 'register' : 'login',
    },
  );

  final result = await FlutterWebAuth2.authenticate(
    url: url.toString(),
    callbackUrlScheme: urlScheme,
    options: FlutterWebAuth2Options(useWebview: PlatformInfos.isMobile),
  );
  final token = Uri.parse(result).queryParameters['loginToken'];
  if (token?.isEmpty ?? false) return;

  await client.login(
    LoginType.mLoginToken,
    token: token,
    initialDeviceDisplayName: PlatformInfos.clientName,
  );
}
