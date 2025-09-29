// Flutter imports:

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pangea/common/widgets/pangea_logo_svg.dart';
import 'package:fluffychat/pangea/login/widgets/p_sso_button.dart';
import 'signup.dart';

class SignupPageView extends StatelessWidget {
  final SignupPageController controller;
  const SignupPageView(this.controller, {super.key});

  bool validator() {
    return controller.formKey.currentState?.validate() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: controller.formKey,
      child: Scaffold(
        appBar: AppBar(),
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
                  Text(
                    L10n.of(context).signupOption,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PangeaSsoButton(
                    provider: SSOProvider.google,
                    setLoading: controller.setLoadingSSO,
                    loading: controller.loadingGoogleSSO,
                    validator: validator,
                  ),
                  PangeaSsoButton(
                    provider: SSOProvider.apple,
                    setLoading: controller.setLoadingSSO,
                    loading: controller.loadingAppleSSO,
                    validator: validator,
                  ),
                  ElevatedButton(
                    onPressed: () => context.go(
                      '/home/signup/${controller.widget.langCode}/email',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.surface,
                      foregroundColor: theme.colorScheme.onSurface,
                      side: BorderSide(
                        width: 1,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    child: Row(
                      spacing: 8.0,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PangeaLogoSvg(
                          width: 20,
                          forceColor: Theme.of(context).colorScheme.onSurface,
                        ),
                        Text(L10n.of(context).withEmail),
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
                            text: L10n.of(context)
                                .andCertifyIAmAtLeast13YearsOfAge,
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
      ),
    );
  }
}
