import 'package:vrouter/vrouter.dart';
import 'package:fluffychat/pages/sign_up.dart';
import 'package:fluffychat/widgets/fluffy_banner.dart';

import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/layouts/one_page_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import '../../utils/localized_exception_extension.dart';

class SignUpView extends StatelessWidget {
  final SignUpController controller;

  const SignUpView(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnePageCard(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: controller.loading ? Container() : BackButton(),
          title: Text(
            Matrix.of(context)
                .client
                .homeserver
                .toString()
                .replaceFirst('https://', ''),
          ),
        ),
        body: FutureBuilder(
            future: controller.getLoginTypes(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    snapshot.error.toLocalizedString(context),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView(children: <Widget>[
                Hero(
                  tag: 'loginBanner',
                  child: FluffyBanner(),
                ),
                SizedBox(height: 16),
                if (controller.passwordLoginSupported) ...{
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: TextField(
                      readOnly: controller.loading,
                      autocorrect: false,
                      controller: controller.usernameController,
                      onSubmitted: controller.signUpAction,
                      autofillHints: controller.loading
                          ? null
                          : [AutofillHints.newUsername],
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(
                            left: 12.0,
                            right: 22,
                          ),
                          child: Icon(Icons.account_circle_outlined),
                        ),
                        hintText: L10n.of(context).username,
                        errorText: controller.usernameError,
                        labelText: L10n.of(context).chooseAUsername,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: SignUpController.avatar == null
                          ? null
                          : MemoryImage(SignUpController.avatar.bytes),
                      backgroundColor: SignUpController.avatar == null
                          ? Theme.of(context).brightness == Brightness.dark
                              ? Color(0xff121212)
                              : Colors.white
                          : Theme.of(context).secondaryHeaderColor,
                      child: SignUpController.avatar == null
                          ? Icon(Icons.camera_alt_outlined,
                              color: Theme.of(context).primaryColor)
                          : null,
                    ),
                    trailing: SignUpController.avatar == null
                        ? null
                        : Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                    title: Text(SignUpController.avatar == null
                        ? L10n.of(context).setAProfilePicture
                        : L10n.of(context).discardPicture),
                    onTap: SignUpController.avatar == null
                        ? controller.setAvatarAction
                        : controller.resetAvatarAction,
                  ),
                  SizedBox(height: 16),
                  Hero(
                    tag: 'loginButton',
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: ElevatedButton(
                        onPressed:
                            controller.loading ? null : controller.signUpAction,
                        child: controller.loading
                            ? LinearProgressIndicator()
                            : Text(L10n.of(context).signUp),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      )),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(L10n.of(context).or),
                      ),
                      Expanded(
                          child: Container(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      )),
                    ],
                  ),
                },
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Row(children: [
                    if (controller.passwordLoginSupported)
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).secondaryHeaderColor,
                            onPrimary:
                                Theme.of(context).textTheme.bodyText1.color,
                          ),
                          onPressed: () => context.vRouter.push('/login'),
                          child: Text(L10n.of(context).login),
                        ),
                      ),
                    if (controller.passwordLoginSupported &&
                        controller.ssoLoginSupported)
                      SizedBox(width: 12),
                    if (controller.ssoLoginSupported)
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).secondaryHeaderColor,
                            onPrimary:
                                Theme.of(context).textTheme.bodyText1.color,
                          ),
                          onPressed: controller.ssoLoginAction,
                          child: Text(L10n.of(context).useSSO),
                        ),
                      ),
                  ]),
                ),
              ]);
            }),
      ),
    );
  }
}
