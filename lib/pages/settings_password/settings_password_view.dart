import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/pages/settings_password/settings_password.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';

class SettingsPasswordView extends StatelessWidget {
  final SettingsPasswordController controller;
  const SettingsPasswordView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context)!.changePassword),
        actions: [
          TextButton(
            child: Text(L10n.of(context)!.passwordRecoverySettings),
            onPressed: () => context.go('/rooms/settings/security/3pid'),
          ),
        ],
      ),
      body: ListTileTheme(
        iconColor: Theme.of(context).colorScheme.onSurface,
        child: MaxWidthBody(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Center(
                  child: Icon(
                    Icons.key_outlined,
                    color: Theme.of(context).dividerColor,
                    size: 80,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller.oldPasswordController,
                  obscureText: true,
                  autocorrect: false,
                  autofocus: true,
                  readOnly: controller.loading,
                  decoration: InputDecoration(
                    hintText: L10n.of(context)!.pleaseEnterYourCurrentPassword,
                    errorText: controller.oldPasswordError,
                  ),
                ),
                const Divider(height: 32),
                TextField(
                  controller: controller.newPassword1Controller,
                  obscureText: true,
                  autocorrect: false,
                  readOnly: controller.loading,
                  decoration: InputDecoration(
                    hintText: L10n.of(context)!.newPassword,
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
                    hintText: L10n.of(context)!.repeatPassword,
                    errorText: controller.newPassword2Error,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed:
                        controller.loading ? null : controller.changePassword,
                    icon: const Icon(Icons.send_outlined),
                    label: controller.loading
                        ? const LinearProgressIndicator()
                        : Text(L10n.of(context)!.changePassword),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
