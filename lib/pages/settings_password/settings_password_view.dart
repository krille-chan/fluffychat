import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/settings_password/settings_password.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';

class SettingsPasswordView extends StatelessWidget {
  final SettingsPasswordController controller;
  const SettingsPasswordView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).changePassword),
      ),
      body: ListTileTheme(
        iconColor: theme.colorScheme.onSurface,
        child: MaxWidthBody(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 16),
                TextField(
                  controller: controller.oldPasswordController,
                  obscureText: true,
                  autocorrect: false,
                  autofocus: true,
                  readOnly: controller.loading,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outlined),
                    hintText: '********',
                    labelText: L10n.of(context).pleaseEnterYourCurrentPassword,
                    errorText: controller.oldPasswordError,
                  ),
                ),
                const Divider(height: 64),
                TextField(
                  controller: controller.newPassword1Controller,
                  obscureText: true,
                  autocorrect: false,
                  readOnly: controller.loading,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_reset_outlined),
                    hintText: '********',
                    labelText: L10n.of(context).newPassword,
                    errorText: controller.newPassword1Error,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller.newPassword2Controller,
                  obscureText: true,
                  autocorrect: false,
                  readOnly: controller.loading,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.repeat_outlined),
                    hintText: '********',
                    labelText: L10n.of(context).repeatPassword,
                    errorText: controller.newPassword2Error,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        controller.loading ? null : controller.changePassword,
                    child: controller.loading
                        ? const LinearProgressIndicator()
                        : Text(L10n.of(context).changePassword),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  child: Text(L10n.of(context).passwordRecoverySettings),
                  onPressed: () => context.go('/rooms/settings/security/3pid'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
