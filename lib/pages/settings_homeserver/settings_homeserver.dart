import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:matrix/matrix.dart';

import '../../widgets/matrix.dart';
import 'settings_homeserver_view.dart';

class SettingsHomeserver extends StatefulWidget {
  const SettingsHomeserver({super.key});

  @override
  SettingsHomeserverController createState() => SettingsHomeserverController();
}

class SettingsHomeserverController extends State<SettingsHomeserver> {
  Future<({String name, String version, Uri federationBaseUrl})>
      fetchServerInfo() async {
    final client = Matrix.of(context).client;
    final domain = client.userID!.domain!;
    final httpClient = client.httpClient;
    var federationBaseUrl = Uri(host: domain, port: 8448, scheme: 'https');
    try {
      final serverWellKnownResult = await httpClient.get(
        Uri.https(domain, '/.well-known/matrix/server'),
      );
      final serverWellKnown = jsonDecode(serverWellKnownResult.body);
      federationBaseUrl = Uri.https(serverWellKnown['m.server']);
    } catch (e, s) {
      Logs().w(
        'Unable to fetch federation base uri. Use $federationBaseUrl',
        e,
        s,
      );
    }

    final serverVersionResult = await http.get(
      federationBaseUrl.resolveUri(
        Uri(path: '/_matrix/federation/v1/version'),
      ),
    );
    final {
      'server': {
        'name': String name,
        'version': String version,
      },
    } = Map<String, Map<String, dynamic>>.from(
      jsonDecode(serverVersionResult.body),
    );

    return (name: name, version: version, federationBaseUrl: federationBaseUrl);
  }

  @override
  Widget build(BuildContext context) => SettingsHomeserverView(this);
}
