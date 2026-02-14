import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:matrix/matrix.dart';
import 'package:universal_html/html.dart' as html;

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';

Future<void> oidcLoginFlow(
  Client client,
  BuildContext context,
  bool signUp,
) async {
  Logs().i('Starting Matrix Native OIDC Flow...');
  final redirectUrl = kIsWeb
      ? Uri.parse(
          html.window.location.href,
        ).resolveUri(Uri(pathSegments: ['auth.html']))
      : (PlatformInfos.isMobile || PlatformInfos.isWeb || PlatformInfos.isMacOS)
      ? Uri.parse('${AppConfig.appOpenUrlScheme.toLowerCase()}:/login')
      : Uri.parse('http://localhost:3001/login');

  final urlScheme =
      (PlatformInfos.isMobile || PlatformInfos.isWeb || PlatformInfos.isMacOS)
      ? redirectUrl.scheme
      : "http://localhost:3001";

  final oidcClientData = await client.registerOidcClient(
    redirectUris: [redirectUrl],
    applicationType: (kIsWeb && kReleaseMode)
        ? OidcApplicationType.web
        : OidcApplicationType.native,
    clientInformation: OidcClientInformation(
      clientName: AppSettings.applicationName.value,
      clientUri: Uri.parse(AppConfig.website),
      logoUri: Uri.parse('https://fluffy.chat/assets/favicon.png'),
      tosUri: null,
      policyUri: AppConfig.privacyUrl,
    ),
  );

  final session = await client.initOidcLoginSession(
    oidcClientData: oidcClientData,
    redirectUri: redirectUrl,
    prompt: signUp ? 'create' : null,
  );

  if (!PlatformInfos.isMobile && !PlatformInfos.isMacOS) {
    final consent = await showOkCancelAlertDialog(
      context: context,
      title: L10n.of(
        context,
      ).appWantsToUseForLogin(client.homeserver!.toString()),
      message: L10n.of(context).appWantsToUseForLoginDescription,
      okLabel: L10n.of(context).continueText,
    );
    if (consent != OkCancelResult.ok) return;
  }
  if (!context.mounted) return;

  final returnUrlString = await FlutterWebAuth2.authenticate(
    url: session.authenticationUri.toString(),
    callbackUrlScheme: urlScheme,
    options: FlutterWebAuth2Options(useWebview: PlatformInfos.isMobile),
  );
  final returnUrl = Uri.parse(returnUrlString);
  final queryParameters = returnUrl.hasFragment
      ? Uri.parse(returnUrl.fragment).queryParameters
      : returnUrl.queryParameters;
  final code = queryParameters['code'] as String;
  final state = queryParameters['state'] as String;

  await client.oidcLogin(session: session, code: code, state: state);
}
