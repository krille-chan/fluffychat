import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/pangea/pages/sign_up/full_width_button.dart';
import 'package:fluffychat/pangea/pages/sign_up/pangea_login_scaffold.dart';

class LoginOrSignupView extends StatelessWidget {
  const LoginOrSignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return PangeaLoginScaffold(
      children: [
        FullWidthButton(
          title: L10n.of(context).createAnAccount,
          onPressed: () => context.go('/home/signup'),
        ),
        FullWidthButton(
          title: L10n.of(context).signIn,
          onPressed: () => context.go('/home/login'),
        ),
      ],
    );
  }
}
