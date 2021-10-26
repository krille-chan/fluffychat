import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:matrix/matrix.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class UiaRequestManager {
  final MatrixState matrix;
  final String cachedPassword;

  UiaRequestManager(this.matrix, [this.cachedPassword]);

  Future onUiaRequest(UiaRequest uiaRequest) async {
    try {
      if (uiaRequest.state != UiaRequestState.waitForUser ||
          uiaRequest.nextStages.isEmpty) return;
      final stage = uiaRequest.nextStages.first;
      switch (stage) {
        case AuthenticationTypes.password:
          final input = cachedPassword ??
              (await showTextInputDialog(
                context: matrix.navigatorContext,
                title: L10n.of(matrix.context).pleaseEnterYourPassword,
                okLabel: L10n.of(matrix.context).ok,
                cancelLabel: L10n.of(matrix.context).cancel,
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
              identifier:
                  AuthenticationUserIdentifier(user: matrix.client.userID),
            ),
          );
        case AuthenticationTypes.emailIdentity:
          final emailInput = await showTextInputDialog(
            context: matrix.navigatorContext,
            message: L10n.of(matrix.context).serverRequiresEmail,
            okLabel: L10n.of(matrix.context).next,
            cancelLabel: L10n.of(matrix.context).cancel,
            textFields: [
              DialogTextField(
                hintText: L10n.of(matrix.context).addEmail,
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          );
          if (emailInput == null || emailInput.isEmpty) {
            return uiaRequest
                .cancel(Exception(L10n.of(matrix.context).serverRequiresEmail));
          }
          final clientSecret = DateTime.now().millisecondsSinceEpoch.toString();
          final currentThreepidCreds =
              await matrix.client.requestTokenToRegisterEmail(
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
                context: matrix.navigatorContext,
                title: L10n.of(matrix.context).weSentYouAnEmail,
                message: L10n.of(matrix.context).pleaseClickOnLink,
                okLabel: L10n.of(matrix.context).iHaveClickedOnLink,
                cancelLabel: L10n.of(matrix.context).cancel,
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
            matrix.client.homeserver.toString() +
                '/_matrix/client/r0/auth/$stage/fallback/web?session=${uiaRequest.session}',
          );
          if (OkCancelResult.ok ==
              await showOkCancelAlertDialog(
                useRootNavigator: false,
                message: L10n.of(matrix.context).pleaseFollowInstructionsOnWeb,
                context: matrix.navigatorContext,
                okLabel: L10n.of(matrix.context).next,
                cancelLabel: L10n.of(matrix.context).cancel,
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
