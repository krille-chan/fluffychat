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

  const SettingsView(this.controller, {Key? key}) : super(key: key);

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
            title: Text(L10n.of(context)!.settings),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              background: ContentBanner(
                mxContent: controller.profile?.avatarUrl,
                onEdit: controller.setAvatarAction,
                defaultIcon: Icons.account_circle_outlined,
              ),
            ),
          ),
        ],
        body: ListTileTheme(
          iconColor: Theme.of(context).colorScheme.onBackground,
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.format_paint_outlined),
                title: Text(L10n.of(context)!.changeTheme),
                onTap: () => VRouter.of(context).to('/settings/style'),
              ),
              const Divider(thickness: 1),
              ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: Text(L10n.of(context)!.notifications),
                onTap: () => VRouter.of(context).to('/settings/notifications'),
              ),
              ListTile(
                leading: const Icon(Icons.devices_outlined),
                title: Text(L10n.of(context)!.devices),
                onTap: () => VRouter.of(context).to('/settings/devices'),
              ),
              ListTile(
                leading: const Icon(Icons.chat_bubble_outline_outlined),
                title: Text(L10n.of(context)!.chat),
                onTap: () => VRouter.of(context).to('/settings/chat'),
              ),
              ListTile(
                leading: const Icon(Icons.account_circle_outlined),
                title: Text(L10n.of(context)!.account),
                onTap: () => VRouter.of(context).to('/settings/account'),
              ),
              ListTile(
                leading: const Icon(Icons.shield_outlined),
                title: Text(L10n.of(context)!.security),
                onTap: () => VRouter.of(context).to('/settings/security'),
              ),
              const Divider(thickness: 1),
              ListTile(
                leading: const Icon(Icons.help_outline_outlined),
                title: Text(L10n.of(context)!.help),
                onTap: () => launch(AppConfig.supportUrl),
              ),
              ListTile(
                leading: const Icon(Icons.shield_sharp),
                title: Text(L10n.of(context)!.privacy),
                onTap: () => launch(AppConfig.privacyUrl),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline_rounded),
                title: Text(L10n.of(context)!.about),
                onTap: () => PlatformInfos.showDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
