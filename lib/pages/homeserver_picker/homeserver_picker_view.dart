import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../config/themes.dart';
import 'homeserver_picker.dart';

class HomeserverPickerView extends StatelessWidget {
  final HomeserverPickerController controller;

  const HomeserverPickerView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LoginScaffold(
      enforceMobileMode: Matrix.of(context).client.isLogged(),
      appBar: controller.widget.addMultiAccount
          ? AppBar(
              centerTitle: true,
              title: Text(L10n.of(context)!.addAccount),
            )
          : null,
      body: ListView(
        children: [
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
              color: theme.colorScheme.surface,
              child: ListTile(
                leading: const Icon(Icons.vpn_key),
                title: Text(L10n.of(context)!.hydrateTor),
                subtitle: Text(L10n.of(context)!.hydrateTorLong),
                trailing: const Icon(Icons.chevron_right_outlined),
                onTap: controller.restoreBackup,
              ),
            ),
          ),
          Image.asset(
            'assets/banner_transparent.png',
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              right: 8.0,
              left: 8.0,
              bottom: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: controller.tryCheckHomeserverActionWithCooldown,
                    onEditingComplete:
                        controller.tryCheckHomeserverActionWithoutCooldown,
                    onSubmitted:
                        controller.tryCheckHomeserverActionWithoutCooldown,
                    onTap: controller.tryCheckHomeserverActionWithCooldown,
                    controller: controller.homeserverController,
                    decoration: InputDecoration(
                      prefixIcon: controller.isLoading
                          ? Container(
                              width: 16,
                              height: 16,
                              alignment: Alignment.center,
                              child: const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator.adaptive(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : const Icon(Icons.search_outlined),
                      filled: false,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppConfig.borderRadius),
                      ),
                      hintText: AppConfig.defaultHomeserver,
                      labelText: L10n.of(context)!.homeserver,
                      errorText: controller.error,
                      suffixIcon: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog.adaptive(
                              title: Text(L10n.of(context)!.whatIsAHomeserver),
                              content: Linkify(
                                text: L10n.of(context)!.homeserverDescription,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => launchUrl(
                                    Uri.https('servers.joinmatrix.org'),
                                  ),
                                  child: Text(
                                    L10n.of(context)!.discoverHomeservers,
                                  ),
                                ),
                                TextButton(
                                  onPressed: Navigator.of(context).pop,
                                  child: Text(L10n.of(context)!.close),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.info_outlined),
                      ),
                    ),
                  ),
                ),
                if (controller.supportsPasswordLogin || controller.supportsSso)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                      ),
                      onPressed: controller.isLoggingIn || controller.isLoading
                          ? null
                          : controller.supportsSso
                              ? controller.ssoLoginAction
                              : controller.login,
                      child: Text(L10n.of(context)!.connect),
                    ),
                  ),
                if (controller.supportsPasswordLogin && controller.supportsSso)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.secondary,
                        textStyle: theme.textTheme.labelMedium,
                      ),
                      onPressed: controller.isLoggingIn || controller.isLoading
                          ? null
                          : controller.login,
                      child: Text(L10n.of(context)!.loginWithMatrixId),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: theme.textTheme.labelMedium,
                      foregroundColor: theme.colorScheme.secondary,
                    ),
                    onPressed: controller.isLoggingIn || controller.isLoading
                        ? null
                        : controller.restoreBackup,
                    child: Text(L10n.of(context)!.hydrate),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
