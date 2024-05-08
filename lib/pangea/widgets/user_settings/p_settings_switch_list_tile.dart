import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/utils/error_handler.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:flutter/material.dart';

class PSettingsSwitchListTile extends StatefulWidget {
  final bool defaultValue;
  final String pStoreKey;
  final String title;
  final String? subtitle;
  final bool local;

  const PSettingsSwitchListTile.adaptive({
    super.key,
    this.defaultValue = false,
    required this.pStoreKey,
    required this.title,
    this.subtitle,
    this.local = false,
  });

  @override
  PSettingsSwitchListTileState createState() => PSettingsSwitchListTileState();
}

class PSettingsSwitchListTileState extends State<PSettingsSwitchListTile> {
  bool currentValue = true;

  @override
  void initState() {
    currentValue = MatrixState.pangeaController.pStoreService.read(
          widget.pStoreKey,
          local: widget.local,
        ) ??
        widget.defaultValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PangeaController pangeaController = MatrixState.pangeaController;
    return SwitchListTile.adaptive(
      value: currentValue,
      title: Text(widget.title),
      activeColor: AppConfig.activeToggleColor,
      subtitle: widget.subtitle != null ? Text(widget.subtitle!) : null,
      onChanged: (bool newValue) async {
        try {
          await pangeaController.pStoreService.save(
            widget.pStoreKey,
            newValue,
            local: widget.local,
          );
          currentValue = newValue;
        } catch (err, s) {
          ErrorHandler.logError(
            e: err,
            m: "Failed to updates user setting ${widget.pStoreKey}",
            s: s,
          );
        }
        setState(() {});
      },
    );
  }
}
