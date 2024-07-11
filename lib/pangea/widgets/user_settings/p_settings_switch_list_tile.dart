import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/models/user_model.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';

class ProfileSettingsSwitchListTile extends StatefulWidget {
  final bool defaultValue;
  final MatrixProfileEnum profileKey;
  final String title;
  final String? subtitle;

  const ProfileSettingsSwitchListTile.adaptive({
    super.key,
    this.defaultValue = false,
    required this.profileKey,
    required this.title,
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
    currentValue = MatrixState.pangeaController.userController.matrixProfile
            .getProfileData(
          widget.profileKey,
        ) ??
        widget.defaultValue;
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
          MatrixState.pangeaController.userController.matrixProfile
              .saveProfileData({
            widget.profileKey.title: newValue,
          });
          setState(() => currentValue = newValue);
        } catch (err, s) {
          ErrorHandler.logError(
            e: err,
            m: "Failed to updates user setting ${widget.profileKey.title}",
            s: s,
          );
        }
      },
    );
  }
}
