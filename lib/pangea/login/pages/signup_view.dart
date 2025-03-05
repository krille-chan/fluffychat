// Flutter imports:

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/pangea/common/widgets/pangea_logo_svg.dart';
import 'package:fluffychat/pangea/login/pages/pangea_login_scaffold.dart';
import 'package:fluffychat/pangea/login/widgets/full_width_button.dart';
import 'package:fluffychat/pangea/login/widgets/p_sso_button.dart';
import 'package:fluffychat/pangea/login/widgets/tos_checkbox.dart';
import 'signup.dart';

class SignupPageView extends StatelessWidget {
  final SignupPageController controller;
  const SignupPageView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    bool validator() {
      final valid = controller.formKey.currentState?.validate() ?? false;
      if (!valid) return false;
      if (!controller.isTnCChecked) {
        controller.setSignupError(L10n.of(context).pleaseAgreeToTOS);
        return false;
      }
      return true;
    }

    return Form(
      key: controller.formKey,
      child: PangeaLoginScaffold(
        children: [
          TosCheckbox(
            controller.isTnCChecked,
            controller.onTncChange,
            error: controller.signupError,
          ),
          FullWidthButton(
            title: L10n.of(context).signUpWithEmail,
            onPressed: () {
              if (!validator()) return;
              context.go(
                '/home/signup/email',
              );
            },
            icon: PangeaLogoSvg(
              width: 20,
              forceColor: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          PangeaSsoButton(
            provider: SSOProvider.google,
            title: L10n.of(context).signUpWithGoogle,
            setLoading: controller.setLoadingSSO,
            loading: controller.loadingGoogleSSO,
            validator: validator,
          ),
          PangeaSsoButton(
            provider: SSOProvider.apple,
            title: L10n.of(context).signUpWithApple,
            setLoading: controller.setLoadingSSO,
            loading: controller.loadingAppleSSO,
            validator: validator,
          ),
        ],
      ),
    );
  }
}
