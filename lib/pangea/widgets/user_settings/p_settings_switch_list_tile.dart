import 'package:flutter/material.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/controllers/pangea_controller.dart';
import 'package:fluffychat/widgets/matrix.dart';

class PSettingsSwitchListTile extends StatefulWidget {
  final bool defaultValue;
  final String pStoreKey;
  final String title;
  final String? subtitle;

  const PSettingsSwitchListTile.adaptive({
    super.key,
    this.defaultValue = false,
    required this.pStoreKey,
    required this.title,
    this.subtitle,
  });

  @override
  PSettingsSwitchListTileState createState() => PSettingsSwitchListTileState();
}

class PSettingsSwitchListTileState extends State<PSettingsSwitchListTile> {
  @override
  Widget build(BuildContext context) {
    final PangeaController pangeaController = MatrixState.pangeaController;
    return SwitchListTile.adaptive(
      value: pangeaController.pStoreService.read(widget.pStoreKey) ??
          widget.defaultValue,
      title: Text(widget.title),
      activeColor: AppConfig.activeToggleColor,
      subtitle: widget.subtitle != null ? Text(widget.subtitle!) : null,
      onChanged: (bool newValue) async {
        pangeaController.pStoreService.save(widget.pStoreKey, newValue);
        setState(() {});
      },
    );
  }
}
