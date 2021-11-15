import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/default_app_bar_search_field.dart';
import 'package:fluffychat/widgets/layouts/one_page_card.dart';
import 'package:fluffychat/widgets/matrix.dart';
import '../../utils/localized_exception_extension.dart';
import 'homeserver_picker.dart';

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
          Image.asset(
            Theme.of(context).brightness == Brightness.dark
                ? 'assets/banner_dark.png'
                : 'assets/banner.png',
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
                            children: [
                              if (controller.ssoLoginSupported)
                                Row(children: [
                                  const Expanded(child: Divider()),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                        L10n.of(context).loginWithOneClick),
                                  ),
                                  const Expanded(child: Divider()),
                                ]),
                              Wrap(
                                children: [
                                  if (controller.ssoLoginSupported) ...{
                                    for (final identityProvider
                                        in controller.identityProviders)
                                      _SsoButton(
                                        onPressed: () =>
                                            controller.ssoLoginAction(
                                                identityProvider.id),
                                        identityProvider: identityProvider,
                                      ),
                                  },
                                ].toList(),
                              ),
                              if (controller.ssoLoginSupported &&
                                  (controller.registrationSupported ||
                                      controller.passwordLoginSupported))
                                Row(children: [
                                  const Expanded(child: Divider()),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(L10n.of(context).or),
                                  ),
                                  const Expanded(child: Divider()),
                                ]),
                              if (controller.passwordLoginSupported) ...[
                                Center(
                                  child: _LoginButton(
                                    onPressed: () =>
                                        VRouter.of(context).to('login'),
                                    icon: Icon(
                                      CupertinoIcons.lock_open_fill,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color,
                                    ),
                                    labelText: L10n.of(context).login,
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],
                              if (controller.registrationSupported)
                                Center(
                                  child: _LoginButton(
                                    onPressed: controller.signUpAction,
                                    icon: Icon(
                                      CupertinoIcons.person_add,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color,
                                    ),
                                    labelText: L10n.of(context).register,
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),
        ]),
        bottomNavigationBar: Material(
          elevation: 6,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Wrap(
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
        ),
      ),
    );
  }
}

class _SsoButton extends StatelessWidget {
  final IdentityProvider identityProvider;
  final void Function() onPressed;
  const _SsoButton({
    Key key,
    @required this.identityProvider,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(7),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            identityProvider.icon == null
                ? const Icon(Icons.web_outlined)
                : CachedNetworkImage(
                    imageUrl: Uri.parse(identityProvider.icon)
                        .getDownloadLink(Matrix.of(context).getLoginClient())
                        .toString(),
                    width: 32,
                    height: 32,
                  ),
            const SizedBox(height: 8),
            Text(
              identityProvider.name ??
                  identityProvider.brand ??
                  L10n.of(context).singlesignon,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.subtitle2.color,
              ),
            ),
          ],
        ),
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
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        backgroundColor: Theme.of(context).backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConfig.borderRadius),
        ),
      ),
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
