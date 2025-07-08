import 'package:flutter/material.dart';

import 'package:matrix/matrix.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatelessWidget {
  final LoginController controller;
  final bool enforceMobileMode;
  final Client client;

  const LoginView(
    this.controller, {
    super.key,
    this.enforceMobileMode = false,
    required this.client,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isMobileMode =
        enforceMobileMode || !FluffyThemes.isColumnMode(context);

    return LoginScaffold(
      enforceMobileMode:
          Matrix.of(context).widget.clients.any((client) => client.isLogged()),
      appBar: AppBar(
        backgroundColor: isMobileMode
            ? theme.colorScheme.surface
            : theme.colorScheme.tertiary,
        toolbarHeight: isMobileMode
            ? MediaQuery.of(context).size.height * 0.15
            : MediaQuery.of(context).size.height * 0.1,
        title: Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.height * 0.025,
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
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.height * 0.025,
              top: MediaQuery.of(context).size.height * 0.05,
            ),
            child: PopupMenuButton<MoreLoginActions>(
              useRootNavigator: true,
              onSelected: controller.onMoreAction,
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: MoreLoginActions.about,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.info_outlined),
                      const SizedBox(width: 12),
                      Text(L10n.of(context).about),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          return AutofillGroup(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.03,
                  ),
                  child: Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.5,
                      child: Image.asset(
                        'assets/logo_horizontal_semfundo.png',
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                      errorStyle: TextStyle(color: theme.colorScheme.secondary),
                      labelText: L10n.of(context).emailOrUsername,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
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
                      errorStyle: TextStyle(color: theme.colorScheme.secondary),
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
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ElevatedButton(
                    onPressed: controller.loading ? null : controller.login,
                    child: controller.loading
                        ? const LinearProgressIndicator()
                        : Text(L10n.of(context).login),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${L10n.of(context).newHere} ',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 15,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          TextSpan(
                            text: L10n.of(context).createAnAccountPrompt,
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontSize: 15,
                              fontFamily: 'Roboto',
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.go('/register', extra: client);
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
