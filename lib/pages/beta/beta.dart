import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class BetaJoinPage extends StatelessWidget {
  // URLs
  final String testflightAppUrl = 'https://apps.apple.com/us/app/testflight/id899247664';
  final String appleBetaUrl = 'https://testflight.apple.com/join/daXe0NfW';
  final String playStoreUrl = 'https://play.google.com/store/apps/details?id=fr.tawkie.app';
  final String androidBetaUrl = 'https://play.google.com/apps/testing/fr.tawkie.app';

  const BetaJoinPage({super.key});

  void joinBeta() async {
    if (Platform.isIOS) {
      if (await canLaunch(appleBetaUrl)) {
        await launch(appleBetaUrl);
      } else {
        throw 'Could not launch $appleBetaUrl';
      }
    } else if (Platform.isAndroid) {
      if (await canLaunch(playStoreUrl)) {
        await launch(playStoreUrl);
      } else {
        throw 'Could not launch $playStoreUrl';
      }
    }
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
            Text(
              'Sous iOS :',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              '- Installer Apple Testflight',
              style: TextStyle(fontSize: 16),
            ),
            InkWell(
              child: Text(
                'Apple Testflight',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
              onTap: () async {
                if (await canLaunch(testflightAppUrl)) {
                  await launch(testflightAppUrl);
                } else {
                  throw 'Could not launch $testflightAppUrl';
                }
              },
            ),
            Text(
              '- Rejoindre la Beta',
              style: TextStyle(fontSize: 16),
            ),
            InkWell(
              child: Text(
                'Beta iOS',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
              onTap: () async {
                if (await canLaunch(appleBetaUrl)) {
                  await launch(appleBetaUrl);
                } else {
                  throw 'Could not launch $appleBetaUrl';
                }
              },
            ),
            Text(
              '- Rejoindre le groupe Tawkie de la Beta : #beta:alpha.tawkie.fr\n',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Sous Android :',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              '- Rejoindre la Beta depuis le Play Store ou en ligne',
              style: TextStyle(fontSize: 16),
            ),
            InkWell(
              child: Text(
                'Beta Android',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
              onTap: () async {
                if (await canLaunch(androidBetaUrl)) {
                  await launch(androidBetaUrl);
                } else {
                  throw 'Could not launch $androidBetaUrl';
                }
              },
            ),
            Text(
              '- Rejoindre le groupe Tawkie de la Beta : #beta:alpha.tawkie.fr\n',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: joinBeta,
              icon: Icon(Icons.new_releases),
              label: Text('Rejoindre la Bêta'),
            ),
          ],
        ),
      ),
    );
  }
}
