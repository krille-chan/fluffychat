import 'dart:io';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:fluffychat/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_noti_settings/open_noti_settings.dart';

import '../components/matrix.dart';

class NotificationSettingsItem {
  final PushRuleKind type;
  final String key;
  final String Function(BuildContext) title;
  NotificationSettingsItem(this.type, this.key, this.title);
}

class SettingsNotifications extends StatelessWidget {
  static List<NotificationSettingsItem> items = [
    NotificationSettingsItem(
      PushRuleKind.underride,
      '.m.rule.room_one_to_one',
      (c) => L10n.of(c).directChats,
    ),
    NotificationSettingsItem(
      PushRuleKind.override,
      '.m.rule.contains_display_name',
      (c) => L10n.of(c).containsDisplayName,
    ),
    NotificationSettingsItem(
      PushRuleKind.content,
      '.m.rule.contains_user_name',
      (c) => L10n.of(c).containsUserName,
    ),
    NotificationSettingsItem(
      PushRuleKind.override,
      '.m.rule.invite_for_me',
      (c) => L10n.of(c).inviteForMe,
    ),
    NotificationSettingsItem(
      PushRuleKind.override,
      '.m.rule.member_event',
      (c) => L10n.of(c).memberChanges,
    ),
    NotificationSettingsItem(
      PushRuleKind.override,
      '.m.rule.suppress_notices',
      (c) => L10n.of(c).botMessages,
    ),
  ];
  void _openAndroidNotificationSettingsAction() async {
    await NotificationSetting.configureChannel(
      NotificationDetails(
        android: AndroidNotificationDetails(
          AppConfig.pushNotificationsChannelId,
          AppConfig.pushNotificationsChannelName,
          AppConfig.pushNotificationsChannelDescription,
        ),
      ),
    );
    return NotificationSetting.open();
  }

  bool _getNotificationSetting(
      BuildContext context, NotificationSettingsItem item) {
    final pushRules = Matrix.of(context).client.globalPushRules;
    switch (item.type) {
      case PushRuleKind.content:
        return pushRules.content
            ?.singleWhere((r) => r.ruleId == item.key, orElse: () => null)
            ?.enabled;
      case PushRuleKind.override:
        return pushRules.override
            ?.singleWhere((r) => r.ruleId == item.key, orElse: () => null)
            ?.enabled;
      case PushRuleKind.room:
        return pushRules.room
            ?.singleWhere((r) => r.ruleId == item.key, orElse: () => null)
            ?.enabled;
      case PushRuleKind.sender:
        return pushRules.sender
            ?.singleWhere((r) => r.ruleId == item.key, orElse: () => null)
            ?.enabled;
      case PushRuleKind.underride:
        return pushRules.underride
            ?.singleWhere((r) => r.ruleId == item.key, orElse: () => null)
            ?.enabled;
    }
    return false;
  }

  void _setNotificationSetting(
      BuildContext context, NotificationSettingsItem item, bool enabled) {
    showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context).client.enablePushRule(
            'global',
            item.type,
            item.key,
            enabled,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(L10n.of(context).notifications),
      ),
      body: StreamBuilder(
          stream: Matrix.of(context)
              .client
              .onAccountData
              .stream
              .where((event) => event.type == 'm.push_rules'),
          builder: (BuildContext context, _) {
            return ListView(
              children: [
                SwitchListTile(
                  value: !Matrix.of(context).client.allPushNotificationsMuted,
                  title:
                      Text(L10n.of(context).notificationsEnabledForThisAccount),
                  onChanged: (_) => showFutureLoadingDialog(
                    context: context,
                    future: () => Matrix.of(context)
                        .client
                        .setMuteAllPushNotifications(
                          !Matrix.of(context).client.allPushNotificationsMuted,
                        ),
                  ),
                ),
                if (!Matrix.of(context).client.allPushNotificationsMuted) ...{
                  if (!kIsWeb && Platform.isAndroid)
                    ListTile(
                      title: Text(L10n.of(context).soundVibrationLedColor),
                      trailing: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        foregroundColor: Colors.grey,
                        child: Icon(Icons.edit_outlined),
                      ),
                      onTap: () => _openAndroidNotificationSettingsAction(),
                    ),
                  Divider(thickness: 1),
                  ListTile(
                    title: Text(
                      L10n.of(context).pushRules,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  for (var item in items)
                    SwitchListTile(
                      value: _getNotificationSetting(context, item) ?? true,
                      title: Text(item.title(context)),
                      onChanged: (bool enabled) =>
                          _setNotificationSetting(context, item, enabled),
                    ),
                }
              ],
            );
          }),
    );
  }
}
