import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/login/login.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_ok_cancel_alert_dialog.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
import '../../../widgets/matrix.dart';

extension PangeaPasswordForgotten on LoginController {
  void pangeaPasswordForgotten() async {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    showDialog(
      context: context,
      useRootNavigator: false,
      builder: (BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: AlertDialog(
          title: Text(L10n.of(context).passwordForgotten),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(L10n.of(context).enterAnEmailAddress),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: L10n.of(context).enterAnEmailAddress,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(L10n.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
                return;
              },
            ),
            TextButton(
              child: Text(L10n.of(context).ok),
              onPressed: () async {
                if (emailController.text == "") return;
                final clientSecret =
                    DateTime.now().millisecondsSinceEpoch.toString();
                final response = await showFutureLoadingDialog(
                  context: context,
                  future: () => Matrix.of(context)
                      .getLoginClient()
                      .requestTokenToResetPasswordEmail(
                        clientSecret,
                        emailController.text,
                        LoginController.sendAttempt++,
                      ),
                );
                if (response.error != null) {
                  return;
                }
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  useRootNavigator: false,
                  builder: (BuildContext context) => Scaffold(
                    backgroundColor: Colors.transparent,
                    body: AlertDialog(
                      title: Text(L10n.of(context).passwordForgotten),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(L10n.of(context).chooseAStrongPassword),
                          const SizedBox(height: 12),
                          TextField(
                            obscureText: true,
                            controller: newPasswordController,
                            decoration: const InputDecoration(
                              hintText: "******",
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          child: Text(L10n.of(context).cancel),
                          onPressed: () {
                            Navigator.of(context).pop();
                            return;
                          },
                        ),
                        TextButton(
                          child: Text(L10n.of(context).ok),
                          onPressed: () async {
                            if (newPasswordController.text == "") return;
                            final ok = await showOkAlertDialog(
                              useRootNavigator: false,
                              context: context,
                              title: L10n.of(context).weSentYouAnEmail,
                              // #Pangea
                              // message: L10n.of(context).pleaseClickOnLink,
                              message: L10n.of(context).clickOnEmailLink,
                              // Pangea#
                              okLabel: L10n.of(context).iHaveClickedOnLink,
                            );
                            if (ok != OkCancelResult.ok) return;
                            final data = <String, dynamic>{
                              'new_password': newPasswordController.text,
                              'logout_devices': false,
                              "auth": AuthenticationThreePidCreds(
                                type: AuthenticationTypes.emailIdentity,
                                threepidCreds: ThreepidCreds(
                                  sid: response.result!.sid,
                                  clientSecret: clientSecret,
                                ),
                              ).toJson(),
                            };
                            final success = await showFutureLoadingDialog(
                              context: context,
                              future: () =>
                                  Matrix.of(context).getLoginClient().request(
                                        RequestType.POST,
                                        '/client/r0/account/password',
                                        data: data,
                                      ),
                            );
                            if (success.error == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    L10n.of(context).passwordHasBeenChanged,
                                  ),
                                ),
                              );
                              usernameController.text = emailController.text;
                              passwordController.text =
                                  newPasswordController.text;
                              login();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
