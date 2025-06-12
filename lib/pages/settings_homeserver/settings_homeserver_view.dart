import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:matrix/matrix.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import '../../widgets/matrix.dart';
import 'settings_homeserver.dart';

class SettingsHomeserverView extends StatelessWidget {
  final SettingsHomeserverController controller;

  const SettingsHomeserverView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final client = Matrix.of(context).client;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !FluffyThemes.isColumnMode(context),
        centerTitle: FluffyThemes.isColumnMode(context),
        title: Text(
          L10n.of(context)
              .aboutHomeserver(client.userID?.domain ?? 'Homeserver'),
        ),
      ),
      body: MaxWidthBody(
        withScrolling: true,
        child: SelectionArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  L10n.of(context).serverInformation,
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FutureBuilder(
                future: client.getWellknownSupport(),
                builder: (context, snapshot) {
                  final error = snapshot.error;
                  final data = snapshot.data;
                  if (error != null) {
                    return ListTile(
                      leading: const Icon(Icons.error_outlined),
                      title: Text(
                        error.toLocalizedString(
                          context,
                          ExceptionContext.checkServerSupportInfo,
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  }
                  if (data == null) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(
                        strokeWidth: 2,
                      ),
                    );
                  }
                  final supportPage = data.supportPage;
                  final contacts = data.contacts;
                  if (supportPage == null && contacts == null) {
                    return ListTile(
                      leading: const Icon(Icons.error_outlined),
                      title: Text(
                        L10n.of(context).noContactInformationProvided,
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (supportPage != null)
                        ListTile(
                          title: Text(L10n.of(context).supportPage),
                          subtitle: Text(supportPage.toString()),
                        ),
                      if (contacts != null)
                        ...contacts.map(
                          (contact) {
                            return ListTile(
                              title: Text(
                                contact.role.localizedString(
                                  L10n.of(context),
                                ),
                              ),
                              subtitle: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (contact.emailAddress != null)
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(contact.emailAddress!),
                                    ),
                                  if (contact.matrixId != null)
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(contact.matrixId!),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
              FutureBuilder(
                future: controller.fetchServerInfo(),
                builder: (context, snapshot) {
                  final error = snapshot.error;
                  if (error != null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outlined,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          error.toLocalizedString(context),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ],
                    );
                  }
                  final data = snapshot.data;
                  if (data == null) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(
                        strokeWidth: 2,
                      ),
                    );
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text(L10n.of(context).name),
                        subtitle: Text(data.name),
                      ),
                      ListTile(
                        title: Text(L10n.of(context).version),
                        subtitle: Text(data.version),
                      ),
                      ListTile(
                        title: const Text('Federation Base URL'),
                        subtitle: Linkify(
                          text: data.federationBaseUrl.toString(),
                          textScaleFactor:
                              MediaQuery.textScalerOf(context).scale(1),
                          options: const LinkifyOptions(humanize: false),
                          linkStyle: TextStyle(
                            color: theme.colorScheme.primary,
                            decorationColor: theme.colorScheme.primary,
                          ),
                          onOpen: (link) => launchUrlString(link.url),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Divider(color: theme.dividerColor),
              FutureBuilder(
                future: client.getWellknown(),
                initialData: client.wellKnown,
                builder: (context, snapshot) {
                  final error = snapshot.error;
                  if (error != null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outlined,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          error.toLocalizedString(context),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ],
                    );
                  }
                  final wellKnown = snapshot.data;
                  if (wellKnown == null) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(
                        strokeWidth: 2,
                      ),
                    );
                  }
                  final identityServer = wellKnown.mIdentityServer;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text(
                          'Client-Well-Known Information:',
                          style: TextStyle(
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListTile(
                        title: const Text('Base URL'),
                        subtitle: Linkify(
                          text: wellKnown.mHomeserver.baseUrl.toString(),
                          textScaleFactor:
                              MediaQuery.textScalerOf(context).scale(1),
                          options: const LinkifyOptions(humanize: false),
                          linkStyle: TextStyle(
                            color: theme.colorScheme.primary,
                            decorationColor: theme.colorScheme.primary,
                          ),
                          onOpen: (link) => launchUrlString(link.url),
                        ),
                      ),
                      if (identityServer != null)
                        ListTile(
                          title: const Text('Identity Server:'),
                          subtitle: Linkify(
                            text: identityServer.baseUrl.toString(),
                            textScaleFactor:
                                MediaQuery.textScalerOf(context).scale(1),
                            options: const LinkifyOptions(humanize: false),
                            linkStyle: TextStyle(
                              color: theme.colorScheme.primary,
                              decorationColor: theme.colorScheme.primary,
                            ),
                            onOpen: (link) => launchUrlString(link.url),
                          ),
                        ),
                      ...wellKnown.additionalProperties.entries.map(
                        (entry) => ListTile(
                          title: Text(entry.key),
                          subtitle: Material(
                            borderRadius:
                                BorderRadius.circular(AppConfig.borderRadius),
                            color: theme.colorScheme.surfaceContainer,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                const JsonEncoder.withIndent('    ')
                                    .convert(entry.value),
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on Role {
  String localizedString(L10n l10n) {
    switch (this) {
      case Role.mRoleAdmin:
        return l10n.contactServerAdmin;
      case Role.mRoleSecurity:
        return l10n.contactServerSecurity;
    }
  }
}
