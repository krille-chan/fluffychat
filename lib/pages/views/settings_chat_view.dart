import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import 'package:fluffychat/widgets/settings_switch_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../settings_chat.dart';

class SettingsChatView extends StatelessWidget {
  final SettingsChatController controller;
  const SettingsChatView(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context).chat)),
      body: MaxWidthBody(
        withScrolling: true,
        child: Column(
          children: [
            ListTile(
              title: Text(L10n.of(context).changeTheme),
              onTap: () => VRouter.of(context).to('style'),
              trailing: Icon(Icons.style_outlined),
            ),
            ListTile(
              title: Text(L10n.of(context).emoteSettings),
              onTap: () => VRouter.of(context).to('emotes'),
              trailing: Icon(Icons.insert_emoticon_outlined),
            ),
            Divider(height: 1),
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
          ],
        ),
      ),
    );
  }
}
