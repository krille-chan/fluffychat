import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vrouter/vrouter.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import '../../config/app_config.dart';
import '../../widgets/content_banner.dart';
import 'settings.dart';

class SettingsView extends StatelessWidget {
  final SettingsController controller;

  const SettingsView(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
            <Widget>[
          SliverAppBar(
            expandedHeight: 300.0,
            floating: true,
            pinned: true,
            title: Text(L10n.of(context).settings),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              background: ContentBanner(
                controller.profile?.avatarUrl,
                onEdit: controller.setAvatarAction,
                defaultIcon: CupertinoIcons.person_circle,
              ),
            ),
          ),
        ],
        body: ListView(
          children: <Widget>[
            ListTile(
              title: Text(L10n.of(context).changeTheme),
              onTap: () => VRouter.of(context).to('/settings/style'),
              leading: const Icon(CupertinoIcons.paintbrush),
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.bell),
              title: Text(L10n.of(context).notifications),
              onTap: () => VRouter.of(context).to('/settings/notifications'),
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.device_phone_portrait),
              title: Text(L10n.of(context).devices),
              onTap: () => VRouter.of(context).to('/settings/devices'),
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.chat_bubble_2),
              title: Text(L10n.of(context).chat),
              onTap: () => VRouter.of(context).to('/settings/chat'),
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.person),
              title: Text(L10n.of(context).account),
              onTap: () => VRouter.of(context).to('/settings/account'),
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.shield),
              title: Text(L10n.of(context).security),
              onTap: () => VRouter.of(context).to('/settings/security'),
            ),
            const Divider(thickness: 1),
            ListTile(
              leading: const Icon(CupertinoIcons.question_circle),
              title: Text(L10n.of(context).help),
              onTap: () => launch(AppConfig.supportUrl),
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.checkmark_shield),
              title: Text(L10n.of(context).privacy),
              onTap: () => launch(AppConfig.privacyUrl),
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.info_circle),
              title: Text(L10n.of(context).about),
              onTap: () => PlatformInfos.showDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}
