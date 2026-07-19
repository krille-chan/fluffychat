// SPDX-FileCopyrightText: 2019-Present Christian Kußowski
// SPDX-FileCopyrightText: 2019-Present Contributors to FluffyChat
//
// SPDX-License-Identifier: AGPL-3.0-or-later

import 'package:fluffychat/config/setting_keys.dart';
import 'package:flutter/material.dart';

class SettingsSwitchListTile extends StatefulWidget {
  final AppSettings<bool?> setting;
  final String title;
  final String? subtitle;
  final Function(bool)? onChanged;
  final bool? defaultValue;

  const SettingsSwitchListTile.adaptive({
    super.key,
    required this.setting,
    required this.title,
    this.subtitle,
    this.onChanged,
    this.defaultValue,
  });

  @override
  SettingsSwitchListTileState createState() => SettingsSwitchListTileState();
}

class SettingsSwitchListTileState extends State<SettingsSwitchListTile> {
  @override
  Widget build(BuildContext context) {
    final subtitle = widget.subtitle;
    return SwitchListTile.adaptive(
      value: widget.setting.value ?? widget.defaultValue ?? false,
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
