import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';

class MissingVoiceButton extends StatelessWidget {
  final String targetLangCode;

  const MissingVoiceButton({
    required this.targetLangCode,
    super.key,
  });

  void launchTTSSettings(BuildContext context) {
    if (Platform.isAndroid) {
      const intent = AndroidIntent(
        action: 'com.android.settings.TTS_SETTINGS',
        package: 'com.talktolearn.chat',
      );

      showFutureLoadingDialog(
        context: context,
        future: intent.launch,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.1),
        borderRadius: const BorderRadius.all(
          Radius.circular(AppConfig.borderRadius),
        ),
      ),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 8),
      child: SizedBox(
        width: AppConfig.toolbarMinWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              L10n.of(context)!.voiceNotAvailable,
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () => launchTTSSettings,
              // commenting out as suspecting this is causing an issue
              // #freeze-activity
              style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(L10n.of(context)!.openVoiceSettings),
            ),
          ],
        ),
      ),
    );
  }
}
