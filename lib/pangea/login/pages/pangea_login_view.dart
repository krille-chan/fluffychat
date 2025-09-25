import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/login/login.dart';

class PasswordLoginView extends StatelessWidget {
  final LoginController controller;

  const PasswordLoginView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: controller.formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            L10n.of(context).loginWithEmail,
          ),
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 300,
                maxHeight: 600,
              ),
              child: Column(
                spacing: 16.0,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AutofillGroup(
                    child: Column(
                      spacing: 16.0,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: L10n.of(context).usernameOrEmail,
                          ),
                          autofillHints: const [AutofillHints.username],
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return L10n.of(context).pleaseEnterYourUsername;
                            }
                            return null;
                          },
                          controller: controller.usernameController,
                          onTapOutside: (_) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              autofillHints: const [AutofillHints.password],
                              obscureText: !controller.showPassword,
                              textInputAction: TextInputAction.go,
                              onFieldSubmitted: (_) {
                                controller.enabledSignIn
                                    ? controller.login()
                                    : null;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return L10n.of(context)
                                      .pleaseEnterYourPassword;
                                }
                                return null;
                              },
                              controller: controller.passwordController,
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
                              ),
                              onTapOutside: (_) =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                            ),
                            TextButton(
                              onPressed: controller.loadingSignIn ||
                                      controller.client == null
                                  ? () {}
                                  : controller.passwordForgotten,
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 4.0,
                                ),
                                minimumSize: const Size(0, 0),
                              ),
                              child: Text(L10n.of(context).forgotPassword),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed:
                        controller.enabledSignIn ? controller.login : null,
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
                        Text(L10n.of(context).login),
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
