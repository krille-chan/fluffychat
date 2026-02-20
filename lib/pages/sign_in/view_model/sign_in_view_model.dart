import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:matrix/matrix.dart';
import 'package:universal_html/html.dart' as html;

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/pages/sign_in/view_model/flows/sort_homeservers.dart';
import 'package:fluffychat/pages/sign_in/view_model/model/public_homeserver_data.dart';
import 'package:fluffychat/pages/sign_in/view_model/sign_in_state.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/matrix.dart';

class SignInViewModel extends ValueNotifier<SignInState> {
  final MatrixState matrixService;
  final bool signUp;
  final TextEditingController filterTextController = TextEditingController();

  SignInViewModel(this.matrixService, {required this.signUp})
    : super(SignInState()) {
    refreshPublicHomeservers();
    filterTextController.addListener(_filterHomeservers);
  }

  @override
  void dispose() {
    filterTextController.removeListener(_filterHomeservers);
    super.dispose();
  }

  void _filterHomeservers() {
    final filterText = filterTextController.text.trim().toLowerCase();
    final filteredPublicHomeservers =
        value.publicHomeservers.data
            ?.where(
              (homeserver) =>
                  homeserver.name?.toLowerCase().contains(filterText) ?? false,
            )
            .toList() ??
        [];
    final splitted = filterText.split('.');
    if (splitted.length >= 2 && !splitted.any((part) => part.isEmpty)) {
      if (!filteredPublicHomeservers.any(
        (homeserver) => homeserver.name == filterText,
      )) {
        filteredPublicHomeservers.add(PublicHomeserverData(name: filterText));
      }
    }
    value = value.copyWith(
      filteredPublicHomeservers: filteredPublicHomeservers,
    );
  }

  void refreshPublicHomeservers() async {
    value = value.copyWith(publicHomeservers: AsyncSnapshot.waiting());
    final defaultHomeserverData = PublicHomeserverData(
      name: AppSettings.defaultHomeserver.value,
    );
    try {
      final client = await matrixService.getLoginClient();
      final response = await client.httpClient.get(AppConfig.homeserverList);
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final homeserverJsonList = json['public_servers'] as List;

      final publicHomeservers = homeserverJsonList
          .map((json) => PublicHomeserverData.fromJson(json))
          .toList();

      if (signUp) {
        publicHomeservers.removeWhere((server) {
          return server.regMethod == null;
        });
      }

      publicHomeservers.sort(sortHomeservers);

      final defaultServer =
          publicHomeservers.singleWhereOrNull(
            (server) => server.name == AppSettings.defaultHomeserver.value,
          ) ??
          defaultHomeserverData;

      publicHomeservers.insert(0, defaultServer);

      value = value.copyWith(
        selectedHomeserver: value.selectedHomeserver ?? publicHomeservers.first,
        publicHomeservers: AsyncSnapshot.withData(
          ConnectionState.done,
          publicHomeservers,
        ),
      );
    } catch (e, s) {
      Logs().w('Unable to fetch public homeservers...', e, s);
      value = value.copyWith(
        selectedHomeserver: defaultHomeserverData,
        publicHomeservers: AsyncSnapshot.withData(ConnectionState.done, [
          defaultHomeserverData,
        ]),
      );
    }
    _filterHomeservers();
  }

  void selectHomeserver(PublicHomeserverData? publicHomeserverData) {
    value = value.copyWith(selectedHomeserver: publicHomeserverData);
  }

  void setLoginLoading(AsyncSnapshot<bool> loginLoading) {
    value = value.copyWith(loginLoading: loginLoading);
  }

  void autoSsoIfEnabled(BuildContext context) async {
    if (!kIsWeb || signUp) return;
    if (!AppSettings.autoSsoRedirect.value) return;
    final defaultHS = AppSettings.defaultHomeserver.value;
    if (defaultHS.isEmpty ||
        defaultHS == AppSettings.defaultHomeserver.defaultValue) {
      Logs().w(
        '[AutoSSO] autoSsoRedirect requires defaultHomeserver to be set',
      );
      return;
    }

    setLoginLoading(AsyncSnapshot.waiting());
    try {
      var homeserver = Uri.parse(defaultHS);
      if (homeserver.scheme.isEmpty) {
        homeserver = Uri.https(defaultHS, '');
      }
      final client = await matrixService.getLoginClient();
      final (_, _, loginFlows, _) = await client.checkHomeserver(homeserver);

      // Check localStorage for a pending SSO token from a previous redirect.
      final pendingResult = html.window.localStorage['flutter-web-auth-2'];
      if (pendingResult != null && pendingResult.isNotEmpty) {
        html.window.localStorage.remove('flutter-web-auth-2');
        final token = Uri.parse(pendingResult).queryParameters['loginToken'];
        if (token != null && token.isNotEmpty) {
          await client.login(
            LoginType.mLoginToken,
            token: token,
            initialDeviceDisplayName: PlatformInfos.clientName,
          );
          setLoginLoading(AsyncSnapshot.withData(ConnectionState.done, true));
          return;
        }
      }

      // No pending token — verify SSO support and redirect.
      if (!loginFlows.any((flow) => flow.type == 'm.login.sso')) {
        Logs().w('[AutoSSO] Homeserver does not support SSO');
        setLoginLoading(AsyncSnapshot.withData(ConnectionState.done, false));
        return;
      }

      final redirectUrl = Uri.parse(
        html.window.location.href,
      ).resolveUri(Uri(pathSegments: ['auth.html'])).toString();
      final ssoUrl = client.homeserver!.replace(
        path: '/_matrix/client/v3/login/sso/redirect',
        queryParameters: {'redirectUrl': redirectUrl, 'action': 'login'},
      );
      html.window.location.href = ssoUrl.toString();
    } catch (e, s) {
      Logs().w('[AutoSSO] Failed', e, s);
      setLoginLoading(AsyncSnapshot.withError(ConnectionState.done, e, s));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toLocalizedString(context, ExceptionContext.checkHomeserver),
          ),
        ),
      );
    }
  }
}
