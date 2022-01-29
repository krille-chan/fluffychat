import 'dart:async';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:matrix/matrix.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/matrix.dart';

extension UiaRequestManager on MatrixState {
  Future uiaRequestHandler(UiaRequest uiaRequest) async {
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
                title: L10n.of(context)!.pleaseEnterYourPassword,
                okLabel: L10n.of(context)!.ok,
                cancelLabel: L10n.of(context)!.cancel,
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
                title: L10n.of(context)!.weSentYouAnEmail,
                message: L10n.of(context)!.pleaseClickOnLink,
                okLabel: L10n.of(context)!.iHaveClickedOnLink,
                cancelLabel: L10n.of(context)!.cancel,
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
          final url = Uri.parse(client.homeserver.toString() +
              '/_matrix/client/r0/auth/$stage/fallback/web?session=${uiaRequest.session}');
          if (PlatformInfos.isMobile) {
            final browser = UiaFallbackBrowser();
            browser.addMenuItem(
              ChromeSafariBrowserMenuItem(
                action: (_, __) {
                  uiaRequest.cancel();
                },
                label: L10n.of(context)!.cancel,
                id: 0,
              ),
            );
            await browser.open(url: url);
            await browser.whenClosed.stream.first;
          } else {
            launch(url.toString());
            if (OkCancelResult.ok ==
                await showOkCancelAlertDialog(
                  useRootNavigator: false,
                  message: L10n.of(context)!.pleaseFollowInstructionsOnWeb,
                  context: navigatorContext,
                  okLabel: L10n.of(context)!.next,
                  cancelLabel: L10n.of(context)!.cancel,
                )) {
              return uiaRequest.completeStage(
                AuthenticationData(session: uiaRequest.session),
              );
            } else {
              return uiaRequest.cancel();
            }
          }
          await uiaRequest.completeStage(
            AuthenticationData(session: uiaRequest.session),
          );
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

class UiaFallbackBrowser extends ChromeSafariBrowser {
  final StreamController<bool> whenClosed = StreamController<bool>.broadcast();

  @override
  onClosed() => whenClosed.add(true);
}
