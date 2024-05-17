import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:tawkie/config/themes.dart';
import 'package:tawkie/widgets/layouts/login_scaffold.dart';
import 'package:tawkie/widgets/matrix.dart';
import 'login.dart';

class LoginView extends StatelessWidget {
  final LoginController controller;

  const LoginView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final textFieldFillColor = FluffyThemes.isColumnMode(context)
        ? Theme.of(context).colorScheme.background
        : Theme.of(context).colorScheme.surfaceVariant;

    return LoginScaffold(
      enforceMobileMode: Matrix.of(context).client.isLogged(),
      appBar: AppBar(
        automaticallyImplyLeading: !controller.loading,
        titleSpacing: !controller.loading ? 0 : null,
      ),
      body: Builder(
        builder: (context) {
          return
            AutofillGroup(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: <Widget>[
                Image.asset('assets/banner_transparent.png'),
                const SizedBox(height: 16),
                ...controller.authWidgets,
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: controller.loading ? null : controller.submitForm,
                    icon: const Icon(Icons.login_outlined),
                    label: controller.loading
                        ? const LinearProgressIndicator()
                        : Text(L10n.of(context)!.login),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextButton.icon(
                    onPressed: controller.loading
                        ? () {}
                        : () {
                            //Todo: make forgotten password function
                            //controller.passwordForgotten
                          },
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                    ),
                    icon: const Icon(Icons.safety_check_outlined),
                    label: Text(L10n.of(context)!.passwordForgotten),
                  ),
                ),
                const SizedBox(height: 16),
                // Register redirection
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextButton.icon(
                    onPressed: controller.loading
                        ? () {}
                        : () => context.go('/home/register'),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                    ),
                    icon: const Icon(Icons.app_registration),
                    label: Text(L10n.of(context)!.noAccountRegister),
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
