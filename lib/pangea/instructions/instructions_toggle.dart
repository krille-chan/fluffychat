import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/config/app_config.dart';
import 'package:fluffychat/pangea/common/controllers/pangea_controller.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// User can toggle on to prevent Instruction Card
/// from appearing in future sessions
class InstructionsToggle extends StatefulWidget {
  const InstructionsToggle({
    super.key,
    required this.instructionsKey,
  });

  final InstructionsEnum instructionsKey;

  @override
  InstructionsToggleState createState() => InstructionsToggleState();
}

class InstructionsToggleState extends State<InstructionsToggle> {
  PangeaController pangeaController = MatrixState.pangeaController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      activeColor: AppConfig.activeToggleColor,
      title: Text(L10n.of(context).doNotShowAgain),
      value: widget.instructionsKey.isToggledOff,
      onChanged: ((value) async {
        widget.instructionsKey.setToggledOff(value);
        setState(() {});
      }),
    );
  }
}
