// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'settings_chat_view.dart';

class SettingsChat extends StatefulWidget {
  const SettingsChat({super.key});

  @override
  SettingsChatController createState() => SettingsChatController();
}

class SettingsChatController extends State<SettingsChat> {
  @override
  Widget build(BuildContext context) => SettingsChatView(this);
}
