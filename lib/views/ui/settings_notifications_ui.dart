import 'dart:io';

import 'package:famedlysdk/famedlysdk.dart';
import 'package:fluffychat/views/widgets/max_width_body.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import '../../utils/localized_exception_extension.dart';

import '../settings_notifications.dart';
import '../widgets/matrix.dart';

class SettingsNotificationsUI extends StatelessWidget {
  final SettingsNotificationsController controller;

  const SettingsNotificationsUI(this.controller, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(L10n.of(context).notifications),
      ),
      body: MaxWidthBody(
        withScrolling: true,
        child: StreamBuilder(
            stream: Matrix.of(context)
                .client
                .onAccountData
                .stream
                .where((event) => event.type == 'm.push_rules'),
            builder: (BuildContext context, _) {
              return Column(
                children: [
                  SwitchListTile(
                    value: !Matrix.of(context).client.allPushNotificationsMuted,
                    title: Text(
                        L10n.of(context).notificationsEnabledForThisAccount),
                    onChanged: (_) => showFutureLoadingDialog(
                      context: context,
                      future: () =>
                          Matrix.of(context).client.setMuteAllPushNotifications(
                                !Matrix.of(context)
                                    .client
                                    .allPushNotificationsMuted,
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
                        onTap: controller.openAndroidNotificationSettingsAction,
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
                    for (var item in NotificationSettingsItem.items)
                      SwitchListTile(
                        value: controller.getNotificationSetting(item) ?? true,
                        title: Text(item.title(context)),
                        onChanged: (bool enabled) =>
                            controller.setNotificationSetting(item, enabled),
                      ),
                  },
                  Divider(thickness: 1),
                  ListTile(
                    title: Text(
                      L10n.of(context).devices,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FutureBuilder<List<Pusher>>(
                    future: Matrix.of(context).client.requestPushers(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        Center(
                          child: Text(
                            snapshot.error.toLocalizedString(context),
                          ),
                        );
                      }
                      if (snapshot.connectionState != ConnectionState.done) {
                        Center(child: CircularProgressIndicator());
                      }
                      final pushers = snapshot.data ?? [];
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: pushers.length,
                        itemBuilder: (_, i) => ListTile(
                          title: Text(
                              '${pushers[i].appDisplayName} - ${pushers[i].appId}'),
                          subtitle: Text(pushers[i].data.url.toString()),
                        ),
                      );
                    },
                  ),
                ],
              );
            }),
      ),
    );
  }
}
