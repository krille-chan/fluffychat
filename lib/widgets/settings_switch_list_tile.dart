import 'package:flutter/material.dart';

import 'matrix.dart';

class SettingsSwitchListTile extends StatefulWidget {
  final bool defaultValue;
  final String storeKey;
  final String title;
  final String? subtitle;
  final Function(bool)? onChanged;

  const SettingsSwitchListTile.adaptive({
    super.key,
    this.defaultValue = false,
    required this.storeKey,
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
      value: Matrix.of(context).store.getBool(widget.storeKey) ??
          widget.defaultValue,
      title: Text(widget.title),
      subtitle: subtitle == null ? null : Text(subtitle),
      onChanged: (bool newValue) async {
        widget.onChanged?.call(newValue);
        await Matrix.of(context).store.setBool(widget.storeKey, newValue);
        setState(() {});
      },
    );
  }
}
