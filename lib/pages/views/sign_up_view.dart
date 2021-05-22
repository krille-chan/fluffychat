import 'package:adaptive_page_layout/adaptive_page_layout.dart';
import 'package:fluffychat/pages/sign_up.dart';
import 'package:fluffychat/widgets/fluffy_banner.dart';

import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/layouts/one_page_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

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
        body: ListView(children: <Widget>[
          Hero(
            tag: 'loginBanner',
            child: FluffyBanner(),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextField(
              readOnly: controller.loading,
              autocorrect: false,
              controller: controller.usernameController,
              onSubmitted: controller.signUpAction,
              autofillHints:
                  controller.loading ? null : [AutofillHints.newUsername],
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.account_circle_outlined),
                hintText: L10n.of(context).username,
                errorText: controller.usernameError,
                labelText: L10n.of(context).chooseAUsername,
              ),
            ),
          ),
          SizedBox(height: 8),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: controller.avatar == null
                  ? null
                  : MemoryImage(controller.avatar.bytes),
              backgroundColor: controller.avatar == null
                  ? Theme.of(context).brightness == Brightness.dark
                      ? Color(0xff121212)
                      : Colors.white
                  : Theme.of(context).secondaryHeaderColor,
              child: controller.avatar == null
                  ? Icon(Icons.camera_alt_outlined,
                      color: Theme.of(context).primaryColor)
                  : null,
            ),
            trailing: controller.avatar == null
                ? null
                : Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
            title: Text(controller.avatar == null
                ? L10n.of(context).setAProfilePicture
                : L10n.of(context).discardPicture),
            onTap: controller.avatar == null
                ? controller.setAvatarAction
                : controller.resetAvatarAction,
          ),
          SizedBox(height: 16),
          Hero(
            tag: 'loginButton',
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: ElevatedButton(
                onPressed: controller.loading ? null : controller.signUpAction,
                child: controller.loading
                    ? LinearProgressIndicator()
                    : Text(
                        L10n.of(context).signUp.toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () =>
                  AdaptivePageLayout.of(context).pushNamed('/login'),
              child: Text(
                L10n.of(context).alreadyHaveAnAccount,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
