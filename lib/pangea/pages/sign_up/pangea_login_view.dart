import 'package:fluffychat/pages/login/login.dart';
import 'package:fluffychat/pangea/pages/connect/p_sso_button.dart';
import 'package:fluffychat/pangea/pages/sign_up/full_width_button.dart';
import 'package:fluffychat/pangea/pages/sign_up/pangea_login_scaffold.dart';
import 'package:fluffychat/pangea/widgets/common/pangea_logo_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class PangeaLoginView extends StatelessWidget {
  final LoginController controller;

  const PangeaLoginView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: PangeaLoginScaffold(
        children: [
          FullWidthTextField(
            hintText: L10n.of(context).username,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return L10n.of(context).pleaseEnterYourUsername;
              }
              return null;
            },
            controller: controller.usernameController,
            errorText: controller.usernameError,
          ),
          FullWidthTextField(
            hintText: L10n.of(context).password,
            obscureText: true,
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return L10n.of(context).pleaseEnterYourPassword;
              }
              return null;
            },
            controller: controller.passwordController,
            errorText: controller.passwordError,
          ),
          FullWidthButton(
            title: L10n.of(context).signIn,
            icon: PangeaLogoSvg(
              width: 20,
              forceColor: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: controller.enabledSignIn ? controller.login : null,
            loading: controller.loading,
            enabled: controller.enabledSignIn,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(L10n.of(context).or),
                ),
                const Expanded(child: Divider()),
              ],
            ),
          ),
          PangeaSsoButton(
            provider: SSOProvider.google,
            title: L10n.of(context).signInWithGoogle,
          ),
          PangeaSsoButton(
            provider: SSOProvider.apple,
            title: L10n.of(context).signInWithApple,
          ),
        ],
      ),
    );
  }
}
