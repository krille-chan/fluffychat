import 'package:flutter/material.dart';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/config/setting_keys.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'settings_chat_view.dart';

class SettingsChat extends StatefulWidget {
  const SettingsChat({Key? key}) : super(key: key);

  @override
  SettingsChatController createState() => SettingsChatController();
}

class SettingsChatController extends State<SettingsChat> {
  void setJitsiInstanceAction() async {
    const prefix = 'https://';
    final input = await showTextInputDialog(
      useRootNavigator: false,
      context: context,
      title: L10n.of(context)!.editJitsiInstance,
      okLabel: L10n.of(context)!.ok,
      cancelLabel: L10n.of(context)!.cancel,
      textFields: [
        DialogTextField(
          initialText: AppConfig.jitsiInstance.replaceFirst(prefix, ''),
          prefixText: prefix,
        ),
      ],
    );
    if (input == null) return;
    var jitsi = prefix + input.single;
    if (!jitsi.endsWith('/')) {
      jitsi += '/';
    }
    final matrix = Matrix.of(context);
    await matrix.store.setItem(SettingKeys.jitsiInstance, jitsi);
    AppConfig.jitsiInstance = jitsi;
  }

  @override
  Widget build(BuildContext context) => SettingsChatView(this);
}
