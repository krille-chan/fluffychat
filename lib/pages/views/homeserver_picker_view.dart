import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:vrouter/vrouter.dart';

import '../homeserver_picker.dart';
import 'package:fluffychat/widgets/default_app_bar_search_field.dart';
import 'package:fluffychat/widgets/fluffy_banner.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/widgets/layouts/one_page_card.dart';
import 'package:fluffychat/utils/platform_infos.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/localized_exception_extension.dart';

import 'package:matrix/matrix.dart';

class HomeserverPickerView extends StatelessWidget {
  final HomeserverPickerController controller;

  const HomeserverPickerView(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnePageCard(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 8,
          title: DefaultAppBarSearchField(
            prefixText: 'https://',
            hintText: L10n.of(context).enterYourHomeserver,
            searchController: controller.homeserverController,
            suffix: const Icon(Icons.edit_outlined),
            padding: EdgeInsets.zero,
            onChanged: controller.setDomain,
            readOnly: !AppConfig.allowOtherHomeservers,
            onSubmit: (_) => controller.checkHomeserverAction(),
            unfocusOnClear: false,
            autocorrect: false,
            labelText: L10n.of(context).homeserver,
          ),
          elevation: 0,
        ),
        body: ListView(children: [
          const Hero(
            tag: 'loginBanner',
            child: FluffyBanner(),
          ),
          controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator.adaptive(strokeWidth: 2))
              : controller.error != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          controller.error,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.red[900],
                          ),
                        ),
                      ),
                    )
                  : FutureBuilder(
                      future: controller.getLoginTypes(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              snapshot.error.toLocalizedString(context),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator.adaptive(
                                  strokeWidth: 2));
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 4.0,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (controller.ssoLoginSupported) ...{
                                for (final identityProvider
                                    in controller.identityProviders)
                                  Center(
                                    child: _LoginButton(
                                      onPressed: () => controller
                                          .ssoLoginAction(identityProvider.id),
                                      icon: identityProvider.icon == null
                                          ? const Icon(Icons.web_outlined)
                                          : CachedNetworkImage(
                                              imageUrl: Uri.parse(
                                                      identityProvider.icon)
                                                  .getDownloadLink(
                                                      Matrix.of(context)
                                                          .getLoginClient())
                                                  .toString(),
                                              width: 24,
                                              height: 24,
                                            ),
                                      labelText: L10n.of(context).loginWith(
                                          identityProvider.name ??
                                              identityProvider.brand ??
                                              L10n.of(context).singlesignon),
                                    ),
                                  ),
                                if (controller.registrationSupported ||
                                    controller.passwordLoginSupported)
                                  Row(children: [
                                    const Expanded(child: Divider()),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(L10n.of(context).or),
                                    ),
                                    const Expanded(child: Divider()),
                                  ]),
                              },
                              Row(
                                children: [
                                  if (controller.passwordLoginSupported)
                                    Expanded(
                                      child: _LoginButton(
                                        onPressed: () =>
                                            VRouter.of(context).to('login'),
                                        icon: const Icon(Icons.login_outlined),
                                        labelText: L10n.of(context).login,
                                      ),
                                    ),
                                  if (controller.registrationSupported &&
                                      controller.passwordLoginSupported)
                                    const SizedBox(width: 12),
                                  if (controller.registrationSupported &&
                                      // Registration is broken on matrix.org
                                      Matrix.of(context)
                                              .client
                                              .homeserver
                                              .host !=
                                          'matrix-client.matrix.org')
                                    Expanded(
                                      child: _LoginButton(
                                        onPressed: controller.signUpAction,
                                        icon:
                                            const Icon(Icons.add_box_outlined),
                                        labelText: L10n.of(context).register,
                                      ),
                                    ),
                                ],
                              ),
                            ]
                                .map(
                                  (widget) => Container(
                                      height: 64,
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: widget),
                                )
                                .toList(),
                          ),
                        );
                      }),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              TextButton(
                onPressed: () => launch(AppConfig.privacyUrl),
                child: Text(
                  L10n.of(context).privacy,
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => PlatformInfos.showDialog(context),
                child: Text(
                  L10n.of(context).about,
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final String labelText;
  final Widget icon;
  final void Function() onPressed;
  const _LoginButton({
    Key key,
    this.labelText,
    this.icon,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
          minimumSize: const Size(256, 56),
          side: BorderSide(
            color: Theme.of(context).textTheme.bodyText1.color,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(90))),
      onPressed: onPressed,
      icon: icon,
      label: Text(
        labelText,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyText1.color,
        ),
      ),
    );
  }
}
