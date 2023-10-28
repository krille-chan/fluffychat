import 'package:flutter/material.dart';

import 'matrix.dart';

class SettingsSwitchListTile extends StatefulWidget {
  final bool defaultValue;
  final String storeKey;
  final String title;
  final Function(bool)? onChanged;

  const SettingsSwitchListTile.adaptive({
    super.key,
    this.defaultValue = false,
    required this.storeKey,
    required this.title,
    this.onChanged,
  });

  @override
  SettingsSwitchListTileState createState() => SettingsSwitchListTileState();
}

class SettingsSwitchListTileState extends State<SettingsSwitchListTile> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Matrix.of(context)
          .store
          .getItemBool(widget.storeKey, widget.defaultValue),
      builder: (context, snapshot) => SwitchListTile.adaptive(
        value: snapshot.data ?? widget.defaultValue,
        title: Text(widget.title),
        onChanged: (bool newValue) async {
          widget.onChanged?.call(newValue);
          await Matrix.of(context).store.setItemBool(widget.storeKey, newValue);
          setState(() {});
        },
      ),
    );
  }
}
