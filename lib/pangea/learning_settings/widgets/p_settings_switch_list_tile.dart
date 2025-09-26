import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/common/utils/error_handler.dart';

class ProfileSettingsSwitchListTile extends StatefulWidget {
  final bool defaultValue;
  final String title;
  final String? subtitle;
  final Function(bool) onChange;
  final bool enabled;

  const ProfileSettingsSwitchListTile.adaptive({
    super.key,
    required this.defaultValue,
    required this.title,
    required this.onChange,
    this.enabled = true,
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
  void didUpdateWidget(ProfileSettingsSwitchListTile oldWidget) {
    if (oldWidget.defaultValue != widget.defaultValue) {
      setState(() => currentValue = widget.defaultValue);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      value: currentValue,
      title: Text(widget.title),
      activeThumbColor: AppConfig.activeToggleColor,
      subtitle: widget.subtitle != null ? Text(widget.subtitle!) : null,
      onChanged: widget.enabled
          ? (bool newValue) async {
              try {
                widget.onChange(newValue);
                setState(() => currentValue = newValue);
              } catch (err, s) {
                ErrorHandler.logError(
                  e: err,
                  m: "Failed to updates user setting",
                  s: s,
                  data: {
                    "newValue": newValue,
                    "currentValue": currentValue,
                  },
                );
              }
            }
          : null,
    );
  }
}
