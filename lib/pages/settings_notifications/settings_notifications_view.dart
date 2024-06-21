import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:matrix/matrix.dart';

import 'package:fluffychat/widgets/layouts/max_width_body.dart';
import '../../utils/localized_exception_extension.dart';
import '../../widgets/matrix.dart';
import 'settings_notifications.dart';

class SettingsNotificationsView extends StatelessWidget {
  final SettingsNotificationsController controller;

  const SettingsNotificationsView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Center(child: BackButton()),
        title: Text(L10n.of(context)!.notifications),
      ),
      body: MaxWidthBody(
        child: StreamBuilder(
          stream: Matrix.of(context).client.onSync.stream.where(
                (syncUpdate) =>
                    syncUpdate.accountData?.any(
                      (accountData) => accountData.type == 'm.push_rules',
                    ) ??
                    false,
              ),
          builder: (BuildContext context, _) {
            return Column(
              children: [
                SwitchListTile.adaptive(
                  value: !Matrix.of(context).client.allPushNotificationsMuted,
                  title: Text(
                    L10n.of(context)!.notificationsEnabledForThisAccount,
                  ),
                  onChanged: controller.isLoading
                      ? null
                      : (_) => controller.onToggleMuteAllNotifications(),
                ),
                Divider(color: Theme.of(context).dividerColor),
                ListTile(
                  title: Text(
                    L10n.of(context)!.notifyMeFor,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                for (final item in NotificationSettingsItem.items)
                  SwitchListTile.adaptive(
                    value: Matrix.of(context).client.allPushNotificationsMuted
                        ? false
                        : controller.getNotificationSetting(item) ?? true,
                    title: Text(item.title(context)),
                    onChanged: controller.isLoading
                        ? null
                        : Matrix.of(context).client.allPushNotificationsMuted
                            ? null
                            : (bool enabled) => controller
                                .setNotificationSetting(item, enabled),
                  ),
                Divider(color: Theme.of(context).dividerColor),
                ListTile(
                  title: Text(
                    L10n.of(context)!.devices,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                FutureBuilder<List<Pusher>?>(
                  future: controller.pusherFuture ??=
                      Matrix.of(context).client.getPushers(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      Center(
                        child: Text(
                          snapshot.error!.toLocalizedString(context),
                        ),
                      );
                    }
                    if (snapshot.connectionState != ConnectionState.done) {
                      const Center(
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 2,
                        ),
                      );
                    }
                    final pushers = snapshot.data ?? [];
                    if (pushers.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(L10n.of(context)!.noOtherDevicesFound),
                        ),
                      );
                    }
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: pushers.length,
                      itemBuilder: (_, i) => ListTile(
                        title: Text(
                          '${pushers[i].appDisplayName} - ${pushers[i].appId}',
                        ),
                        subtitle: Text(pushers[i].data.url.toString()),
                        onTap: () => controller.onPusherTap(pushers[i]),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
