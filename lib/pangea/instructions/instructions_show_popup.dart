import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:fluffychat/pangea/bot/utils/bot_style.dart';
import 'package:fluffychat/pangea/bot/widgets/bot_face_svg.dart';
import 'package:fluffychat/pangea/choreographer/widgets/igc/card_header.dart';
import 'package:fluffychat/pangea/common/utils/overlay.dart';
import 'package:fluffychat/pangea/instructions/instructions_enum.dart';
import 'package:fluffychat/pangea/instructions/instructions_toggle.dart';
import 'package:fluffychat/widgets/matrix.dart';

/// Instruction Card gives users tips on
/// how to use Pangea Chat's features
Future<void> instructionsShowPopup(
  BuildContext context,
  InstructionsEnum key,
  String transformTargetKey, {
  bool showToggle = true,
  Widget? customContent,
  bool forceShow = false,
}) async {
  final bool userLangsSet =
      await MatrixState.pangeaController.userController.areUserLanguagesSet;
  if (!userLangsSet) {
    return;
  }

  // if ((_instructionsShown[key.toString()] ?? false) && !forceShow) {
  //   return;
  // }
  // _instructionsShown[key.toString()] = true;

  if (key.isToggledOff && !forceShow) {
    return;
  }

  final botStyle = BotStyle.text(context);
  Future.delayed(
    const Duration(seconds: 1),
    () {
      if (!context.mounted) return;
      OverlayUtil.showPositionedCard(
        context: context,
        backDropToDismiss: false,
        cardToShow: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CardHeader(
              text: key.title(L10n.of(context)),
              botExpression: BotExpression.idle,
              // onClose: () => {_instructionsClosed[key.toString()] = true},
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(
                key.body(L10n.of(context)),
                style: botStyle,
              ),
            ),
            if (customContent != null) customContent,
            if (showToggle) InstructionsToggle(instructionsKey: key),
          ],
        ),
        maxHeight: 300,
        maxWidth: 300,
        transformTargetId: transformTargetKey,
        closePrevOverlay: false,
        overlayKey: key.toString(),
      );
    },
  );
}
