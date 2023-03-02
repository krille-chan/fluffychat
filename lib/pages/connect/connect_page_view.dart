import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/pages/connect/connect_page.dart';
import 'package:fluffychat/widgets/layouts/login_scaffold.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'sso_button.dart';

class ConnectPageView extends StatelessWidget {
  final ConnectPageController controller;
  const ConnectPageView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final avatar = Matrix.of(context).loginAvatar;
    final identityProviders = controller.identityProviders;
    return LoginScaffold(
      appBar: AppBar(
        leading: controller.loading ? null : const BackButton(),
        automaticallyImplyLeading: !controller.loading,
        centerTitle: true,
        title: Text(
          Matrix.of(context).getLoginClient().homeserver?.host ?? '',
        ),
      ),
      body: ListView(
        key: const Key('ConnectPageListView'),
        children: [
          if (Matrix.of(context).loginRegistrationSupported ?? false) ...[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Stack(
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(64),
                      elevation: Theme.of(context)
                              .appBarTheme
                              .scrolledUnderElevation ??
                          10,
                      color: Colors.transparent,
                      shadowColor: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withAlpha(64),
                      clipBehavior: Clip.hardEdge,
                      child: CircleAvatar(
                        radius: 64,
                        backgroundColor: Colors.white,
                        child: avatar == null
                            ? const Icon(
                                Icons.person,
                                color: Colors.black,
                                size: 64,
                              )
                            : FutureBuilder<Uint8List>(
                                future: avatar.readAsBytes(),
                                builder: (context, snapshot) {
                                  final bytes = snapshot.data;
                                  if (bytes == null) {
                                    return const CircularProgressIndicator
                                        .adaptive();
                                  }
                                  return Image.memory(
                                    bytes,
                                    fit: BoxFit.cover,
                                    width: 128,
                                    height: 128,
                                  );
                                },
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: FloatingActionButton(
                        mini: true,
                        onPressed: controller.pickAvatar,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        child: const Icon(Icons.camera_alt_outlined),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: controller.usernameController,
                onSubmitted: (_) => controller.signUp(),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.account_box_outlined),
                  hintText: L10n.of(context)!.chooseAUsername,
                  errorText: controller.signupError,
                  errorStyle: const TextStyle(color: Colors.orange),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Hero(
                tag: 'loginButton',
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: controller.loading ? () {} : controller.signUp,
                  icon: const Icon(Icons.person_add_outlined),
                  label: controller.loading
                      ? const LinearProgressIndicator()
                      : Text(L10n.of(context)!.signUp),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      L10n.of(context)!.or,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (controller.supportsSso)
            identityProviders == null
                ? const SizedBox(
                    height: 74,
                    child: Center(child: CircularProgressIndicator.adaptive()),
                  )
                : Center(
                    child: identityProviders.length == 1
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12.0),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                foregroundColor: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                              icon: identityProviders.single.icon == null
                                  ? const Icon(
                                      Icons.web_outlined,
                                      size: 16,
                                    )
                                  : Image.network(
                                      Uri.parse(identityProviders.single.icon!)
                                          .getDownloadLink(
                                            Matrix.of(context).getLoginClient(),
                                          )
                                          .toString(),
                                      width: 32,
                                      height: 32,
                                    ),
                              onPressed: () => controller
                                  .ssoLoginAction(identityProviders.single.id!),
                              label: Text(
                                identityProviders.single.name ??
                                    identityProviders.single.brand ??
                                    L10n.of(context)!.loginWithOneClick,
                              ),
                            ),
                          )
                        : Wrap(
                            children: [
                              for (final identityProvider in identityProviders)
                                SsoButton(
                                  onPressed: () => controller
                                      .ssoLoginAction(identityProvider.id!),
                                  identityProvider: identityProvider,
                                ),
                            ].toList(),
                          ),
                  ),
          if (controller.supportsLogin)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Hero(
                tag: 'signinButton',
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.login_outlined),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  onPressed: controller.loading ? () {} : controller.login,
                  label: Text(L10n.of(context)!.login),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
