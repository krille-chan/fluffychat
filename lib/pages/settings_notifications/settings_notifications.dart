import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:matrix/matrix.dart';

import '../../widgets/matrix.dart';
import 'settings_notifications_view.dart';

class NotificationSettingsItem {
  final PushRuleKind type;
  final String key;
  final String Function(BuildContext) title;
  const NotificationSettingsItem(this.type, this.key, this.title);
  static List<NotificationSettingsItem> items = [
    NotificationSettingsItem(
      PushRuleKind.underride,
      '.m.rule.room_one_to_one',
      (c) => L10n.of(c)!.directChats,
    ),
    NotificationSettingsItem(
      PushRuleKind.override,
      '.m.rule.contains_display_name',
      (c) => L10n.of(c)!.containsDisplayName,
    ),
    NotificationSettingsItem(
      PushRuleKind.content,
      '.m.rule.contains_user_name',
      (c) => L10n.of(c)!.containsUserName,
    ),
    NotificationSettingsItem(
      PushRuleKind.override,
      '.m.rule.invite_for_me',
      (c) => L10n.of(c)!.inviteForMe,
    ),
    NotificationSettingsItem(
      PushRuleKind.override,
      '.m.rule.member_event',
      (c) => L10n.of(c)!.memberChanges,
    ),
    NotificationSettingsItem(
      PushRuleKind.override,
      '.m.rule.suppress_notices',
      (c) => L10n.of(c)!.botMessages,
    ),
  ];
}

class SettingsNotifications extends StatefulWidget {
  const SettingsNotifications({Key? key}) : super(key: key);

  @override
  SettingsNotificationsController createState() =>
      SettingsNotificationsController();
}

class SettingsNotificationsController extends State<SettingsNotifications> {
  bool? getNotificationSetting(NotificationSettingsItem item) {
    final pushRules = Matrix.of(context).client.globalPushRules;
    if (pushRules == null) return null;
    switch (item.type) {
      case PushRuleKind.content:
        return pushRules.content
            ?.singleWhereOrNull((r) => r.ruleId == item.key)
            ?.enabled;
      case PushRuleKind.override:
        return pushRules.override
            ?.singleWhereOrNull((r) => r.ruleId == item.key)
            ?.enabled;
      case PushRuleKind.room:
        return pushRules.room
            ?.singleWhereOrNull((r) => r.ruleId == item.key)
            ?.enabled;
      case PushRuleKind.sender:
        return pushRules.sender
            ?.singleWhereOrNull((r) => r.ruleId == item.key)
            ?.enabled;
      case PushRuleKind.underride:
        return pushRules.underride
            ?.singleWhereOrNull((r) => r.ruleId == item.key)
            ?.enabled;
    }
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

  void onPusherTap(Pusher pusher) async {
    final delete = await showModalActionSheet<bool>(
      context: context,
      title: pusher.deviceDisplayName,
      message: '${pusher.appDisplayName} (${pusher.appId})',
      actions: [
        SheetAction(
          label: L10n.of(context)!.delete,
          isDestructiveAction: true,
          key: true,
        )
      ],
    );
    if (delete != true) return;

    final success = await showFutureLoadingDialog(
      context: context,
      future: () => Matrix.of(context).client.deletePusher(
            PusherId(
              appId: pusher.appId,
              pushkey: pusher.pushkey,
            ),
          ),
    );

    if (success.error != null) return;

    setState(() {
      pusherFuture = null;
    });
  }

  Future<List<Pusher>?>? pusherFuture;

  @override
  Widget build(BuildContext context) => SettingsNotificationsView(this);
}
