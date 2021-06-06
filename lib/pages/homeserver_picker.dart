import 'dart:async';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/pages/sign_up.dart';
import 'package:fluffychat/pages/views/homeserver_picker_view.dart';
import 'package:fluffychat/utils/famedlysdk_store.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter/material.dart';
import '../utils/localized_exception_extension.dart';
import 'package:vrouter/vrouter.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:uni_links/uni_links.dart';
import 'package:universal_html/html.dart' as html;

import '../main.dart';

class HomeserverPicker extends StatefulWidget {
  @override
  HomeserverPickerController createState() => HomeserverPickerController();
}

class HomeserverPickerController extends State<HomeserverPicker> {
  bool isLoading = false;
  String domain = AppConfig.defaultHomeserver;
  final TextEditingController homeserverController =
      TextEditingController(text: AppConfig.defaultHomeserver);
  StreamSubscription _intentDataStreamSubscription;

  void _loginWithToken(String token) {
    if (token?.isEmpty ?? true) return;

    showFutureLoadingDialog(
      context: context,
      future: () async {
        if (Matrix.of(context).client.homeserver == null) {
          await Matrix.of(context).client.checkHomeserver(
                await Store().getItem(SignUpController.ssoHomeserverKey),
              );
        }
        await Matrix.of(context).client.login(
              type: AuthenticationTypes.token,
              token: token,
              initialDeviceDisplayName: PlatformInfos.clientName,
            );
      },
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

  /// Starts an analysis of the given homeserver. It uses the current domain and
  /// makes sure that it is prefixed with https. Then it searches for the
  /// well-known information and forwards to the login page depending on the
  /// login type. For SSO login only the app opens the page and otherwise it
  /// forwards to the route `/signup`.
  void checkHomeserverAction() async {
    try {
      if (domain.isEmpty) throw L10n.of(context).changeTheHomeserver;
      var homeserver = domain;

      if (!homeserver.startsWith('https://')) {
        homeserver = 'https://$homeserver';
      }

      setState(() => isLoading = true);
      final wellKnown =
          await Matrix.of(context).client.checkHomeserver(homeserver);

      var jitsi = wellKnown?.content
          ?.tryGet<Map<String, dynamic>>('im.vector.riot.jitsi')
          ?.tryGet<String>('preferredDomain');
      if (jitsi != null) {
        if (!jitsi.endsWith('/')) {
          jitsi += '/';
        }
        Logs().v('Found custom jitsi instance $jitsi');
        await Matrix.of(context)
            .store
            .setItem(SettingKeys.jitsiInstance, jitsi);
        AppConfig.jitsiInstance = jitsi;
      }

      VRouter.of(context).push(
          AppConfig.enableRegistration ? '/signup' : '/login',
          historyState: {'/home': '/signup'});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text((e as Object).toLocalizedString(context))));
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Matrix.of(context).navigatorContext = context;
    return HomeserverPickerView(this);
  }
}
