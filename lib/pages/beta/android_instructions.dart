import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:tawkie/config/app_config.dart';
import 'package:url_launcher/url_launcher.dart';

class AndroidInstructions extends StatelessWidget {
  const AndroidInstructions({super.key});

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
            bool success = await _launchUrl(AppConfig.playStoreUrl, context);
            if (!success) {
              await _launchUrl(AppConfig.androidBetaUrl, context);
            }
          },
          child: Text(L10n.of(context)!.downloadBetaAndroidButton),
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
