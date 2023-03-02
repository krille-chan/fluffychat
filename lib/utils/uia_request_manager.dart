import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:fluffychat/widgets/matrix.dart';

extension UiaRequestManager on MatrixState {
  Future uiaRequestHandler(UiaRequest uiaRequest) async {
    final l10n = L10n.of(navigatorContext)!;
    try {
      if (uiaRequest.state != UiaRequestState.waitForUser ||
          uiaRequest.nextStages.isEmpty) {
        Logs().d('Uia Request Stage: ${uiaRequest.state}');
        return;
      }
      final stage = uiaRequest.nextStages.first;
      Logs().d('Uia Request Stage: $stage');
      switch (stage) {
        case AuthenticationTypes.password:
          final input = cachedPassword ??
              (await showTextInputDialog(
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
          if (input == null || input.isEmpty) {
            return uiaRequest.cancel();
          }
          return uiaRequest.completeStage(
            AuthenticationPassword(
              session: uiaRequest.session,
              password: input,
              identifier: AuthenticationUserIdentifier(user: client.userID!),
            ),
          );
        case AuthenticationTypes.emailIdentity:
          final currentThreepidCreds = this.currentThreepidCreds;
          if (currentThreepidCreds == null) {
            return uiaRequest.cancel(
              UiaException(L10n.of(widget.context)!.serverRequiresEmail),
            );
          }
          final auth = AuthenticationThreePidCreds(
            session: uiaRequest.session,
            type: AuthenticationTypes.emailIdentity,
            threepidCreds: ThreepidCreds(
              sid: currentThreepidCreds.sid,
              clientSecret: currentClientSecret,
            ),
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
          final url = Uri.parse(
            '${client.homeserver}/_matrix/client/r0/auth/$stage/fallback/web?session=${uiaRequest.session}',
          );
          launchUrlString(url.toString());
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

class UiaException implements Exception {
  final String reason;

  UiaException(this.reason);

  @override
  String toString() => reason;
}
