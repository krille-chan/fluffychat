import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pages/homeserver_picker/homeserver_picker.dart';
import 'package:fluffychat/pages/login/login.dart';
import 'package:fluffychat/pages/sign_up/signup.dart';
import 'package:fluffychat/widgets/layouts/one_page_card.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'connect.dart';

class ConnectPageView extends StatelessWidget {
  final ConnectPageController controller;

  const ConnectPageView(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnePageCard(
      child: Scaffold(
        appBar: AppBar(
          title: Text(L10n.of(context)!.connect),
        ),
        body: controller.loading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: controller.formKey,
                child: ListView(
                  children: [
                    _AvatarSelector(controller: controller),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        readOnly: controller.loading,
                        autocorrect: false,
                        controller: controller.usernameController,
                        autofocus: true,
                        inputFormatters: [controller.usernameFormatter],
                        autofillHints: controller.loading
                            ? null
                            : [AutofillHints.username],
                        validator: controller.usernameTextFieldValidator,
                        onChanged: controller.setUsername,
                        decoration: InputDecoration(
                            prefixIcon:
                                const Icon(Icons.account_circle_outlined),
                            hintText: L10n.of(context)!.username.toLowerCase(),
                            labelText: L10n.of(context)!.username,
                            prefixText: '@',
                            prefixStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                            suffixStyle:
                                const TextStyle(fontWeight: FontWeight.w200),
                            suffixText: ':${controller.domain}'),
                      ),
                    ),
                    SizedBox(
                      height: 56,
                      child: (controller.usernameTaken == true)
                          ? Center(child: Text(L10n.of(context)!.usernameTaken))
                          : (controller.usernameTaken == false ||
                                  (controller.username == null &&
                                      controller.usernameTaken == null))
                              ? Hero(
                                  tag: 'loginButton',
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: OpenContainer(
                                      closedColor: Colors.transparent,
                                      closedElevation: 0,
                                      openBuilder: (context, action) =>
                                          SignupPage(
                                        username: controller.username,
                                        onRegistrationComplete:
                                            controller.applyAvatar,
                                      ),
                                      closedBuilder: (context, action) =>
                                          ElevatedButton(
                                        onPressed: controller.loading ||
                                                controller.usernameTaken == null
                                            ? null
                                            : action,
                                        child: controller.loading
                                            ? const LinearProgressIndicator()
                                            : Text(L10n.of(context)!.signUp),
                                      ),
                                    ),
                                  ),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                    const Divider(),
                    Padding(
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
                                child:
                                    Text(L10n.of(context)!.loginWithOneClick),
                              ),
                              const Expanded(child: Divider()),
                            ]),
                          Wrap(
                            children: [
                              if (controller.ssoLoginSupported) ...{
                                for (final identityProvider
                                    in controller.identityProviders)
                                  _SsoButton(
                                    onPressed: () => controller
                                        .ssoLoginAction(identityProvider.id!),
                                    identityProvider: identityProvider,
                                  ),
                              },
                            ].toList(),
                          ),
                          if (controller.ssoLoginSupported &&
                              (controller.registrationSupported! ||
                                  controller.passwordLoginSupported))
                            Row(children: [
                              const Expanded(child: Divider()),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(L10n.of(context)!.or),
                              ),
                              const Expanded(child: Divider()),
                            ]),
                          if (controller.passwordLoginSupported) ...[
                            Center(
                              child: OpenContainer(
                                closedColor: Colors.transparent,
                                closedElevation: 0,
                                closedBuilder: (context, callback) =>
                                    _LoginButton(
                                  onPressed: callback,
                                  icon: Icon(
                                    CupertinoIcons.lock_open_fill,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                  ),
                                  labelText: L10n.of(context)!.login,
                                ),
                                openBuilder: (context, action) => Login(
                                  username: controller.usernameController.text,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                          /*if (controller.registrationSupported!)
                            Center(
                              child: _LoginButton(
                                onPressed: controller.signUpAction,
                                icon: Icon(
                                  CupertinoIcons.person_add,
                                  color: Theme.of(context).textTheme.bodyText1!.color,
                                ),
                                labelText: L10n.of(context)!.register,
                              ),
                            ),*/
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _AvatarSelector extends StatelessWidget {
  static const borderWidth = 4.0;
  static const dimension = 128.0 + 64.0;
  final ConnectPageController controller;

  const _AvatarSelector({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: dimension,
          width: dimension,
          alignment: Alignment.center,
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Material(
                  borderRadius: BorderRadius.circular(dimension),
                  elevation: 4,
                  color: Theme.of(context).secondaryHeaderColor,
                  child: Padding(
                    padding: const EdgeInsets.all(borderWidth),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(dimension),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                            width: borderWidth),
                      ),
                      child: controller.avatar != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(dimension),
                              child: Image.memory(
                                controller.avatar!.bytes,
                                height: dimension,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.person_outline_outlined,
                              size: dimension * .66,
                            ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  // mini: true,
                  onPressed: controller.setAvatarAction,
                  backgroundColor: Theme.of(context).backgroundColor,
                  foregroundColor: Theme.of(context).textTheme.bodyText1?.color,
                  child: const Icon(Icons.add),
                  tooltip: L10n.of(context)!.changeYourAvatar,
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
  final void Function()? onPressed;

  const _SsoButton({
    Key? key,
    required this.identityProvider,
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
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
              clipBehavior: Clip.hardEdge,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: identityProvider.icon == null
                    ? const Icon(Icons.web_outlined)
                    : CachedNetworkImage(
                        imageUrl: Uri.parse(identityProvider.icon!)
                            .getDownloadLink(
                                Matrix.of(context).getLoginClient())
                            .toString(),
                        width: 32,
                        height: 32,
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              identityProvider.name ??
                  identityProvider.brand ??
                  L10n.of(context)!.singlesignon,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.subtitle2!.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final String? labelText;
  final Widget? icon;
  final void Function()? onPressed;

  const _LoginButton({
    Key? key,
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
      icon: icon!,
      label: Text(
        labelText!,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyText1!.color,
        ),
      ),
    );
  }
}
