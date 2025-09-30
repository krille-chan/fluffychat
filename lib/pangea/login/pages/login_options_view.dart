import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/login/login.dart';
import 'package:fluffychat/pangea/common/widgets/pangea_logo_svg.dart';
import 'package:fluffychat/pangea/login/widgets/p_sso_button.dart';

class LoginOptionsView extends StatelessWidget {
  final LoginController controller;

  const LoginOptionsView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          L10n.of(context).loginToAccount,
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
                PangeaSsoButton(
                  provider: SSOProvider.apple,
                  title: "Apple",
                  loading: controller.loadingAppleSSO,
                  setLoading: controller.setLoadingSSO,
                ),
                PangeaSsoButton(
                  provider: SSOProvider.google,
                  title: "Google",
                  loading: controller.loadingGoogleSSO,
                  setLoading: controller.setLoadingSSO,
                ),
                ElevatedButton(
                  onPressed: () => context.go('/home/login/email'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    foregroundColor: theme.colorScheme.onPrimaryContainer,
                  ),
                  child: Row(
                    spacing: 8.0,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PangeaLogoSvg(
                        width: 20,
                        forceColor:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      Text(L10n.of(context).email),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text: L10n.of(context).byUsingPangeaChat,
                      children: [
                        TextSpan(
                          text: L10n.of(context).termsAndConditions,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: theme.colorScheme.primary,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrlString(AppConfig.termsOfServiceUrl);
                            },
                        ),
                        TextSpan(
                          text:
                              L10n.of(context).andCertifyIAmAtLeast13YearsOfAge,
                        ),
                      ],
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
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
