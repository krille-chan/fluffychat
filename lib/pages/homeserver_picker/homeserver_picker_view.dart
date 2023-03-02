import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import '../../config/themes.dart';
import 'homeserver_app_bar.dart';
import 'homeserver_picker.dart';

class HomeserverPickerView extends StatelessWidget {
  final HomeserverPickerController controller;

  const HomeserverPickerView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final benchmarkResults = controller.benchmarkResults;
    return LoginScaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: HomeserverAppBar(controller: controller),
            ),
            // display a prominent banner to import session for TOR browser
            // users. This feature is just some UX sugar as TOR users are
            // usually forced to logout as TOR browser is non-persistent
            AnimatedContainer(
              height: controller.isTorBrowser ? 64 : 0,
              duration: FluffyThemes.animationDuration,
              curve: FluffyThemes.animationCurve,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(),
              child: Material(
                clipBehavior: Clip.hardEdge,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(8)),
                color: Theme.of(context).colorScheme.surface,
                child: ListTile(
                  leading: const Icon(Icons.vpn_key),
                  title: Text(L10n.of(context)!.hydrateTor),
                  subtitle: Text(L10n.of(context)!.hydrateTorLong),
                  trailing: const Icon(Icons.chevron_right_outlined),
                  onTap: controller.restoreBackup,
                ),
              ),
            ),
            Expanded(
              child: controller.displayServerList
                  ? ListView(
                      children: [
                        if (controller.displayServerList)
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Material(
                              borderRadius:
                                  BorderRadius.circular(AppConfig.borderRadius),
                              color: Theme.of(context)
                                  .colorScheme
                                  .onInverseSurface,
                              clipBehavior: Clip.hardEdge,
                              child: benchmarkResults == null
                                  ? const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: CircularProgressIndicator
                                            .adaptive(),
                                      ),
                                    )
                                  : Column(
                                      children: controller.filteredHomeservers
                                          .map(
                                            (server) => ListTile(
                                              trailing: IconButton(
                                                icon: const Icon(
                                                  Icons.info_outlined,
                                                  color: Colors.black,
                                                ),
                                                onPressed: () => controller
                                                    .showServerInfo(server),
                                              ),
                                              onTap: () => controller.setServer(
                                                server.homeserver.baseUrl.host,
                                              ),
                                              title: Text(
                                                server.homeserver.baseUrl.host,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              subtitle: Text(
                                                server.homeserver.description ??
                                                    '',
                                                style: TextStyle(
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                            ),
                          ),
                      ],
                    )
                  : Container(
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        'assets/banner_transparent.png',
                        filterQuality: FilterQuality.medium,
                      ),
                    ),
            ),
            SafeArea(
              child: Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextButton(
                      onPressed: () => launchUrlString(AppConfig.privacyUrl),
                      child: Text(L10n.of(context)!.privacy),
                    ),
                    TextButton(
                      onPressed: controller.restoreBackup,
                      child: Text(L10n.of(context)!.hydrate),
                    ),
                    Hero(
                      tag: 'loginButton',
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                        ),
                        onPressed: controller.isLoading
                            ? null
                            : controller.checkHomeserverAction,
                        icon: const Icon(Icons.start_outlined),
                        label: controller.isLoading
                            ? const LinearProgressIndicator()
                            : Text(L10n.of(context)!.letsStart),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
