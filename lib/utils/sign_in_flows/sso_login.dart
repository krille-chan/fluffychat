import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:matrix/matrix.dart';
import 'package:universal_html/html.dart' as html;

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/platform_infos.dart';

Future<void> ssoLoginFlow(
  Client client,
  BuildContext context,
  bool signUp,
) async {
  Logs().i('Starting legacy SSO Flow...');
  final redirectUrl = kIsWeb
      ? Uri.parse(
          html.window.location.href,
        ).resolveUri(Uri(pathSegments: ['auth.html'])).toString()
      : (PlatformInfos.isMobile || PlatformInfos.isWeb || PlatformInfos.isMacOS)
      ? '${AppConfig.appOpenUrlScheme.toLowerCase()}://login'
      : 'http://localhost:3001//login';

  final url = client.homeserver!.replace(
    path: '/_matrix/client/v3/login/sso/redirect',
    queryParameters: {
      'redirectUrl': redirectUrl,
      'action': signUp ? 'register' : 'login',
    },
  );

  final urlScheme =
      (PlatformInfos.isMobile || PlatformInfos.isWeb || PlatformInfos.isMacOS)
      ? Uri.parse(redirectUrl).scheme
      : 'http://localhost:3001';
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
