import 'package:flutter/material.dart';

import 'package:matrix_homeserver_recommendations/matrix_homeserver_recommendations.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeserverBottomSheet extends StatelessWidget {
  final HomeserverBenchmarkResult homeserver;
  const HomeserverBottomSheet({required this.homeserver, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responseTime = homeserver.responseTime;
    final description = homeserver.homeserver.description;
    final rules = homeserver.homeserver.rules;
    final privacy = homeserver.homeserver.privacyPolicy;
    final registration = homeserver.homeserver.registration;
    final jurisdiction = homeserver.homeserver.jurisdiction;
    final homeserverSoftware = homeserver.homeserver.homeserverSoftware;
    return Scaffold(
      appBar: AppBar(
        title: Text(homeserver.homeserver.baseUrl.host),
      ),
      body: ListView(
        children: [
          if (description != null && description.isNotEmpty)
            ListTile(
              leading: const Icon(Icons.info_outlined),
              title: Text(description),
            ),
          if (jurisdiction != null && jurisdiction.isNotEmpty)
            ListTile(
              leading: const Icon(Icons.location_city_outlined),
              title: Text(jurisdiction),
            ),
          if (homeserverSoftware != null && homeserverSoftware.isNotEmpty)
            ListTile(
              leading: const Icon(Icons.domain_outlined),
              title: Text(homeserverSoftware),
            ),
          ListTile(
            onTap: () =>
                launchUrlString(homeserver.homeserver.baseUrl.toString()),
            leading: const Icon(Icons.link_outlined),
            title: Text(homeserver.homeserver.baseUrl.toString()),
          ),
          if (registration != null)
            ListTile(
              onTap: () => launchUrlString(registration.toString()),
              leading: const Icon(Icons.person_add_outlined),
              title: Text(registration.toString()),
            ),
          if (rules != null)
            ListTile(
              onTap: () => launchUrlString(rules.toString()),
              leading: const Icon(Icons.visibility_outlined),
              title: Text(rules.toString()),
            ),
          if (privacy != null)
            ListTile(
              onTap: () => launchUrlString(privacy.toString()),
              leading: const Icon(Icons.shield_outlined),
              title: Text(privacy.toString()),
            ),
          if (responseTime != null)
            ListTile(
              leading: const Icon(Icons.timer_outlined),
              title: Text('${responseTime.inMilliseconds}ms'),
            ),
        ],
      ),
    );
  }
}
