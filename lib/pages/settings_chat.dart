import 'package:flutter/material.dart';

import 'views/settings_chat_view.dart';

class SettingsChat extends StatefulWidget {
  const SettingsChat({Key key}) : super(key: key);

  @override
  SettingsChatController createState() => SettingsChatController();
}

class SettingsChatController extends State<SettingsChat> {
  @override
  Widget build(BuildContext context) => SettingsChatView(this);
}
