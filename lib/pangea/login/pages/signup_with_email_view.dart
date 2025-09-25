// Flutter imports:

import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'signup.dart';

class SignupWithEmailView extends StatelessWidget {
  final SignupPageController controller;
  const SignupWithEmailView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: controller.formKey,
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 300,
                maxHeight: 600,
              ),
              child: Column(
                spacing: 24.0,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: L10n.of(context).yourUsername,
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return L10n.of(context).pleaseChooseAUsername;
                      }
                      return null;
                    },
                    controller: controller.usernameController,
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    validator: controller.emailTextFieldValidator,
                    controller: controller.emailController,
                    decoration: InputDecoration(
                      hintText: L10n.of(context).yourEmail,
                    ),
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    obscureText: !controller.showPassword,
                    validator: controller.password1TextFieldValidator,
                    controller: controller.passwordController,
                    onFieldSubmitted:
                        controller.enableSignUp ? controller.signup : null,
                    decoration: InputDecoration(
                      hintText: L10n.of(context).password,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.showPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: controller.toggleShowPassword,
                      ),
                      isDense: true,
                    ),
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                  ),
                  ElevatedButton(
                    onPressed:
                        controller.enableSignUp ? controller.signup : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.surface,
                      foregroundColor: theme.colorScheme.onSurface,
                      side: BorderSide(
                        width: 1,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(L10n.of(context).createAccount),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
