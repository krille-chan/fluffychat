import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:matrix/matrix.dart';
import 'package:universal_html/html.dart' as html;

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/homeserver_picker/homeserver_picker.dart';
import 'package:fluffychat/pangea/common/utils/firebase_analytics.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/matrix.dart';

Future<void> pangeaSSOLoginAction(
  IdentityProvider provider,
  Client client,
  BuildContext context,
) async {
  final bool isDefaultPlatform =
      (PlatformInfos.isMobile || PlatformInfos.isWeb || PlatformInfos.isMacOS);

  final redirectUrl = kIsWeb
      ? Uri.parse(html.window.location.href)
          .resolveUri(
            Uri(pathSegments: ['auth.html']),
          )
          .toString()
      : isDefaultPlatform
          ? '${AppConfig.appOpenUrlScheme.toLowerCase()}://login'
          : 'http://localhost:3001//login';

  final url = Matrix.of(context).getLoginClient().homeserver!.replace(
    path: '/_matrix/client/v3/login/sso/redirect/${provider.id ?? ''}',
    queryParameters: {'redirectUrl': redirectUrl},
  );

  final urlScheme = isDefaultPlatform
      ? Uri.parse(redirectUrl).scheme
      : "http://localhost:3001";

  String result;
  try {
    result = await FlutterWebAuth2.authenticate(
      url: url.toString(),
      callbackUrlScheme: urlScheme,
    );
  } catch (err) {
    if (err is PlatformException && err.code == 'CANCELED') {
      debugPrint("user cancelled SSO login");
      return;
    }
    rethrow;
  }

  final token = Uri.parse(result).queryParameters['loginToken'];
  if (token?.isEmpty ?? false) return;

  final loginRes = await client.login(
    LoginType.mLoginToken,
    token: token,
    initialDeviceDisplayName: PlatformInfos.clientName,
  );

  GoogleAnalytics.login(provider.name!, loginRes.userId);
}
