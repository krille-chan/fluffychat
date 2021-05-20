import 'package:famedlysdk/famedlysdk.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:fluffychat/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_noti_settings/open_noti_settings.dart';

import 'ui/settings_notifications_ui.dart';
import 'widgets/matrix.dart';

class NotificationSettingsItem {
  final PushRuleKind type;
  final String key;
  final String Function(BuildContext) title;
  const NotificationSettingsItem(this.type, this.key, this.title);
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
}

class SettingsNotifications extends StatefulWidget {
  @override
  SettingsNotificationsController createState() =>
      SettingsNotificationsController();
}

class SettingsNotificationsController extends State<SettingsNotifications> {
  void openAndroidNotificationSettingsAction() async {
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

  bool getNotificationSetting(NotificationSettingsItem item) {
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

  void setNotificationSetting(NotificationSettingsItem item, bool enabled) {
    showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context).client.setPushRuleEnabled(
            'global',
            item.type,
            item.key,
            enabled,
          ),
    );
  }

  @override
  Widget build(BuildContext context) => SettingsNotificationsUI(this);
}
