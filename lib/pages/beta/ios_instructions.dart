import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:tawkie/config/app_config.dart';
import 'package:tawkie/pages/beta/instructions.dart';

class IOSInstructions extends BetaInstructions {
  const IOSInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L10n.of(context)!.iosInstructionsTitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          L10n.of(context)!.installTestflight,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10.0),
        ElevatedButton(
          onPressed: () async {
            await openUrl(AppConfig.testflightAppUrl, context);
          },
          child: Text(L10n.of(context)!.downloadTestflightButton),
        ),
        const Divider(thickness: 1),
        Text(
          L10n.of(context)!.joinBetaTitle,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10.0),
        ElevatedButton(
          onPressed: () async {
            await openUrl(AppConfig.appleBetaUrl, context);
          },
          child: Text(L10n.of(context)!.downloadBetaIOSButton),
        ),
        const Divider(thickness: 1),
        Text(
          L10n.of(context)!.joinBetaGroup,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
