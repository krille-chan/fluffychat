import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/sign_in/view_model/flows/oidc_login.dart';
import 'package:fluffychat/pages/sign_in/view_model/flows/sso_login.dart';
import 'package:fluffychat/pages/sign_in/view_model/model/public_homeserver_data.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/matrix.dart';

void connectToHomeserverFlow(
  PublicHomeserverData homeserverData,
  BuildContext context,
  void Function(AsyncSnapshot<bool>) setState,
  bool signUp,
) async {
  setState(AsyncSnapshot.waiting());
  try {
    final homeserverInput = homeserverData.name!;
    var homeserver = Uri.parse(homeserverInput);
    if (homeserver.scheme.isEmpty) {
      homeserver = Uri.https(homeserverInput, '');
    }
    final l10n = L10n.of(context);
    final client = await Matrix.of(context).getLoginClient();
    final (_, _, loginFlows, authMetadata) = await client.checkHomeserver(
      homeserver,
      fetchAuthMetadata: true,
    );

    final regLink = homeserverData.regLink;
    final supportsSso = loginFlows.any((flow) => flow.type == 'm.login.sso');

    if ((kIsWeb || PlatformInfos.isLinux) &&
        (supportsSso || authMetadata != null || (signUp && regLink != null))) {
      final consent = await showOkCancelAlertDialog(
        context: context,
        title: l10n.appWantsToUseForLogin(homeserverInput),
        message: l10n.appWantsToUseForLoginDescription,
        okLabel: l10n.continueText,
      );
      if (consent != OkCancelResult.ok) return;
    }

    if (authMetadata != null) {
      await oidcLoginFlow(client, context, signUp);
    } else if (supportsSso) {
      await ssoLoginFlow(client, context, signUp);
    } else {
      if (signUp && regLink != null) {
        await launchUrlString(regLink);
      }
      final pathSegments = List.of(
        GoRouter.of(context).routeInformationProvider.value.uri.pathSegments,
      );
      pathSegments.removeLast();
      pathSegments.add('login');
      context.go('/${pathSegments.join('/')}', extra: client);
      setState(AsyncSnapshot.withData(ConnectionState.done, true));
      return;
    }

    if (context.mounted) {
      setState(AsyncSnapshot.withData(ConnectionState.done, true));
    }
  } catch (e, s) {
    setState(AsyncSnapshot.withError(ConnectionState.done, e, s));
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
