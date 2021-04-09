import 'dart:async';

import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/components/default_app_bar_search_field.dart';
import 'package:fluffychat/components/fluffy_banner.dart';
import 'package:fluffychat/components/matrix.dart';
import 'package:fluffychat/app_config.dart';
import 'package:fluffychat/components/one_page_card.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/utils/platform_infos.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/localized_exception_extension.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;

class HomeserverPicker extends StatefulWidget {
  @override
  _HomeserverPickerState createState() => _HomeserverPickerState();
}

class _HomeserverPickerState extends State<HomeserverPicker> {
  bool _isLoading = false;
  String _domain = AppConfig.defaultHomeserver;
  final TextEditingController _controller =
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
  }

  @override
  void dispose() {
    super.dispose();
    _intentDataStreamSubscription?.cancel();
  }

  void _checkHomeserverAction(BuildContext context) async {
    try {
      if (_domain.isEmpty) throw L10n.of(context).changeTheHomeserver;
      var homeserver = _domain;

      if (!homeserver.startsWith('https://')) {
        homeserver = 'https://$homeserver';
      }

      setState(() => _isLoading = true);
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
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final token =
            Uri.parse(html.window.location.href).queryParameters['loginToken'];
        _loginWithToken(token);
      });
    }
    return OnePageCard(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 8,
          title: DefaultAppBarSearchField(
            prefixText: 'https://',
            hintText: L10n.of(context).enterYourHomeserver,
            searchController: _controller,
            suffix: Icon(Icons.edit_outlined),
            padding: EdgeInsets.zero,
            onChanged: (s) => _domain = s,
            readOnly: !AppConfig.allowOtherHomeservers,
            onSubmit: (_) => _checkHomeserverAction(context),
          ),
          elevation: 0,
        ),
        body: SafeArea(
          child: ListView(
            children: [
              Hero(
                tag: 'loginBanner',
                child: FluffyBanner(),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  AppConfig.applicationWelcomeMessage ??
                      L10n.of(context).welcomeText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: 'loginButton',
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: ElevatedButton(
                  onPressed:
                      _isLoading ? null : () => _checkHomeserverAction(context),
                  child: _isLoading
                      ? LinearProgressIndicator()
                      : Text(
                          L10n.of(context).connect.toUpperCase(),
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              ),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                TextButton(
                  onPressed: () => launch(AppConfig.privacyUrl),
                  child: Text(
                    L10n.of(context).privacy,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => PlatformInfos.showDialog(context),
                  child: Text(
                    L10n.of(context).about,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
