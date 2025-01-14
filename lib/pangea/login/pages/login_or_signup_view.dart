import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';

import 'package:fluffychat/pangea/login/pages/pangea_login_scaffold.dart';
import 'package:fluffychat/pangea/login/widgets/full_width_button.dart';

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
