import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class BetaInstructions extends StatelessWidget {
  const BetaInstructions({super.key});

  // Launch url in browser or device app
  Future<bool> openUrl(String url, BuildContext context) async {
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
}
