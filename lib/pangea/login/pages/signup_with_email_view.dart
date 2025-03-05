// Flutter imports:

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/common/widgets/pangea_logo_svg.dart';
import 'package:fluffychat/pangea/login/pages/pangea_login_scaffold.dart';
import 'package:fluffychat/pangea/login/widgets/full_width_button.dart';
import 'signup.dart';

class SignupWithEmailView extends StatelessWidget {
  final SignupPageController controller;
  const SignupWithEmailView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: PangeaLoginScaffold(
        children: [
          FullWidthTextField(
            hintText: L10n.of(context).yourUsername,
            textInputAction: TextInputAction.next,
            validator: (text) {
              if (text == null || text.isEmpty) {
                return L10n.of(context).pleaseChooseAUsername;
              }
              return null;
            },
            controller: controller.usernameController,
          ),
          FullWidthTextField(
            hintText: L10n.of(context).yourEmail,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            validator: controller.emailTextFieldValidator,
            controller: controller.emailController,
          ),
          FullWidthTextField(
            hintText: L10n.of(context).password,
            textInputAction: TextInputAction.done,
            obscureText: true,
            validator: controller.password1TextFieldValidator,
            controller: controller.passwordController,
            onSubmitted: controller.enableSignUp ? controller.signup : null,
          ),
          FullWidthButton(
            title: L10n.of(context).signUp,
            icon: PangeaLogoSvg(
              width: 20,
              forceColor: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: controller.enableSignUp ? controller.signup : null,
            loading: controller.loadingSignup,
            enabled: controller.enableSignUp,
          ),
        ],
      ),
    );
  }
}
