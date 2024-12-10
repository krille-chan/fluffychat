import 'package:flutter/material.dart';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/utils/localized_exception_extension.dart';
import 'package:fluffychat/widgets/adaptive_dialogs/show_modal_action_popup.dart';
import 'package:fluffychat/widgets/future_loading_dialog.dart';
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
      '.m.rule.message',
      (c) => L10n.of(c).allRooms,
    ),
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
  const SettingsNotifications({super.key});

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

  bool isLoading = false;

  void setNotificationSetting(
    NotificationSettingsItem item,
    bool enabled,
  ) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    setState(() {
      isLoading = true;
    });
    try {
      await Matrix.of(context).client.setPushRuleEnabled(
            item.type,
            item.key,
            enabled,
          );
    } catch (e, s) {
      Logs().w('Unable to change notification settings', e, s);
      scaffoldMessenger
          .showSnackBar(SnackBar(content: Text(e.toLocalizedString(context))));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void onToggleMuteAllNotifications() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    setState(() {
      isLoading = true;
    });
    try {
      await Matrix.of(context).client.setMuteAllPushNotifications(
            !Matrix.of(context).client.allPushNotificationsMuted,
          );
    } catch (e, s) {
      Logs().w('Unable to change notification settings', e, s);
      scaffoldMessenger
          .showSnackBar(SnackBar(content: Text(e.toLocalizedString(context))));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void onPusherTap(Pusher pusher) async {
    final delete = await showModalActionPopup<bool>(
      context: context,
      title: pusher.deviceDisplayName,
      message: '${pusher.appDisplayName} (${pusher.appId})',
      cancelLabel: L10n.of(context).cancel,
      actions: [
        AdaptiveModalAction(
          label: L10n.of(context).delete,
          isDestructive: true,
          value: true,
        ),
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
