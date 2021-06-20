import 'package:adaptive_dialog/adaptive_dialog.dart';

import 'package:fluffychat/widgets/sentry_switch_list_tile.dart';
import 'package:fluffychat/widgets/settings_switch_list_tile.dart';

import 'package:matrix/matrix.dart';
import 'package:fluffychat/utils/beautify_string_extension.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/utils/platform_infos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vrouter/vrouter.dart';

import '../../widgets/content_banner.dart';
import '../../widgets/matrix.dart';
import '../../config/app_config.dart';
import '../../config/setting_keys.dart';
import '../settings.dart';

class SettingsView extends StatelessWidget {
  final SettingsController controller;

  const SettingsView(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final client = Matrix.of(context).client;
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
              title: Text(
                L10n.of(context).notifications,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              trailing: Icon(Icons.notifications_outlined),
              title: Text(L10n.of(context).notifications),
              onTap: () => VRouter.of(context).push('/settings/notifications'),
            ),
            Divider(thickness: 1),
            ListTile(
              title: Text(
                L10n.of(context).chat,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              title: Text(L10n.of(context).changeTheme),
              onTap: () => VRouter.of(context).push('/settings/style'),
              trailing: Icon(Icons.style_outlined),
            ),
            SettingsSwitchListTile(
              title: L10n.of(context).renderRichContent,
              onChanged: (b) => AppConfig.renderHtml = b,
              storeKey: SettingKeys.renderHtml,
              defaultValue: AppConfig.renderHtml,
            ),
            SettingsSwitchListTile(
              title: L10n.of(context).hideRedactedEvents,
              onChanged: (b) => AppConfig.hideRedactedEvents = b,
              storeKey: SettingKeys.hideRedactedEvents,
              defaultValue: AppConfig.hideRedactedEvents,
            ),
            SettingsSwitchListTile(
              title: L10n.of(context).hideUnknownEvents,
              onChanged: (b) => AppConfig.hideUnknownEvents = b,
              storeKey: SettingKeys.hideUnknownEvents,
              defaultValue: AppConfig.hideUnknownEvents,
            ),
            ListTile(
              title: Text(L10n.of(context).emoteSettings),
              onTap: () => VRouter.of(context).push('/settings/emotes'),
              trailing: Icon(Icons.insert_emoticon_outlined),
            ),
            Divider(thickness: 1),
            ListTile(
              title: Text(
                L10n.of(context).account,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              trailing: Icon(Icons.edit_outlined),
              title: Text(L10n.of(context).editDisplayname),
              subtitle: Text(
                  controller.profile?.displayname ?? client.userID.localpart),
              onTap: controller.setDisplaynameAction,
            ),
            ListTile(
              trailing: Icon(Icons.phone_outlined),
              title: Text(L10n.of(context).editJitsiInstance),
              subtitle: Text(AppConfig.jitsiInstance),
              onTap: controller.setJitsiInstanceAction,
            ),
            ListTile(
              trailing: Icon(Icons.devices_other_outlined),
              title: Text(L10n.of(context).devices),
              onTap: () => VRouter.of(context).push('/settings/devices'),
            ),
            ListTile(
              trailing: Icon(Icons.block_outlined),
              title: Text(L10n.of(context).ignoredUsers),
              onTap: () => VRouter.of(context).push('/settings/ignorelist'),
            ),
            SentrySwitchListTile(),
            Divider(thickness: 1),
            ListTile(
              trailing: Icon(Icons.security_outlined),
              title: Text(
                L10n.of(context).changePassword,
              ),
              onTap: controller.changePasswordAccountAction,
            ),
            ListTile(
              trailing: Icon(Icons.email_outlined),
              title: Text(L10n.of(context).passwordRecovery),
              onTap: () => VRouter.of(context).push('/settings/3pid'),
            ),
            ListTile(
              trailing: Icon(Icons.exit_to_app_outlined),
              title: Text(L10n.of(context).logout),
              onTap: controller.logoutAction,
            ),
            ListTile(
              trailing: Icon(Icons.delete_forever_outlined),
              title: Text(
                L10n.of(context).deleteAccount,
                style: TextStyle(color: Colors.red),
              ),
              onTap: controller.deleteAccountAction,
            ),
            if (client.encryption != null) ...{
              Divider(thickness: 1),
              ListTile(
                title: Text(
                  L10n.of(context).security,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (PlatformInfos.isMobile)
                ListTile(
                  trailing: Icon(Icons.lock_outlined),
                  title: Text(L10n.of(context).appLock),
                  onTap: controller.setAppLockAction,
                ),
              ListTile(
                title: Text(L10n.of(context).yourPublicKey),
                onTap: () => showOkAlertDialog(
                  useRootNavigator: false,
                  context: context,
                  title: L10n.of(context).yourPublicKey,
                  message: client.fingerprintKey.beautified,
                  okLabel: L10n.of(context).ok,
                ),
                trailing: Icon(Icons.vpn_key_outlined),
              ),
              ListTile(
                title: Text(L10n.of(context).cachedKeys),
                trailing: Icon(Icons.wb_cloudy_outlined),
                subtitle: Text(
                    '${client.encryption.keyManager.enabled ? L10n.of(context).onlineKeyBackupEnabled : L10n.of(context).onlineKeyBackupDisabled}\n${client.encryption.crossSigning.enabled ? L10n.of(context).crossSigningEnabled : L10n.of(context).crossSigningDisabled}'),
                onTap: controller.bootstrapSettingsAction,
              ),
            },
            Divider(thickness: 1),
            ListTile(
              title: Text(
                L10n.of(context).about,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => VRouter.of(context).push('/logs'),
            ),
            ListTile(
              trailing: Icon(Icons.help_outlined),
              title: Text(L10n.of(context).help),
              onTap: () => launch(AppConfig.supportUrl),
            ),
            ListTile(
              trailing: Icon(Icons.privacy_tip_outlined),
              title: Text(L10n.of(context).privacy),
              onTap: () => launch(AppConfig.privacyUrl),
            ),
            ListTile(
              trailing: Icon(Icons.link_outlined),
              title: Text(L10n.of(context).about),
              onTap: () => PlatformInfos.showDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}
