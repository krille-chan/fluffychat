import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:tawkie/pages/register/register.dart';
import 'package:tawkie/widgets/layouts/login_scaffold.dart';
import 'package:tawkie/widgets/matrix.dart';

class RegisterView extends StatelessWidget {
  final RegisterController controller;

  const RegisterView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return LoginScaffold(
      enforceMobileMode: Matrix.of(context).client.isLogged(),
      appBar: AppBar(
        leading: controller.loading ? null : const Center(child: BackButton()),
        automaticallyImplyLeading: !controller.loading,
        titleSpacing: !controller.loading ? 0 : null,
      ),
      body: Builder(
        builder: (context) {
          return AutofillGroup(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: <Widget>[
                Text(
                  L10n.of(context)!.registerTitle.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                !controller.loading
                    ? Column(
                        children: [
                          ...controller.authWidgets,
                        ],
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
                const SizedBox(height: 16),
                if (controller.messageError != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      controller.messageError!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: controller.loading ? null : controller.register,
                    icon: const Icon(Icons.person_add_outlined),
                    label: controller.loading
                        ? const LinearProgressIndicator()
                        : Text(L10n.of(context)!.register),
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
