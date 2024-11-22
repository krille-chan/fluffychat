import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:matrix/matrix.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher_string.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/homeserver_picker/homeserver_picker_view.dart';
import 'package:fluffychat/utils/file_selector.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../utils/localized_exception_extension.dart';

import 'package:fluffychat/utils/tor_stub.dart'
    if (dart.library.html) 'package:tor_detector_web/tor_detector_web.dart';

class HomeserverPicker extends StatefulWidget {
  final bool addMultiAccount;
  const HomeserverPicker({required this.addMultiAccount, super.key});

  @override
  HomeserverPickerController createState() => HomeserverPickerController();
}

class HomeserverPickerController extends State<HomeserverPicker> {
  bool isLoading = false;
  bool isLoggingIn = false;

  final TextEditingController homeserverController = TextEditingController(
    text: AppConfig.defaultHomeserver,
  );

  String? error;

  bool isTorBrowser = false;

  Future<void> _checkTorBrowser() async {
    if (!kIsWeb) return;

    Hive.openBox('test').then((value) => null).catchError(
      (e, s) async {
        await showOkAlertDialog(
          context: context,
          title: L10n.of(context).indexedDbErrorTitle,
          message: L10n.of(context).indexedDbErrorLong,
        );
        _checkTorBrowser();
      },
    );

    final isTor = await TorBrowserDetector.isTorBrowser;
    isTorBrowser = isTor;
  }

  String? _lastCheckedUrl;

  Timer? _checkHomeserverCooldown;

  tryCheckHomeserverActionWithCooldown([_]) {
    _checkHomeserverCooldown?.cancel();
    _checkHomeserverCooldown = Timer(
      const Duration(milliseconds: 500),
      checkHomeserverAction,
    );
  }

  void tryCheckHomeserverActionWithoutCooldown([_]) {
    _checkHomeserverCooldown?.cancel();
    _lastCheckedUrl = null;
    checkHomeserverAction();
  }

  void onSubmitted([_]) {
    if (isLoading || _checkHomeserverCooldown?.isActive == true) {
      return tryCheckHomeserverActionWithoutCooldown();
    }
    if (supportsSso) return ssoLoginAction();
    if (supportsPasswordLogin) return login();
    return tryCheckHomeserverActionWithoutCooldown();
  }

  /// Starts an analysis of the given homeserver. It uses the current domain and
  /// makes sure that it is prefixed with https. Then it searches for the
  /// well-known information and forwards to the login page depending on the
  /// login type.
  Future<void> checkHomeserverAction([_]) async {
    final homeserverInput =
        homeserverController.text.trim().toLowerCase().replaceAll(' ', '-');

    if (homeserverInput.isEmpty || !homeserverInput.contains('.')) {
      setState(() {
        error = loginFlows = null;
        isLoading = false;
        Matrix.of(context).getLoginClient().homeserver = null;
        _lastCheckedUrl = null;
      });
      return;
    }
    if (_lastCheckedUrl == homeserverInput) return;

    _lastCheckedUrl = homeserverInput;
    setState(() {
      error = loginFlows = null;
      isLoading = true;
    });

    try {
      var homeserver = Uri.parse(homeserverInput);
      if (homeserver.scheme.isEmpty) {
        homeserver = Uri.https(homeserverInput, '');
      }
      final client = Matrix.of(context).getLoginClient();
      final (_, _, loginFlows) = await client.checkHomeserver(homeserver);
      this.loginFlows = loginFlows;
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

  void ssoLoginAction() async {
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
      path: '/_matrix/client/v3/login/sso/redirect',
      queryParameters: {'redirectUrl': redirectUrl},
    );

    final urlScheme = isDefaultPlatform
        ? Uri.parse(redirectUrl).scheme
        : "http://localhost:3001";
    final result = await FlutterWebAuth2.authenticate(
      url: url.toString(),
      callbackUrlScheme: urlScheme,
      options: const FlutterWebAuth2Options(),
    );
    final token = Uri.parse(result).queryParameters['loginToken'];
    if (token?.isEmpty ?? false) return;

    setState(() {
      error = null;
      isLoading = isLoggingIn = true;
    });
    try {
      await Matrix.of(context).getLoginClient().login(
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
          isLoading = isLoggingIn = false;
        });
      }
    }
  }

  void login() async {
    if (!supportsPasswordLogin) {
      homeserverController.text = AppConfig.defaultHomeserver;
      await checkHomeserverAction();
    }
    context.push(
      '${GoRouter.of(context).routeInformationProvider.value.uri.path}/login',
    );
  }

  @override
  void initState() {
    _checkTorBrowser();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(checkHomeserverAction);
  }

  @override
  Widget build(BuildContext context) => HomeserverPickerView(this);

  Future<void> restoreBackup() async {
    final picked = await selectFiles(context);
    final file = picked.firstOrNull;
    if (file == null) return;
    setState(() {
      error = null;
      isLoading = isLoggingIn = true;
    });
    try {
      final client = Matrix.of(context).getLoginClient();
      await client.importDump(String.fromCharCodes(await file.readAsBytes()));
      Matrix.of(context).initMatrix();
    } catch (e) {
      setState(() {
        error = e.toLocalizedString(context);
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = isLoggingIn = false;
        });
      }
    }
  }

  void onMoreAction(MoreLoginActions action) {
    switch (action) {
      case MoreLoginActions.passwordLogin:
        login();
      case MoreLoginActions.privacy:
        launchUrlString(AppConfig.privacyUrl);
      case MoreLoginActions.about:
        PlatformInfos.showDialog(context);
    }
  }
}

enum MoreLoginActions { passwordLogin, privacy, about }

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
