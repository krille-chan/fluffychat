import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vrouter/vrouter.dart';

import '../../widgets/content_banner.dart';
import '../../config/app_config.dart';
import '../settings.dart';

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
            backgroundColor: Theme.of(context).appBarTheme.color,
            flexibleSpace: FlexibleSpaceBar(
              background: ContentBanner(
                controller.profile?.avatarUrl,
                onEdit: controller.setAvatarAction,
                defaultIcon: Icons.account_circle_outlined,
              ),
            ),
          ),
        ],
        body: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.notifications_outlined),
              title: Text(L10n.of(context).notifications),
              onTap: () => VRouter.of(context).push('/settings/notifications'),
            ),
            ListTile(
              leading: Icon(Icons.chat_bubble_outline),
              title: Text(L10n.of(context).chat),
              onTap: () => VRouter.of(context).push('/settings/chat'),
            ),
            ListTile(
              leading: Icon(Icons.account_box_outlined),
              title: Text(L10n.of(context).account),
              onTap: () => VRouter.of(context).push('/settings/account'),
            ),
            ListTile(
              leading: Icon(Icons.security_outlined),
              title: Text(L10n.of(context).security),
              onTap: () => VRouter.of(context).push('/settings/security'),
            ),
            Divider(thickness: 1),
            ListTile(
              leading: Icon(Icons.help_outlined),
              title: Text(L10n.of(context).help),
              onTap: () => launch(AppConfig.supportUrl),
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip_outlined),
              title: Text(L10n.of(context).privacy),
              onTap: () => launch(AppConfig.privacyUrl),
            ),
            ListTile(
              leading: Icon(Icons.link_outlined),
              title: Text(L10n.of(context).about),
              onTap: () => PlatformInfos.showDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}
