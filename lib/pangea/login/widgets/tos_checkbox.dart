// Flutter imports:

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/utils/url_launcher.dart';

class TosCheckbox extends StatefulWidget {
  final bool value;
  final Function(bool?) onChange;
  final String? error;

  const TosCheckbox(
    this.value,
    this.onChange, {
    this.error,
    super.key,
  });

  @override
  TosCheckboxState createState() => TosCheckboxState();
}

class TosCheckboxState extends State<TosCheckbox>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Row(
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
                  padding: const EdgeInsets.fromLTRB(15, 8, 0, 8),
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
                        TextSpan(
                          text:
                              L10n.of(context).andCertifyIAmAtLeast13YearsOfAge,
                        ),
                      ],
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedSize(
                duration: FluffyThemes.animationDuration,
                child: widget.error == null
                    ? const SizedBox.shrink()
                    : Padding(
                        padding:
                            const EdgeInsets.only(top: 4, left: 15, bottom: 8),
                        child: Text(
                          widget.error!,
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
          value: widget.value,
          activeColor: Theme.of(context).colorScheme.primary,
          onChanged: widget.onChange,
        ),
      ],
    );
  }
}
