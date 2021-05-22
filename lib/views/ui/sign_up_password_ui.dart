import 'package:fluffychat/views/sign_up_password.dart';

import 'package:fluffychat/widgets/layouts/one_page_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class SignUpPasswordUI extends StatelessWidget {
  final SignUpPasswordController controller;

  const SignUpPasswordUI(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnePageCard(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: controller.loading ? Container() : BackButton(),
          title: Text(
            L10n.of(context).chooseAStrongPassword,
          ),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: controller.passwordController,
                obscureText: !controller.showPassword,
                autofocus: true,
                readOnly: controller.loading,
                autocorrect: false,
                onSubmitted: (_) => controller.signUpAction,
                autofillHints:
                    controller.loading ? null : [AutofillHints.newPassword],
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
                    labelText: L10n.of(context).password),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: controller.emailController,
                readOnly: controller.loading,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                onSubmitted: (_) => controller.signUpAction,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail_outline_outlined),
                    errorText: controller.emailError,
                    hintText: 'email@example.com',
                    labelText: L10n.of(context).optionalAddEmail),
              ),
            ),
            SizedBox(height: 12),
            Hero(
              tag: 'loginButton',
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: ElevatedButton(
                  onPressed:
                      controller.loading ? null : controller.signUpAction,
                  child: controller.loading
                      ? LinearProgressIndicator()
                      : Text(
                          L10n.of(context).createAccountNow.toUpperCase(),
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
