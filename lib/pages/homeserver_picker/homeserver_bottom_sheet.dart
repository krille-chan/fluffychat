import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher_string.dart';

import 'package:fluffychat/pages/homeserver_picker/public_homeserver.dart';

class HomeserverBottomSheet extends StatelessWidget {
  final PublicHomeserver homeserver;
  const HomeserverBottomSheet({required this.homeserver, super.key});

  @override
  Widget build(BuildContext context) {
    final description = homeserver.description;
    final registration = homeserver.regLink;
    final jurisdiction = homeserver.staffJur;
    final homeserverSoftware = homeserver.software;
    return Scaffold(
      appBar: AppBar(
        title: Text(homeserver.name),
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
            onTap: () => launchUrlString(homeserver.name),
            leading: const Icon(Icons.link_outlined),
            title: Text(homeserver.name),
          ),
          if (registration != null)
            ListTile(
              onTap: () => launchUrlString(registration),
              leading: const Icon(Icons.person_add_outlined),
              title: Text(registration),
            ),
        ],
      ),
    );
  }
}
