import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'homeserver_picker.dart';

class HomeserverPickerView extends StatelessWidget {
  final HomeserverPickerController controller;

  const HomeserverPickerView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final benchmarkResults = controller.benchmarkResults;
    return LoginScaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            focusNode: controller.homeserverFocusNode,
            controller: controller.homeserverController,
            onChanged: controller.onChanged,
            decoration: InputDecoration(
              prefixText: '${L10n.of(context)!.homeserver}: ',
              hintText: L10n.of(context)!.enterYourHomeserver,
              suffixIcon: const Icon(Icons.search),
              errorText: controller.error,
            ),
            readOnly: !AppConfig.allowOtherHomeservers,
            onSubmitted: (_) => controller.checkHomeserverAction(),
            autocorrect: false,
          ),
        ),
      ),
      body: Column(
        children: [
          // display a prominent banner to import session for TOR browser
          // users. This feature is just some UX sugar as TOR users are
          // usually forced to logout as TOR browser is non-persistent
          AnimatedContainer(
            height: controller.isTorBrowser ? 64 : 0,
            duration: const Duration(milliseconds: 300),
            clipBehavior: Clip.hardEdge,
            curve: Curves.bounceInOut,
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
            child: ListView(
              children: [
                if (controller.displayServerList)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Material(
                      borderRadius:
                          BorderRadius.circular(AppConfig.borderRadius),
                      color: Theme.of(context).colorScheme.onInverseSurface,
                      clipBehavior: Clip.hardEdge,
                      child: benchmarkResults == null
                          ? const Center(
                              child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: CircularProgressIndicator.adaptive(),
                            ))
                          : Column(
                              children: controller.filteredHomeservers
                                  .map(
                                    (server) => ListTile(
                                      trailing: IconButton(
                                        icon: const Icon(
                                          Icons.info_outlined,
                                          color: Colors.black,
                                        ),
                                        onPressed: () =>
                                            controller.showServerInfo(server),
                                      ),
                                      onTap: () => controller.setServer(
                                          server.homeserver.baseUrl.host),
                                      title: Text(
                                        server.homeserver.baseUrl.host,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      subtitle: Text(
                                        server.homeserver.description ?? '',
                                        style: TextStyle(
                                            color: Colors.grey.shade700),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                    ),
                  )
                else ...[
                  Container(
                    alignment: Alignment.center,
                    height: 200,
                    child: Image.asset(
                      'assets/info-logo.png',
                      filterQuality: FilterQuality.medium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: Text(
                        AppConfig.applicationWelcomeMessage ??
                            L10n.of(context)!.welcomeText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ],
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
                    style: TextButton.styleFrom(
                      foregroundColor:
                          Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    onPressed: controller.restoreBackup,
                    child: Text(L10n.of(context)!.hydrate),
                  ),
                  TextButton(
                    onPressed: () => launch(AppConfig.privacyUrl),
                    child: Text(L10n.of(context)!.privacy),
                  ),
                  Hero(
                    tag: 'loginButton',
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed: controller.isLoading
                          ? null
                          : controller.checkHomeserverAction,
                      child: controller.isLoading
                          ? const LinearProgressIndicator()
                          : Text(L10n.of(context)!.connect),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
