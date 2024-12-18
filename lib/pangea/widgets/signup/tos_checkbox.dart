// Flutter imports:

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/pangea/pages/sign_up/signup.dart';
import 'package:fluffychat/utils/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class TosCheckbox extends StatefulWidget {
  final SignupPageController controller;

  const TosCheckbox(
    this.controller, {
    super.key,
  });

  @override
  TosCheckboxState createState() => TosCheckboxState();
}

class TosCheckboxState extends State<TosCheckbox>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => UrlLauncher(context, AppConfig.termsOfServiceUrl)
                      .launchUrl(),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: RichText(
                      text: TextSpan(
                        text: L10n.of(context).iAgreeToThe,
                        children: [
                          TextSpan(
                            text: L10n.of(context).termsAndConditions,
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: FluffyThemes.animationDuration,
                  child: widget.controller.signupError == null
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(top: 4, left: 30),
                          child: Text(
                            widget.controller.signupError!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
          Checkbox(
            value: widget.controller.isTnCChecked,
            activeColor: Theme.of(context).colorScheme.primary,
            onChanged: widget.controller.onTncChange,
          ),
        ],
      ),
    );
  }
}
