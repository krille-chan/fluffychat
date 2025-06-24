import 'package:fluffychat/config/app_config.dart';
import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';

class LoginView extends StatelessWidget {
  final LoginController controller;

  const LoginView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LoginScaffold(
      enforceMobileMode:
          Matrix.of(context).widget.clients.any((client) => client.isLogged()),
      appBar: null,
      body: Builder(
        builder: (context) {
          return AutofillGroup(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.height * 0.05,
                    right: MediaQuery.of(context).size.height * 0.05,
                    top: MediaQuery.of(context).size.height * 0.05,
                  ),
                  child: Text(
                    L10n.of(context).login,
                    style: GoogleFonts.righteous(
                      fontSize: 20,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.05,
                  ),
                  child: Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.5,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.2,
                          minWidth: 150,
                        ),
                        child: Image.asset(
                          'assets/logo_horizontal_semfundo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: TextField(
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Roboto',
                    ),
                    readOnly: controller.loading,
                    autocorrect: false,
                    autofocus: true,
                    onChanged: controller.checkWellKnownWithCoolDown,
                    controller: controller.usernameController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints:
                        controller.loading ? null : [AutofillHints.username],
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.account_box_outlined),
                      errorText: controller.usernameError,
                      errorStyle: const TextStyle(color: Colors.orange),
                      labelText: L10n.of(context).emailOrUsername,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: TextField(
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Roboto',
                    ),
                    readOnly: controller.loading,
                    autocorrect: false,
                    autofillHints:
                        controller.loading ? null : [AutofillHints.password],
                    controller: controller.passwordController,
                    textInputAction: TextInputAction.go,
                    obscureText: !controller.showPassword,
                    onSubmitted: (_) => controller.login(),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outlined),
                      errorText: controller.passwordError,
                      errorStyle: const TextStyle(color: Colors.orange),
                      suffixIcon: IconButton(
                        onPressed: controller.toggleShowPassword,
                        icon: Icon(
                          controller.showPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      labelText: L10n.of(context).password,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ElevatedButton(
                    onPressed: controller.loading ? null : controller.login,
                    child: controller.loading
                        ? const LinearProgressIndicator()
                        : Text(L10n.of(context).login),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: TextButton(
                    onPressed: controller.loading
                        ? () {}
                        : controller.passwordForgotten,
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                    ),
                    child: Text(L10n.of(context).passwordForgotten),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
