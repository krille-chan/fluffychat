import 'package:flutter/foundation.dart';

import 'package:universal_html/html.dart' as html;

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/platform_infos.dart';

(Uri redirectUrl, String urlScheme) calcRedirectUrl({
  bool withAuthHtmlPath = false,
}) {
  var redirectUrl = kIsWeb
      ? Uri.parse(html.window.location.href.split('#').first.split('?').first)
      : (PlatformInfos.isMobile || PlatformInfos.isMacOS)
      ? Uri.parse('${AppConfig.appOpenUrlScheme.toLowerCase()}:/login')
      : Uri.parse('http://localhost:3001/login');

  if (kIsWeb && withAuthHtmlPath) {
    redirectUrl = redirectUrl.resolveUri(Uri(pathSegments: ['auth.html']));
  }

  final urlScheme =
      (PlatformInfos.isMobile || PlatformInfos.isWeb || PlatformInfos.isMacOS)
      ? redirectUrl.scheme
      : 'http://localhost:3001';

  return (redirectUrl, urlScheme);
}
