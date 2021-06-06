import 'package:cached_network_image/cached_network_image.dart';
import 'package:vrouter/vrouter.dart';
import 'package:fluffychat/pages/sign_up.dart';
import 'package:fluffychat/widgets/fluffy_banner.dart';

import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/layouts/one_page_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import '../../utils/localized_exception_extension.dart';

import 'package:famedlysdk/famedlysdk.dart';

class SignUpView extends StatelessWidget {
  final SignUpController controller;

  const SignUpView(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnePageCard(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            Matrix.of(context)
                .client
                .homeserver
                .toString()
                .replaceFirst('https://', ''),
          ),
        ),
        body: FutureBuilder(
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
                return Center(child: CircularProgressIndicator());
              }
              return ListView(children: <Widget>[
                Hero(
                  tag: 'loginBanner',
                  child: FluffyBanner(),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (controller.ssoLoginSupported) ...{
                        for (final identityProvider
                            in controller.identityProviders)
                          OutlinedButton.icon(
                            onPressed: () =>
                                controller.ssoLoginAction(identityProvider.id),
                            icon: identityProvider.icon == null
                                ? Icon(Icons.web_outlined)
                                : CachedNetworkImage(
                                    imageUrl: Uri.parse(identityProvider.icon)
                                        .getDownloadLink(
                                            Matrix.of(context).client)
                                        .toString(),
                                    width: 24,
                                    height: 24,
                                  ),
                            label: Text(L10n.of(context).loginWith(
                                identityProvider.brand ??
                                    identityProvider.name ??
                                    L10n.of(context).singlesignon)),
                          ),
                        if (controller.registrationSupported ||
                            controller.passwordLoginSupported)
                          Row(children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(L10n.of(context).or),
                            ),
                            Expanded(child: Divider()),
                          ]),
                      },
                      Row(
                        children: [
                          if (controller.passwordLoginSupported)
                            Expanded(
                              child: Container(
                                height: 64,
                                child: OutlinedButton.icon(
                                  onPressed: () =>
                                      context.vRouter.push('/login'),
                                  icon: Icon(Icons.login_outlined),
                                  label: Text(L10n.of(context).login),
                                ),
                              ),
                            ),
                          if (controller.registrationSupported &&
                              controller.passwordLoginSupported)
                            SizedBox(width: 12),
                          if (controller.registrationSupported)
                            Expanded(
                              child: Container(
                                height: 64,
                                child: OutlinedButton.icon(
                                  onPressed: controller.signUpAction,
                                  icon: Icon(Icons.add_box_outlined),
                                  label: Text(L10n.of(context).register),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ]
                        .map(
                          (widget) => Container(
                              height: 64,
                              padding: EdgeInsets.only(bottom: 12),
                              child: widget),
                        )
                        .toList(),
                  ),
                ),
              ]);
            }),
      ),
    );
  }
}
