import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:tawkie/config/app_config.dart';
import 'package:url_launcher/url_launcher.dart';

class IOSInstructions extends StatelessWidget {
  const IOSInstructions({super.key});

  Future<bool> _launchUrl(String url, BuildContext context) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error to lauch url: $e');
      }
      final snackBar = SnackBar(content: Text(L10n.of(context)!.tryAgain));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return false;
  }

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
            await _launchUrl(AppConfig.testflightAppUrl, context);
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
            await _launchUrl(AppConfig.appleBetaUrl, context);
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
