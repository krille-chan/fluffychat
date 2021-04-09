import 'package:fluffychat/controllers/homeserver_picker_controller.dart';
import 'package:fluffychat/views/widgets/default_app_bar_search_field.dart';
import 'package:fluffychat/views/widgets/fluffy_banner.dart';
import 'package:fluffychat/app_config.dart';
import 'package:fluffychat/views/widgets/one_page_card.dart';
import 'package:fluffychat/utils/platform_infos.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeserverPickerView extends StatelessWidget {
  final HomeserverPickerController controller;

  const HomeserverPickerView(
    this.controller, {
    Key key,
  }) : super(key: key);

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
            suffix: Icon(Icons.edit_outlined),
            padding: EdgeInsets.zero,
            onChanged: (s) => controller.domain = s,
            readOnly: !AppConfig.allowOtherHomeservers,
            onSubmit: (_) => controller.checkHomeserverAction,
          ),
          elevation: 0,
        ),
        body: SafeArea(
          child: ListView(
            children: [
              Hero(
                tag: 'loginBanner',
                child: FluffyBanner(),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  AppConfig.applicationWelcomeMessage ??
                      L10n.of(context).welcomeText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: 'loginButton',
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: ElevatedButton(
                  onPressed: controller.isLoading
                      ? null
                      : controller.checkHomeserverAction,
                  child: controller.isLoading
                      ? LinearProgressIndicator()
                      : Text(
                          L10n.of(context).connect.toUpperCase(),
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              ),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                TextButton(
                  onPressed: () => launch(AppConfig.privacyUrl),
                  child: Text(
                    L10n.of(context).privacy,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => PlatformInfos.showDialog(context),
                  child: Text(
                    L10n.of(context).about,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
