import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/themes.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'homeserver_picker.dart';

class HomeserverPickerView extends StatelessWidget {
  final HomeserverPickerController controller;

  const HomeserverPickerView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final benchmarkResults = controller.benchmarkResults;
    return LoginScaffold(
      appBar: VRouter.of(context).path == '/home'
          ? null
          : AppBar(title: Text(L10n.of(context)!.addAccount)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                      maxHeight: controller.displayServerList ? 0 : 256),
                  alignment: Alignment.center,
                  child: Image.asset('assets/info-logo.png'),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    focusNode: controller.homeserverFocusNode,
                    controller: controller.homeserverController,
                    onChanged: controller.onChanged,
                    decoration: FluffyThemes.loginTextFieldDecoration(
                      labelText: L10n.of(context)!.homeserver,
                      hintText: L10n.of(context)!.enterYourHomeserver,
                      suffixIcon: const Icon(Icons.search),
                      errorText: controller.error,
                    ),
                    readOnly: !AppConfig.allowOtherHomeservers,
                    onSubmitted: (_) => controller.checkHomeserverAction(),
                    autocorrect: false,
                  ),
                ),
                if (controller.displayServerList)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Material(
                      borderRadius:
                          BorderRadius.circular(AppConfig.borderRadius),
                      color: Colors.white.withAlpha(200),
                      clipBehavior: Clip.hardEdge,
                      child: benchmarkResults == null
                          ? const Center(
                              child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator.adaptive(),
                            ))
                          : Column(
                              children: controller.filteredHomeservers
                                  .map(
                                    (server) => ListTile(
                                      trailing: IconButton(
                                        icon: const Icon(Icons.info_outlined),
                                        onPressed: () =>
                                            controller.showServerInfo(server),
                                      ),
                                      onTap: () => controller.setServer(
                                          server.homeserver.baseUrl.host),
                                      title: Text(
                                        server.homeserver.baseUrl.host,
                                      ),
                                      subtitle: Text(
                                          server.homeserver.description ?? ''),
                                    ),
                                  )
                                  .toList(),
                            ),
                    ),
                  ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => launch(AppConfig.privacyUrl),
                      child: Text(
                        L10n.of(context)!.privacy,
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => PlatformInfos.showDialog(context),
                      child: Text(
                        L10n.of(context)!.about,
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Hero(
              tag: 'loginButton',
              child: ElevatedButton(
                onPressed: controller.isLoading
                    ? () {}
                    : controller.checkHomeserverAction,
                style: ElevatedButton.styleFrom(
                  primary: Colors.white.withAlpha(200),
                  onPrimary: Colors.black,
                  shadowColor: Colors.white,
                ),
                child: controller.isLoading
                    ? const LinearProgressIndicator()
                    : Text(L10n.of(context)!.connect),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
