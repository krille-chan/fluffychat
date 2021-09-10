import 'package:fluffychat/widgets/layouts/one_page_card.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../signup.dart';

class SignupPageView extends StatelessWidget {
  final SignupPageController controller;
  const SignupPageView(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnePageCard(
      child: Scaffold(
        appBar: AppBar(
          title: Text(L10n.of(context).signUp),
        ),
        body: ListView(
          children: [
            ListTile(
              title: Text(L10n.of(context).pleaseChooseAUsername),
              subtitle: Text(L10n.of(context).newUsernameDescription),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                readOnly: controller.loading,
                autocorrect: false,
                autofocus: true,
                controller: controller.usernameController,
                autofillHints:
                    controller.loading ? null : [AutofillHints.username],
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_box_outlined),
                    hintText: L10n.of(context).username,
                    errorText: controller.usernameError,
                    labelText: L10n.of(context).username,
                    prefixText: '@',
                    suffixText:
                        ':${Matrix.of(context).client.homeserver.host}'),
              ),
            ),
            Divider(),
            ListTile(
              title: Text(L10n.of(context).chooseAStrongPassword),
              subtitle: Text(L10n.of(context).newPasswordDescription),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                readOnly: controller.loading,
                autocorrect: false,
                autofillHints:
                    controller.loading ? null : [AutofillHints.password],
                controller: controller.passwordController,
                obscureText: !controller.showPassword,
                onSubmitted: controller.signup,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outlined),
                  hintText: '****',
                  errorText: controller.passwordError,
                  suffixIcon: IconButton(
                    tooltip: L10n.of(context).showPassword,
                    icon: Icon(controller.showPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                    onPressed: controller.toggleShowPassword,
                  ),
                  labelText: L10n.of(context).password,
                ),
              ),
            ),
            Divider(),
            SizedBox(height: 12),
            Hero(
              tag: 'loginButton',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: ElevatedButton(
                  onPressed: controller.loading ? null : controller.signup,
                  child: controller.loading
                      ? LinearProgressIndicator()
                      : Text(L10n.of(context).signUp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
