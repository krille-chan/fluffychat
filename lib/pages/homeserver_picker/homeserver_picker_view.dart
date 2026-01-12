import 'package:flutter/material.dart';

import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/adaptive_dialog_action.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'homeserver_picker.dart';

class HomeserverPickerView extends StatelessWidget {
  final HomeserverPickerController controller;

  const HomeserverPickerView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LoginScaffold(
      enforceMobileMode: Matrix.of(
        context,
      ).widget.clients.any((client) => client.isLogged()),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          controller.widget.addMultiAccount
              ? L10n.of(context).addAccount
              : L10n.of(context).login,
        ),
        actions: [
          PopupMenuButton<MoreLoginActions>(
            useRootNavigator: true,
            onSelected: controller.onMoreAction,
            itemBuilder: (_) => [
              PopupMenuItem(
                value: MoreLoginActions.importBackup,
                child: Row(
                  mainAxisSize: .min,
                  children: [
                    const Icon(Icons.import_export_outlined),
                    const SizedBox(width: 12),
                    Text(L10n.of(context).hydrate),
                  ],
                ),
              ),
              PopupMenuItem(
                value: MoreLoginActions.privacy,
                child: Row(
                  mainAxisSize: .min,
                  children: [
                    const Icon(Icons.privacy_tip_outlined),
                    const SizedBox(width: 12),
                    Text(L10n.of(context).privacy),
                  ],
                ),
              ),
              PopupMenuItem(
                value: MoreLoginActions.about,
                child: Row(
                  mainAxisSize: .min,
                  children: [
                    const Icon(Icons.info_outlined),
                    const SizedBox(width: 12),
                    Text(L10n.of(context).about),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Hero(
                        tag: 'info-logo',
                        child: Image.asset(
                          './assets/banner_transparent.png',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: SelectableLinkify(
                        text: L10n.of(context).appIntroduction,
                        textScaleFactor: MediaQuery.textScalerOf(
                          context,
                        ).scale(1),
                        textAlign: TextAlign.center,
                        linkStyle: TextStyle(
                          color: theme.colorScheme.secondary,
                          decorationColor: theme.colorScheme.secondary,
                        ),
                        onOpen: (link) => launchUrlString(link.url),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisSize: .min,
                        crossAxisAlignment: .stretch,
                        children: [
                          TextField(
                            onSubmitted: (_) =>
                                controller.checkHomeserverAction(),
                            controller: controller.homeserverController,
                            autocorrect: false,
                            keyboardType: TextInputType.url,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search_outlined),
                              filled: false,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppConfig.borderRadius,
                                ),
                              ),
                              hintText: AppSettings.defaultHomeserver.value,
                              hintStyle: TextStyle(
                                color: theme.colorScheme.surfaceTint,
                              ),
                              labelText: L10n.of(context).signInWith,
                              errorText: controller.error,
                              errorMaxLines: 4,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog.adaptive(
                                      title: Text(
                                        L10n.of(context).whatIsAHomeserver,
                                      ),
                                      content: Linkify(
                                        text: L10n.of(
                                          context,
                                        ).homeserverDescription,
                                        textScaleFactor:
                                            MediaQuery.textScalerOf(
                                              context,
                                            ).scale(1),
                                        options: const LinkifyOptions(
                                          humanize: false,
                                        ),
                                        linkStyle: TextStyle(
                                          color: theme.colorScheme.primary,
                                          decorationColor:
                                              theme.colorScheme.primary,
                                        ),
                                        onOpen: (link) =>
                                            launchUrlString(link.url),
                                      ),
                                      actions: [
                                        AdaptiveDialogAction(
                                          onPressed: () => launchUrl(
                                            Uri.https('servers.joinmatrix.org'),
                                          ),
                                          child: Text(
                                            L10n.of(
                                              context,
                                            ).discoverHomeservers,
                                          ),
                                        ),
                                        AdaptiveDialogAction(
                                          onPressed: Navigator.of(context).pop,
                                          child: Text(L10n.of(context).close),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.info_outlined),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                            ),
                            onPressed: controller.isLoading
                                ? null
                                : controller.checkHomeserverAction,
                            child: controller.isLoading
                                ? const LinearProgressIndicator()
                                : Text(L10n.of(context).continueText),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: theme.colorScheme.secondary,
                              textStyle: theme.textTheme.labelMedium,
                            ),
                            onPressed: controller.isLoading
                                ? null
                                : () => controller.checkHomeserverAction(
                                    legacyPasswordLogin: true,
                                  ),
                            child: Text(L10n.of(context).loginWithMatrixId),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
