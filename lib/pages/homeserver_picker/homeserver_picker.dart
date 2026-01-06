import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/homeserver_picker/homeserver_picker_view.dart';
import 'package:fluffychat/utils/file_selector.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../utils/localized_exception_extension.dart';

class HomeserverPicker extends StatefulWidget {
  final bool addMultiAccount;
  const HomeserverPicker({required this.addMultiAccount, super.key});

  @override
  HomeserverPickerController createState() => HomeserverPickerController();
}

class HomeserverPickerController extends State<HomeserverPicker> {
  bool isLoading = false;

  final TextEditingController homeserverController = TextEditingController(
    text: AppSettings.defaultHomeserver.value,
  );

  String? error;

  /// Starts an analysis of the given homeserver. It uses the current domain and
  /// makes sure that it is prefixed with https. Then it searches for the
  /// well-known information and forwards to the login page depending on the
  /// login type.
  Future<void> checkHomeserverAction({bool legacyPasswordLogin = false}) async {
    final homeserverInput = homeserverController.text
        .trim()
        .toLowerCase()
        .replaceAll(' ', '-');

    if (homeserverInput.isEmpty) {
      final client = await Matrix.of(context).getLoginClient();
      setState(() {
        error = loginFlows = null;
        isLoading = false;
        client.homeserver = null;
      });
      return;
    }
    setState(() {
      error = loginFlows = null;
      isLoading = true;
    });

    final l10n = L10n.of(context);

    try {
      var homeserver = Uri.parse(homeserverInput);
      if (homeserver.scheme.isEmpty) {
        homeserver = Uri.https(homeserverInput, '');
      }
      final client = await Matrix.of(context).getLoginClient();
      final (_, _, loginFlows, authMetadata) = await client.checkHomeserver(
        homeserver,
        fetchAuthMetadata: true,
      );
      this.loginFlows = loginFlows;
      if (authMetadata != null) {
        return oidcLoginAction();
      }
      if (supportsSso && !legacyPasswordLogin) {
        if (!PlatformInfos.isMobile) {
          final consent = await showOkCancelAlertDialog(
            context: context,
            title: l10n.appWantsToUseForLogin(homeserverInput),
            message: l10n.appWantsToUseForLoginDescription,
            okLabel: l10n.continueText,
          );
          if (consent != OkCancelResult.ok) return;
        }
        return ssoLoginAction();
      }
      context.push(
        '${GoRouter.of(context).routeInformationProvider.value.uri.path}/login',
        extra: client,
      );
    } catch (e) {
      setState(
        () => error = (e).toLocalizedString(
          context,
          ExceptionContext.checkHomeserver,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  List<LoginFlow>? loginFlows;

  bool _supportsFlow(String flowType) =>
      loginFlows?.any((flow) => flow.type == flowType) ?? false;

  bool get supportsSso => _supportsFlow('m.login.sso');

  bool isDefaultPlatform =
      (PlatformInfos.isMobile || PlatformInfos.isWeb || PlatformInfos.isMacOS);

  bool get supportsPasswordLogin => _supportsFlow('m.login.password');

  final _oidcClientDataMap = <Uri, OidcClientData>{};

  void oidcLoginAction() async {
    final redirectUrl = kIsWeb
        ? Uri.parse(
            html.window.location.href,
          ).resolveUri(Uri(pathSegments: ['auth.html']))
        : isDefaultPlatform
        ? Uri.parse('${AppConfig.appOpenUrlScheme.toLowerCase()}:/login')
        : Uri.parse('http://localhost:3001/login');

    final urlScheme = isDefaultPlatform
        ? redirectUrl.scheme
        : "http://localhost:3001";

    setState(() {
      error = null;
      isLoading = true;
    });

    try {
      final client = await Matrix.of(context).getLoginClient();

      final oidcClientData = _oidcClientDataMap[client.homeserver!] ??=
          await client.registerOidcClient(
            redirectUris: [redirectUrl],
            applicationType: kIsWeb
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
      if (!mounted) return;

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
    } catch (e) {
      setState(() {
        error = e.toLocalizedString(context);
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void ssoLoginAction() async {
    final redirectUrl = kIsWeb
        ? Uri.parse(
            html.window.location.href,
          ).resolveUri(Uri(pathSegments: ['auth.html'])).toString()
        : isDefaultPlatform
        ? '${AppConfig.appOpenUrlScheme.toLowerCase()}://login'
        : 'http://localhost:3001//login';
    final client = await Matrix.of(context).getLoginClient();
    final url = client.homeserver!.replace(
      path: '/_matrix/client/v3/login/sso/redirect',
      queryParameters: {'redirectUrl': redirectUrl},
    );

    final urlScheme = isDefaultPlatform
        ? Uri.parse(redirectUrl).scheme
        : "http://localhost:3001";
    final result = await FlutterWebAuth2.authenticate(
      url: url.toString(),
      callbackUrlScheme: urlScheme,
      options: FlutterWebAuth2Options(useWebview: PlatformInfos.isMobile),
    );
    final token = Uri.parse(result).queryParameters['loginToken'];
    if (token?.isEmpty ?? false) return;

    setState(() {
      error = null;
      isLoading = true;
    });
    try {
      await client.login(
        LoginType.mLoginToken,
        token: token,
        initialDeviceDisplayName: PlatformInfos.clientName,
      );
    } catch (e) {
      setState(() {
        error = e.toLocalizedString(context);
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => HomeserverPickerView(this);

  Future<void> restoreBackup() async {
    final picked = await selectFiles(context);
    final file = picked.firstOrNull;
    if (file == null) return;
    setState(() {
      error = null;
      isLoading = true;
    });
    try {
      final client = await Matrix.of(context).getLoginClient();
      await client.importDump(String.fromCharCodes(await file.readAsBytes()));
      Matrix.of(context).initMatrix();
    } catch (e) {
      setState(() {
        error = e.toLocalizedString(context);
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void onMoreAction(MoreLoginActions action) {
    switch (action) {
      case MoreLoginActions.importBackup:
        restoreBackup();
      case MoreLoginActions.privacy:
        launchUrl(AppConfig.privacyUrl);
      case MoreLoginActions.about:
        PlatformInfos.showDialog(context);
    }
  }
}

enum MoreLoginActions { importBackup, privacy, about }

class IdentityProvider {
  final String? id;
  final String? name;
  final String? icon;
  final String? brand;

  IdentityProvider({this.id, this.name, this.icon, this.brand});

  factory IdentityProvider.fromJson(Map<String, dynamic> json) =>
      IdentityProvider(
        id: json['id'],
        name: json['name'],
        icon: json['icon'],
        brand: json['brand'],
      );
}
