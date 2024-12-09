// Flutter imports:

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/pages/sign_up/signup.dart';
import 'package:fluffychat/utils/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class TosCheckbox extends StatelessWidget {
  final SignupPageController controller;
  const TosCheckbox(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          value: controller.isTnCChecked,
          activeColor: Theme.of(context).colorScheme.primary,
          onChanged: controller.onTncChange,
          title: InkWell(
            onTap: () =>
                UrlLauncher(context, AppConfig.termsOfServiceUrl).launchUrl(),
            child: RichText(
              maxLines: 2,
              text: TextSpan(
                text: L10n.of(context).iAgreeToThe,
                children: [
                  //PTODO - make sure this is actually a link
                  TextSpan(
                    text: L10n.of(context).termsAndConditions,
                    style: const TextStyle(color: Colors.blue),
                  ),
                  TextSpan(
                    text: L10n.of(context).andCertifyIAmAtLeast13YearsOfAge,
                  ),
                ],
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            margin: const EdgeInsets.only(top: 5),
            child: Text(
              controller.signupError ?? '',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
