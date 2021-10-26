import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:url_launcher/url_launcher.dart';

class UiaRequestManager {
  final Client client;
  final L10n l10n;
  final BuildContext navigatorContext;
  final String cachedPassword;

  UiaRequestManager(this.client, this.l10n, this.navigatorContext,
      [this.cachedPassword]);

  Future onUiaRequest(UiaRequest uiaRequest) async {
    try {
      if (uiaRequest.state != UiaRequestState.waitForUser ||
          uiaRequest.nextStages.isEmpty) return;
      final stage = uiaRequest.nextStages.first;
      switch (stage) {
        case AuthenticationTypes.password:
          final input = cachedPassword ??
              (await showTextInputDialog(
                useRootNavigator: false,
                context: navigatorContext,
                title: l10n.pleaseEnterYourPassword,
                okLabel: l10n.ok,
                cancelLabel: l10n.cancel,
                textFields: [
                  const DialogTextField(
                    minLines: 1,
                    maxLines: 1,
                    obscureText: true,
                    hintText: '******',
                  )
                ],
              ))
                  ?.single;
          if (input?.isEmpty ?? true) return;
          return uiaRequest.completeStage(
            AuthenticationPassword(
              session: uiaRequest.session,
              password: input,
              identifier: AuthenticationUserIdentifier(user: client.userID),
            ),
          );
        case AuthenticationTypes.emailIdentity:
          final emailInput = await showTextInputDialog(
            context: navigatorContext,
            message: l10n.serverRequiresEmail,
            okLabel: l10n.next,
            cancelLabel: l10n.cancel,
            textFields: [
              DialogTextField(
                hintText: l10n.addEmail,
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          );
          if (emailInput == null || emailInput.isEmpty) {
            return uiaRequest.cancel(Exception(l10n.serverRequiresEmail));
          }
          final clientSecret = DateTime.now().millisecondsSinceEpoch.toString();
          final currentThreepidCreds = await client.requestTokenToRegisterEmail(
            clientSecret,
            emailInput.single,
            0,
          );
          final auth = AuthenticationThreePidCreds(
            session: uiaRequest.session,
            type: AuthenticationTypes.emailIdentity,
            threepidCreds: [
              ThreepidCreds(
                sid: currentThreepidCreds.sid,
                clientSecret: clientSecret,
              ),
            ],
          );
          if (OkCancelResult.ok ==
              await showOkCancelAlertDialog(
                useRootNavigator: false,
                context: navigatorContext,
                title: l10n.weSentYouAnEmail,
                message: l10n.pleaseClickOnLink,
                okLabel: l10n.iHaveClickedOnLink,
                cancelLabel: l10n.cancel,
              )) {
            return uiaRequest.completeStage(auth);
          }
          return uiaRequest.cancel();
        case AuthenticationTypes.dummy:
          return uiaRequest.completeStage(
            AuthenticationData(
              type: AuthenticationTypes.dummy,
              session: uiaRequest.session,
            ),
          );
        default:
          await launch(
            client.homeserver.toString() +
                '/_matrix/client/r0/auth/$stage/fallback/web?session=${uiaRequest.session}',
          );
          if (OkCancelResult.ok ==
              await showOkCancelAlertDialog(
                useRootNavigator: false,
                message: l10n.pleaseFollowInstructionsOnWeb,
                context: navigatorContext,
                okLabel: l10n.next,
                cancelLabel: l10n.cancel,
              )) {
            return uiaRequest.completeStage(
              AuthenticationData(session: uiaRequest.session),
            );
          } else {
            return uiaRequest.cancel();
          }
      }
    } catch (e, s) {
      Logs().e('Error while background UIA', e, s);
      return uiaRequest.cancel(e is Exception ? e : Exception(e));
    }
  }
}
