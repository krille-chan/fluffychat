import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:animations/animations.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:matrix_homeserver_recommendations/matrix_homeserver_recommendations.dart';
import 'package:universal_html/html.dart' as html;
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/homeserver_picker/homeserver_picker_view.dart';
import 'package:fluffychat/utils/famedlysdk_store.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../utils/localized_exception_extension.dart';
import 'homeserver_tile.dart';

class HomeserverPicker extends StatefulWidget {
  const HomeserverPicker({Key? key}) : super(key: key);

  @override
  HomeserverPickerController createState() => HomeserverPickerController();
}

class HomeserverPickerController extends State<HomeserverPicker> {
  bool isLoading = true;

  String? domain;
  List<HomeserverBenchmarkResult>? benchmarkResults;

  TextEditingController? homeserverController;

  StreamSubscription? _intentDataStreamSubscription;
  String? error;
  Timer? _coolDown;

  late HomeserverListProvider parser;

  void setDomain(String domain) {
    this.domain = domain;
    _coolDown?.cancel();
    if (domain.isNotEmpty) {
      _coolDown =
          Timer(const Duration(milliseconds: 500), checkHomeserverAction);
    }
  }

  void _loginWithToken(String token) {
    if (token.isEmpty) return;

    showFutureLoadingDialog(
      context: context,
      future: () async {
        if (Matrix.of(context).getLoginClient().homeserver == null) {
          await Matrix.of(context).getLoginClient().checkHomeserver(
                await Store()
                    .getItem(HomeserverPickerController.ssoHomeserverKey),
              );
        }
        await Matrix.of(context).getLoginClient().login(
              LoginType.mLoginToken,
              token: token,
              initialDeviceDisplayName: PlatformInfos.clientName,
            );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    checkHomeserverAction();
    benchmarkHomeServers();
  }

  @override
  void dispose() {
    super.dispose();
    _intentDataStreamSubscription?.cancel();
  }

  String? _lastCheckedHomeserver;

  /// Starts an analysis of the given homeserver. It uses the current domain and
  /// makes sure that it is prefixed with https. Then it searches for the
  /// well-known information and forwards to the login page depending on the
  /// login type.
  Future<void> checkHomeserverAction() async {
    _coolDown?.cancel();
    if (_lastCheckedHomeserver == domain) return;
    if (domain == null || domain!.isEmpty) {
      throw L10n.of(context)!.changeTheHomeserver;
    }
    var homeserver = domain;

    if (!homeserver!.startsWith('https://')) {
      homeserver = 'https://$homeserver';
    }

    setState(() {
      error = _rawLoginTypes = registrationSupported = null;
      isLoading = true;
    });

    try {
      await Matrix.of(context).getLoginClient().checkHomeserver(homeserver);

      _rawLoginTypes = await Matrix.of(context).getLoginClient().request(
            RequestType.GET,
            '/client/r0/login',
          );
      try {
        await Matrix.of(context).getLoginClient().register();
        registrationSupported = true;
      } on MatrixException catch (e) {
        registrationSupported = e.requireAdditionalAuthentication;
      }
    } catch (e) {
      setState(() => error = (e).toLocalizedString(context));
    } finally {
      _lastCheckedHomeserver = domain;
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Map<String, dynamic>? _rawLoginTypes;
  bool? registrationSupported;

  List<IdentityProvider> get identityProviders {
    if (!ssoLoginSupported) return [];
    final rawProviders = _rawLoginTypes!.tryGetList('flows')!.singleWhere(
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
      _rawLoginTypes!
          .tryGetList('flows')!
          .any((flow) => flow['type'] == AuthenticationTypes.password);

  bool get ssoLoginSupported =>
      Matrix.of(context)
          .client
          .supportedLoginTypes
          .contains(AuthenticationTypes.sso) &&
      _rawLoginTypes!
          .tryGetList('flows')!
          .any((flow) => flow['type'] == AuthenticationTypes.sso);

  static const String ssoHomeserverKey = 'sso-homeserver';

  void ssoLoginAction(String id) async {
    if (kIsWeb) {
      // We store the homserver in the local storage instead of a redirect
      // parameter because of possible CSRF attacks.
      Store().setItem(ssoHomeserverKey,
          Matrix.of(context).getLoginClient().homeserver.toString());
    }
    final redirectUrl = kIsWeb
        ? html.window.origin! + '/web/auth.html'
        : AppConfig.appOpenUrlScheme.toLowerCase() + '://login';
    final url =
        '${Matrix.of(context).getLoginClient().homeserver?.toString()}/_matrix/client/r0/login/sso/redirect/${Uri.encodeComponent(id)}?redirectUrl=${Uri.encodeQueryComponent(redirectUrl)}';
    final urlScheme = Uri.parse(redirectUrl).scheme;
    final result = await FlutterWebAuth.authenticate(
      url: url,
      callbackUrlScheme: urlScheme,
    );
    final token = Uri.parse(result).queryParameters['loginToken'];
    if (token != null) _loginWithToken(token);
  }

  void signUpAction() => VRouter.of(context).to(
        'signup',
        queryParameters: {'domain': domain!},
      );

  @override
  Widget build(BuildContext context) {
    Matrix.of(context).navigatorContext = context;
    return HomeserverPickerView(this);
  }

  Future<void> benchmarkHomeServers() async {
    try {
      parser = JoinmatrixOrgParser();
      final homeserverList = await parser.fetchHomeservers();
      final benchmark = await HomeserverListProvider.benchmarkHomeserver(
        homeserverList,
        timeout: const Duration(seconds: 10),
        // TODO: do not rely on the homeserver list information telling the server supports registration
      );

      if (benchmark.isEmpty) {
        throw NullThrownError();
      }

      // trying to use server without anti-features
      final goodServers = <HomeserverBenchmarkResult>[];
      final badServers = <HomeserverBenchmarkResult>[];
      for (final result in benchmark) {
        if (result.homeserver.antiFeatures == null) {
          goodServers.add(result);
        } else {
          badServers.add(result);
        }
      }

      goodServers.sort();
      badServers.sort();

      benchmarkResults = List.from([...goodServers, ...badServers]);

      domain = benchmarkResults!.first.homeserver.baseUrl.host;
    } on Exception catch (e, s) {
      Logs().e('Homeserver benchmark failed', e, s);
      domain = AppConfig.defaultHomeserver;
    } finally {
      homeserverController = TextEditingController(text: domain);
      checkHomeserverAction();
    }
  }

  Future<void> showServerPicker() async {
    final selection = await showModal(
      context: context,
      builder: (context) => SimpleDialog(
          title: Text(L10n.of(context)!.changeTheHomeserver),
          children: [
            ...benchmarkResults!.map<Widget>(
              (e) => HomeserverTile(
                benchmark: e,
                onSelect: () {
                  Navigator.of(context).pop(e.homeserver);
                },
              ),
            ),
            const Divider(),
            JoinMatrixAttributionTile(),
          ]),
    );
    if (selection is Homeserver) {
      if (domain != selection.baseUrl.host) {
        setState(() {
          domain = selection.baseUrl.host;
          homeserverController!.text = domain!;
        });
        checkHomeserverAction();
      }
    }
  }
}

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
