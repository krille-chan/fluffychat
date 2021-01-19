import 'package:flutter/material.dart';

import 'matrix.dart';

class SettingsSwitchListTile extends StatefulWidget {
  final bool defaultValue;
  final String storeKey;
  final String title;
  final Function(bool) onChanged;

  const SettingsSwitchListTile({
    Key key,
    this.defaultValue = false,
    @required this.storeKey,
    @required this.title,
    this.onChanged,
  }) : super(key: key);

  @override
  _SettingsSwitchListTileState createState() => _SettingsSwitchListTileState();
}

class _SettingsSwitchListTileState extends State<SettingsSwitchListTile> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Matrix.of(context).store.getItemBool(widget.storeKey),
      builder: (context, snapshot) => SwitchListTile(
        value: snapshot.data ?? widget.defaultValue,
        title: Text(widget.title),
        onChanged: (bool newValue) async {
          widget.onChanged?.call(newValue);
          await Matrix.of(context)
              .store
              .setItem(widget.storeKey, newValue.toString());
          setState(() => null);
        },
      ),
    );
  }
}
