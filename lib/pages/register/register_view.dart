import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:tawkie/config/themes.dart';
import 'package:tawkie/pages/register/register.dart';
import 'package:tawkie/widgets/layouts/login_scaffold.dart';
import 'package:tawkie/widgets/matrix.dart';

class RegisterView extends StatelessWidget {
  final RegisterController controller;

  const RegisterView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final textFieldFillColor = FluffyThemes.isColumnMode(context)
        ? Theme.of(context).colorScheme.background
        : Theme.of(context).colorScheme.surfaceVariant;

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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    readOnly: controller.loading,
                    autocorrect: false,
                    autofocus: true,
                    controller: controller.emailController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints:
                        controller.loading ? null : [AutofillHints.email],
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email_outlined),
                      errorText: controller.emailError,
                      errorStyle: const TextStyle(color: Colors.orange),
                      fillColor: textFieldFillColor,
                      hintText: L10n.of(context)!.email,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    readOnly: controller.loading,
                    autocorrect: false,
                    autofillHints:
                        controller.loading ? null : [AutofillHints.newPassword],
                    controller: controller.passwordController,
                    textInputAction: TextInputAction.next,
                    obscureText: !controller.showPassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outlined),
                      errorText: controller.passwordError,
                      errorStyle: const TextStyle(color: Colors.orange),
                      errorMaxLines: 3,
                      fillColor: textFieldFillColor,
                      hintText: L10n.of(context)!.password,
                      suffixIcon: IconButton(
                        onPressed: controller.toggleShowPassword,
                        icon: Icon(
                          controller.showPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    readOnly: controller.loading,
                    autocorrect: false,
                    autofillHints:
                        controller.loading ? null : [AutofillHints.newPassword],
                    controller: controller.confirmPasswordController,
                    textInputAction: TextInputAction.done,
                    obscureText: !controller.showConfirmPassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outlined),
                      errorText: controller.confirmPasswordError,
                      errorStyle: const TextStyle(color: Colors.orange),
                      errorMaxLines: 3,
                      fillColor: textFieldFillColor,
                      hintText: L10n.of(context)!.registerConfirmPassword,
                      suffixIcon: IconButton(
                        onPressed: controller.toggleShowConfirmPassword,
                        icon: Icon(
                          controller.showConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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