import 'package:flutter/material.dart';

import 'package:fluffychat/config/setting_keys.dart';

class SettingsSwitchListTile extends StatefulWidget {
  final AppSettings<bool> setting;
  final String title;
  final String? subtitle;
  final Function(bool)? onChanged;

  const SettingsSwitchListTile.adaptive({
    super.key,
    required this.setting,
    required this.title,
    this.subtitle,
    this.onChanged,
  });

  @override
  SettingsSwitchListTileState createState() => SettingsSwitchListTileState();
}

class SettingsSwitchListTileState extends State<SettingsSwitchListTile> {
  @override
  Widget build(BuildContext context) {
    final subtitle = widget.subtitle;
    return SwitchListTile.adaptive(
      value: widget.setting.value,
      title: Text(widget.title),
      subtitle: subtitle == null ? null : Text(subtitle),
      onChanged: (bool newValue) async {
        widget.onChanged?.call(newValue);
        await widget.setting.setItem(newValue);
        setState(() {});
      },
    );
  }
}
