import 'dart:async';

import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/views/ui/homeserver_picker_ui.dart';
import 'package:fluffychat/views/widgets/matrix.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/utils/platform_infos.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/localized_exception_extension.dart';
import 'package:universal_html/html.dart' as html;

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
      future: () => Matrix.of(context).client.login(
            type: AuthenticationTypes.token,
            token: token,
            initialDeviceDisplayName: PlatformInfos.clientName,
          ),
    );
  }

  void _processIncomingSharedText(String text) async {
    if (text == null || !text.startsWith(AppConfig.appOpenUrlScheme)) return;
    AdaptivePageLayout.of(context).popUntilIsFirst();
    final token = Uri.parse(text).queryParameters['loginToken'];
    _loginWithToken(token);
  }

  void _initReceiveSharingContent() {
    if (!PlatformInfos.isMobile) return;
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen(_processIncomingSharedText);
    ReceiveSharingIntent.getInitialText().then(_processIncomingSharedText);
  }

  @override
  void initState() {
    super.initState();
    _initReceiveSharingContent();
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

      final loginTypes = await Matrix.of(context).client.requestLoginTypes();
      if (loginTypes.flows
          .any((flow) => flow.type == AuthenticationTypes.password)) {
        await AdaptivePageLayout.of(context)
            .pushNamed(AppConfig.enableRegistration ? '/signup' : '/login');
      } else if (loginTypes.flows
          .any((flow) => flow.type == AuthenticationTypes.sso)) {
        final redirectUrl = kIsWeb
            ? html.window.location.href
            : AppConfig.appOpenUrlScheme.toLowerCase() + '://sso';
        await launch(
            '${Matrix.of(context).client.homeserver?.toString()}/_matrix/client/r0/login/sso/redirect?redirectUrl=${Uri.encodeQueryComponent(redirectUrl)}');
      }
    } catch (e) {
      AdaptivePageLayout.of(context).showSnackBar(
          SnackBar(content: Text((e as Object).toLocalizedString(context))));
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => HomeserverPickerUI(this);
}
