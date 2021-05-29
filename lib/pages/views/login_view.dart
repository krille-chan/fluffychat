import 'package:fluffychat/widgets/layouts/one_page_card.dart';
import 'package:fluffychat/widgets/matrix.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import '../login.dart';

class LoginView extends StatelessWidget {
  final LoginController controller;

  const LoginView(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnePageCard(
      child: Scaffold(
        appBar: AppBar(
          leading: controller.loading ? Container() : BackButton(),
          elevation: 0,
          title: Text(
            L10n.of(context).logInTo(Matrix.of(context)
                .client
                .homeserver
                .toString()
                .replaceFirst('https://', '')),
          ),
        ),
        body: Builder(builder: (context) {
          return ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  readOnly: controller.loading,
                  autocorrect: false,
                  autofocus: true,
                  onChanged: controller.checkWellKnownWithCoolDown,
                  controller: controller.usernameController,
                  autofillHints:
                      controller.loading ? null : [AutofillHints.username],
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.account_box_outlined),
                      hintText:
                          '@${L10n.of(context).username.toLowerCase()}:domain',
                      errorText: controller.usernameError,
                      labelText: L10n.of(context).username),
                ),
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
                  onSubmitted: controller.login,
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
              SizedBox(height: 12),
              Hero(
                tag: 'loginButton',
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: ElevatedButton(
                    onPressed: controller.loading
                        ? null
                        : () => controller.login(context),
                    child: controller.loading
                        ? LinearProgressIndicator()
                        : Text(
                            L10n.of(context).login,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: controller.passwordForgotten,
                  child: Text(
                    L10n.of(context).passwordForgotten,
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
