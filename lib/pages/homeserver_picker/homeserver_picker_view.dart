import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import '../../config/themes.dart';
import '../../widgets/mxc_image.dart';
import 'homeserver_app_bar.dart';
import 'homeserver_picker.dart';

class HomeserverPickerView extends StatelessWidget {
  final HomeserverPickerController controller;

  const HomeserverPickerView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final identityProviders = controller.identityProviders;
    final errorText = controller.error;
    return LoginScaffold(
      appBar: AppBar(
        titleSpacing: 12,
        title: Padding(
          padding: const EdgeInsets.all(0.0),
          child: HomeserverAppBar(controller: controller),
        ),
      ),
      body: SafeArea(
        child: Column(
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
              child: controller.isLoading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : ListView(
                      children: [
                        Image.asset(
                          'assets/info-logo.png',
                          height: 96,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  thickness: 1,
                                  height: 1,
                                  color: Theme.of(context).dividerColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  L10n.of(context)!.continueWith,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 1,
                                  height: 1,
                                  color: Theme.of(context).dividerColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (errorText != null) ...[
                          const Center(
                            child: Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Text(
                              errorText,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              L10n.of(context)!
                                  .pleaseTryAgainLaterOrChooseDifferentServer,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        if (identityProviders != null) ...[
                          ...identityProviders.map(
                            (provider) => _LoginButton(
                              icon: provider.icon == null
                                  ? const Icon(Icons.open_in_new_outlined)
                                  : Material(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                        AppConfig.borderRadius,
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                      child: MxcImage(
                                        placeholder: (_) =>
                                            const Icon(Icons.web_outlined),
                                        uri: Uri.parse(provider.icon!),
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                              label: provider.name ??
                                  provider.brand ??
                                  L10n.of(context)!.singlesignon,
                              onPressed: () =>
                                  controller.ssoLoginAction(provider.id!),
                            ),
                          ),
                        ],
                        if (controller.supportsPasswordLogin)
                          _LoginButton(
                            onPressed: controller.login,
                            icon: const Icon(Icons.login_outlined),
                            label: L10n.of(context)!.signInWithPassword,
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: controller.restoreBackup,
                            child: Text(L10n.of(context)!.hydrate),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final void Function() onPressed;

  const _LoginButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: onPressed,
        icon: icon,
        label: Text(label),
      ),
    );
  }
}
