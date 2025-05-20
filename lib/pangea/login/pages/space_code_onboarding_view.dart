import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pangea/login/pages/pangea_login_scaffold.dart';
import 'package:fluffychat/pangea/login/pages/space_code_onboarding.dart';
import 'package:fluffychat/pangea/login/widgets/full_width_button.dart';
import 'package:fluffychat/pangea/user/utils/p_logout.dart';

class SpaceCodeOnboardingView extends StatelessWidget {
  final SpaceCodeOnboardingState controller;
  const SpaceCodeOnboardingView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return PangeaLoginScaffold(
      customAppBar: AppBar(
        leading: BackButton(
          onPressed: () => pLogoutAction(
            context,
            bypassWarning: true,
          ),
        ),
      ),
      showAppName: false,
      mainAssetUrl: controller.profile?.avatarUrl,
      children: [
        Text(
          L10n.of(context).welcomeUser(
            controller.profile?.displayName ??
                controller.client.userID?.localpart ??
                "",
          ),
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Text(
          L10n.of(context).joinSpaceOnboardingDesc,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8.0),
        FullWidthTextField(
          hintText: L10n.of(context).enterCodeToJoin,
          controller: controller.codeController,
          onSubmitted: (_) => controller.submitCode,
        ),
        FullWidthButton(
          title: L10n.of(context).join,
          onPressed: controller.submitCode,
          enabled: controller.codeController.text.isNotEmpty,
        ),
        const SizedBox(height: 8.0),
        TextButton(
          child: Text(L10n.of(context).skipForNow),
          onPressed: () => context.go("/rooms"),
        ),
      ],
    );
  }
}
