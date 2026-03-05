import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/onboarding/space_code_onboarding.dart';
import 'package:fluffychat/pangea/common/widgets/pangea_logo_svg.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';

class SpaceCodeOnboardingView extends StatelessWidget {
  final SpaceCodeOnboardingState controller;
  const SpaceCodeOnboardingView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BackButton(onPressed: Navigator.of(context).pop),
              const SizedBox(width: 40.0),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: MaxWidthBody(
          maxWidth: 300,
          withScrolling: false,
          showBorder: false,
          child: Container(
            alignment: .center,
            padding: const EdgeInsets.symmetric(
              vertical: 24.0,
              horizontal: 16.0,
            ),
            child: Column(
              spacing: 32.0,
              mainAxisSize: .min,
              children: [
                PangeaLogoSvg(width: 72),
                Column(
                  spacing: 12.0,
                  mainAxisSize: .min,
                  children: [
                    Text(
                      L10n.of(context).joinSpaceOnboardingDesc,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: .center,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: L10n.of(context).enterCodeToJoin,
                      ),
                      controller: controller.codeController,
                      onSubmitted: (_) => controller.submitCode(),
                    ),
                    ElevatedButton(
                      onPressed: controller.codeController.text.isNotEmpty
                          ? controller.submitCode
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        foregroundColor: theme.colorScheme.onPrimaryContainer,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text(L10n.of(context).join)],
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => context.go("/rooms"),
                  child: Text(L10n.of(context).skipForNow),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
