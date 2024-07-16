import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:flutter/material.dart';

class ProfileSettingsSwitchListTile extends StatefulWidget {
  final bool defaultValue;
  final String title;
  final String? subtitle;
  final Function(bool) onChange;

  const ProfileSettingsSwitchListTile.adaptive({
    super.key,
    required this.defaultValue,
    required this.title,
    required this.onChange,
    this.subtitle,
  });

  @override
  PSettingsSwitchListTileState createState() => PSettingsSwitchListTileState();
}

class PSettingsSwitchListTileState
    extends State<ProfileSettingsSwitchListTile> {
  bool currentValue = true;

  @override
  void initState() {
    currentValue = widget.defaultValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      value: currentValue,
      title: Text(widget.title),
      activeColor: AppConfig.activeToggleColor,
      subtitle: widget.subtitle != null ? Text(widget.subtitle!) : null,
      onChanged: (bool newValue) async {
        try {
          widget.onChange(newValue);
          setState(() => currentValue = newValue);
        } catch (err, s) {
          ErrorHandler.logError(
            e: err,
            m: "Failed to updates user setting",
            s: s,
          );
        }
      },
    );
  }
}
