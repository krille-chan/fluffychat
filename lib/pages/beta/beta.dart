import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BetaJoinPage extends StatelessWidget {
  // URLs
  final String testflightAppUrl =
      'https://apps.apple.com/us/app/testflight/id899247664';
  final String appleBetaUrl = 'https://testflight.apple.com/join/daXe0NfW';
  final String playStoreUrl =
      'https://play.google.com/store/apps/details?id=fr.tawkie.app';
  final String androidBetaUrl =
      'https://play.google.com/apps/testing/fr.tawkie.app';

  const BetaJoinPage({super.key});

  void joinBeta() async {
    if (Platform.isIOS) {
      final String appStoreUrl =
          'itms-apps://itunes.apple.com/app/id899247664'; // Direct link to the TestFlight app
      if (await canLaunchUrl(Uri.parse(appStoreUrl))) {
        await launchUrl(Uri.parse(appStoreUrl));
      } else if (await canLaunchUrl(Uri.parse(appleBetaUrl))) {
        await launchUrl(Uri.parse(appleBetaUrl));
      } else {
        throw 'Could not launch $appleBetaUrl';
      }
    } else if (Platform.isAndroid) {
      final String playStoreUrl =
          'market://details?id=fr.tawkie.app'; // Direct link to the Play Store app
      if (await canLaunchUrl(Uri.parse(playStoreUrl))) {
        await launchUrl(Uri.parse(playStoreUrl));
      } else if (await canLaunchUrl(Uri.parse(androidBetaUrl))) {
        await launchUrl(Uri.parse(androidBetaUrl));
      } else {
        throw 'Could not launch $androidBetaUrl';
      }
    }
  }

  void joinGroup() {
    print("Rejoindre le groupe Beta");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rejoindre la Bêta'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              '## Comment tester la version Beta et accéder aux nouvelles fonctionnalités en avance ?\n',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Participer à la Beta permet d\'avoir accès aux mises à jour de l\'application en avance et tester en premier.ère les nouvelles fonctionnalités !\n',
              style: TextStyle(fontSize: 16),
            ),
            if (Platform.isIOS) ...[
              Text(
                'Sous iOS :',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '- Installer Apple Testflight',
                style: TextStyle(fontSize: 16),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (await canLaunchUrl(Uri.parse(testflightAppUrl))) {
                    await launchUrl(Uri.parse(testflightAppUrl));
                  } else {
                    throw 'Could not launch $testflightAppUrl';
                  }
                },
                child: Text('Télécharger Apple Testflight'),
              ),
              Divider(thickness: 1),
              Text(
                '- Rejoindre la Beta',
                style: TextStyle(fontSize: 16),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (await canLaunchUrl(Uri.parse(appleBetaUrl))) {
                    await launchUrl(Uri.parse(appleBetaUrl));
                  } else {
                    throw 'Could not launch $appleBetaUrl';
                  }
                },
                child: Text('Télécharger la Beta iOS'),
              ),
              Divider(thickness: 1),
              Text(
                '- Rejoindre le groupe Tawkie de la Beta : #beta:alpha.tawkie.fr\n',
                style: TextStyle(fontSize: 16),
              ),
            ],
            if (Platform.isAndroid) ...[
              Text(
                'Sous Android :',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '- Rejoindre la Beta depuis le Play Store ou en ligne',
                style: TextStyle(fontSize: 16),
              ),
              ElevatedButton(
                onPressed: () async {
                  final String playStoreUrl =
                      'market://details?id=fr.tawkie.app';
                  if (await canLaunchUrl(Uri.parse(playStoreUrl))) {
                    await launchUrl(Uri.parse(playStoreUrl));
                  } else if (await canLaunchUrl(Uri.parse(androidBetaUrl))) {
                    await launchUrl(Uri.parse(androidBetaUrl));
                  } else {
                    throw 'Could not launch $androidBetaUrl';
                  }
                },
                child: Text('Télécharger la Beta Android'),
              ),
              Divider(thickness: 1),
              Text(
                '- Rejoindre le groupe Tawkie de la Beta : #beta:alpha.tawkie.fr\n',
                style: TextStyle(fontSize: 16),
              ),
            ],
            ElevatedButton.icon(
              onPressed: joinGroup,
              icon: Icon(Icons.new_releases),
              label: Text('Rejoindre le groupe Beta'),
            ),
          ],
        ),
      ),
    );
  }
}
