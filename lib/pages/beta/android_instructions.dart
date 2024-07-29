import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:tawkie/config/app_config.dart';
import 'package:tawkie/pages/beta/instructions.dart';

class AndroidInstructions extends BetaInstructions {
  const AndroidInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L10n.of(context)!.androidInstructionsTitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          L10n.of(context)!.joinBetaPlayStore,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10.0),
        ElevatedButton(
          onPressed: () async {
            final bool success = await openUrl(AppConfig.playStoreUrl, context);
            if (!success) {
              await openUrl(AppConfig.androidBetaUrl, context);
            }
          },
          child: Text(L10n.of(context)!.downloadBetaAndroidButton),
        ),
      ],
    );
  }
}
