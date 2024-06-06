import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tawkie/config/app_config.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

class PrivacyPolicyText extends StatelessWidget {
  const PrivacyPolicyText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: L10n.of(context)!.privacyText,
        style: const TextStyle(fontSize: 10, color: Colors.grey),
        children: [
          TextSpan(
            text: L10n.of(context)!.privacyTextPrivacy,
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => launchUrlString(AppConfig.privacyUrl),
          ),
          const TextSpan(
            text: '.',
          ),
        ],
      ),
    );
  }
}
