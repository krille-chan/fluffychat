import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:tawkie/widgets/layouts/login_scaffold.dart';
import 'package:tawkie/widgets/matrix.dart';

import 'login.dart';

class LoginView extends StatelessWidget {
  final LoginController controller;

  const LoginView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return
      LoginScaffold(
        enforceMobileMode: Matrix.of(context).client.isLogged(),
        appBar: AppBar(
          automaticallyImplyLeading: !controller.loading,
          titleSpacing: !controller.loading ? 0 : null,
          leading: controller.canPop
              ? IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              controller.popFormWidgets();
            },
          )
              : null,
        ),
        body: Builder(
          builder: (context) {
            return AutofillGroup(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: <Widget>[
                  Image.asset('assets/banner_transparent.png'),
                  const SizedBox(height: 16),
                  !controller.loading
                      ?Column(
                    children: [
                      if (controller.messageError != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            controller.messageError!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ...controller.authWidgets,
                    ],
                  ):const Center(
                    child: CircularProgressIndicator(),
                  ),
                  const SizedBox(height: 16), // Register redirection
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
