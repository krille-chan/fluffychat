import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return LoginScaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height / 2.5),
                    child: Image.asset(
                      'assets/info-logo.png',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: controller.homeserverController,
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
                onPressed: controller.checkHomeserverAction,
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
