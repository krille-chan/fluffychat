import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix/matrix.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/fluffy_share.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:fluffychat/widgets/avatar.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'settings.dart';

class SettingsView extends StatelessWidget {
  final SettingsController controller;

  const SettingsView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showChatBackupBanner = controller.showChatBackupBanner;
    return Scaffold(
      appBar: AppBar(
        leading: Center(
          child: CloseButton(
            onPressed: () => context.go('/rooms'),
          ),
        ),
        title: Text(L10n.of(context).settings),
      ),
      body: ListTileTheme(
        iconColor: theme.colorScheme.onSurface,
        child: ListView(
          key: const Key('SettingsListViewContent'),
          children: <Widget>[
            FutureBuilder<Profile>(
              future: controller.profileFuture,
              builder: (context, snapshot) {
                final profile = snapshot.data;
                final mxid =
                    Matrix.of(context).client.userID ?? L10n.of(context).user;
                final displayname =
                    profile?.displayName ?? mxid.localpart ?? mxid;
                return Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Stack(
                        children: [
                          Avatar(
                            mxContent: profile?.avatarUrl,
                            name: displayname,
                            size: Avatar.defaultSize * 2.5,
                          ),
                          if (profile != null)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: FloatingActionButton.small(
                                elevation: 2,
                                onPressed: controller.setAvatarAction,
                                heroTag: null,
                                child: const Icon(Icons.camera_alt_outlined),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton.icon(
                            onPressed: controller.setDisplaynameAction,
                            icon: const Icon(
                              Icons.edit_outlined,
                              size: 16,
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: theme.colorScheme.onSurface,
                            ),
                            label: Text(
                              displayname,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => FluffyShare.share(mxid, context),
                            icon: const Icon(
                              Icons.copy_outlined,
                              size: 14,
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: theme.colorScheme.secondary,
                            ),
                            label: Text(
                              mxid,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              //    style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            Divider(color: theme.dividerColor),
            if (showChatBackupBanner == null)
              ListTile(
                leading: const Icon(Icons.backup_outlined),
                title: Text(L10n.of(context).chatBackup),
                trailing: const CircularProgressIndicator.adaptive(),
              )
            else
              SwitchListTile.adaptive(
                controlAffinity: ListTileControlAffinity.trailing,
                value: controller.showChatBackupBanner == false,
                secondary: const Icon(Icons.backup_outlined),
                title: Text(L10n.of(context).chatBackup),
                onChanged: controller.firstRunBootstrapAction,
              ),
            Divider(
              color: theme.dividerColor,
            ),
            ListTile(
              leading: const Icon(Icons.format_paint_outlined),
              title: Text(L10n.of(context).changeTheme),
              onTap: () => context.go('/rooms/settings/style'),
            ),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: Text(L10n.of(context).notifications),
              onTap: () => context.go('/rooms/settings/notifications'),
            ),
            ListTile(
              leading: const Icon(Icons.devices_outlined),
              title: Text(L10n.of(context).devices),
              onTap: () => context.go('/rooms/settings/devices'),
            ),
            ListTile(
              leading: const Icon(Icons.forum_outlined),
              title: Text(L10n.of(context).chat),
              onTap: () => context.go('/rooms/settings/chat'),
            ),
            ListTile(
              leading: const Icon(Icons.shield_outlined),
              title: Text(L10n.of(context).security),
              onTap: () => context.go('/rooms/settings/security'),
            ),
            Divider(color: theme.dividerColor),
            ListTile(
              leading: const Icon(Icons.help_outline_outlined),
              title: Text(L10n.of(context).help),
              onTap: () => launchUrlString(AppConfig.supportUrl),
            ),
            ListTile(
              leading: const Icon(Icons.shield_sharp),
              title: Text(L10n.of(context).privacy),
              onTap: () => launchUrlString(AppConfig.privacyUrl),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: Text(L10n.of(context).about),
              onTap: () => PlatformInfos.showDialog(context),
            ),
            Divider(color: theme.dividerColor),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: Text(L10n.of(context).logout),
              onTap: controller.logoutAction,
            ),
          ],
        ),
      ),
    );
  }
}
